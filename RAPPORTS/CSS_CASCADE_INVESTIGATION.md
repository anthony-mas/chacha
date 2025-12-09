# Investigation: Pourquoi les changements de couleur Discover affectent les autres pages

**Date:** 9 décembre 2025
**Auteur:** Mahé
**Objet:** Comprendre les dépendances CSS et les variables partagées

---

## 📌 Le problème observé

Quand tu as changé la couleur du texte de la page **Discover** (titre, filtres, subtitle), cela a automatiquement changé les couleurs sur **d'autres pages** (events, etc.) → **tout est devenu blanc**.

**Question:** Pourquoi un changement sur UNE page affecte-t-il TOUTES les autres pages?

---

## 🔗 Les 3 niveaux de CSS qui se sont entrecroisés

### Niveau 1: Variables CSS globales (`:root`)
**Fichier:** `/app/assets/stylesheets/base/_variables.scss`

```scss
:root {
  --color-text-primary: #EEE9DF;      // Blanc cassé
  --color-primary: #111111;           // Noir (utilisé partout!)
  --color-title: var(--color-primary); // Hérite du noir
  --color-body-text: var(--color-primary); // Hérite du noir
}
```

**⚠️ PROBLÈME:** Ces variables sont **GLOBALES** - elles s'appliquent à TOUT le projet, pas juste à Discover!

---

### Niveau 2: Règles CSS génériques
**Fichier:** `/app/assets/stylesheets/base/_base.scss`

```scss
h1, h2, h3, h4 {
    color: var(--color-title);  // Tous les h1, h2, h3, h4 utilisent --color-title
}

p {
    color: var(--color-body-text);  // Tous les <p> utilisent --color-body-text
}

a {
    color: var(--color-title);  // Tous les <a> utilisent --color-title
}
```

**⚠️ PROBLÈME:** Ces règles s'appliquent à **TOUTES les pages**, pas juste Discover!

---

### Niveau 3: Surcharges spécifiques par page
**Fichier:** `/app/assets/stylesheets/pages/_discover.scss`

```scss
.discover-title {
    color: #FFFFFF !important;  // Force le blanc UNIQUEMENT sur Discover
}

.trending-subtitle {
    color: #FFFFFF !important;  // Force le blanc UNIQUEMENT sur Discover
}

.filter-tag {
    color: #FFFFFF !important;  // Force le blanc UNIQUEMENT sur les filtres
}
```

**✅ CORRECT:** Ces règles utilisent des classes spécifiques à Discover

---

## 🔴 Voici ce qui s'est passé

### Avant (CORRECT):
```
Body → utilise --color-body-text → noir (#111111) ✅
Events page → h1, p utilisent --color-primary → noir (#111111) ✅
Discover page → .discover-title force #FFFFFF !important → blanc ✅
```

### Après (LE BUG):
```
Tu changes _variables.scss et fais --color-primary: #ffff (blanc)
                                ↓
--color-title hérite de --color-primary → devient blanc
--color-body-text hérite de --color-primary → devient blanc
                                ↓
TOUTES les pages qui utilisent ces variables → TOUT devient blanc! ❌
Events, Dashboard, Homepage, etc. → TOUT blanc! 🚨
```

---

## 🎯 L'architecture du problème

```
┌─────────────────────────────────────────────┐
│  VARIABLES GLOBALES (:root)                 │
│  --color-primary: #111111                   │
│  --color-title: var(--color-primary)        │
│  --color-body-text: var(--color-primary)    │
└────────┬────────────────────────────────────┘
         │ (héritage direct)
         ↓
┌─────────────────────────────────────────────┐
│  RÈGLES GÉNÉRIQUES (_base.scss)             │
│  h1, h2, h3, h4 { color: var(--color-title) } │
│  p { color: var(--color-body-text) }        │
│  a { color: var(--color-title) }            │
└────────┬────────────────────────────────────┘
         │ (appliqué à TOUTES les pages)
         ↓
┌─────────────────────────────────────────────┐
│  TOUTES LES PAGES                           │
│  - Homepage  }                              │
│  - Events   } Utilisent les variables       │
│  - Discover } globales + règles génériques  │
│  - Dashboard}                               │
└─────────────────────────────────────────────┘
```

---

## 🔍 Pourquoi Discover a affecté tout le reste

**Découverte clé:** Tu as modifié `_variables.scss` (le fichier GLOBAL)

```scss
// Ce que tu as fait (MAUVAIS):
--color-primary: #ffff;  // Change LA VARIABLE GLOBALE

// Ce que tu aurais dû faire (BON):
// Laisser --color-primary: #111111
// Et utiliser des classes spécifiques comme tu l'as fait dans _discover.scss
```

**Analogie:** C'est comme si tu changeais l'eau du robinet principal de la maison
- Le changement affecte TOUS les robinets (cuisine, salle de bain, etc.)
- Pas juste le robinet du salon

---

## 📊 Tableau des dépendances

| Variable/Classe | Où elle est définie | Où elle est utilisée | Scope |
|---|---|---|---|
| `--color-primary` | `_variables.scss` | `_base.scss`, `_navbar.scss`, etc. | **GLOBAL** |
| `--color-title` | `_variables.scss` | `h1, h2, h3, h4` dans `_base.scss` | **GLOBAL** |
| `--color-body-text` | `_variables.scss` | `p` dans `_base.scss` | **GLOBAL** |
| `.discover-title` | `_discover.scss` | Discover page seulement | **LOCAL** |
| `.filter-tag` | `_discover.scss` | Discover page seulement | **LOCAL** |

---

## ✅ Les bonnes pratiques pour éviter ça

### ❌ MAUVAIS - Modifier les variables globales
```scss
// _variables.scss
--color-primary: #ffff;  // Affecte TOUTES les pages!
```

### ✅ BON - Utiliser des classes spécifiques
```scss
// _discover.scss
.discover-title {
    color: #FFFFFF !important;  // Affecte UNIQUEMENT Discover
}
```

### ✅ BON - Créer des variables locales si nécessaire
```scss
// _discover.scss
:root {
    --discover-text-color: #FFFFFF;  // Locale à Discover
}

.discover-page-container {
    color: var(--discover-text-color);
}
```

---

## 🧩 Ce qui aurait dû se passer

Au lieu de modifier `_variables.scss`, tu aurais dû:

1. **Garder les variables globales intactes**
   ```scss
   --color-primary: #111111;  // Reste noir pour les autres pages
   ```

2. **Utiliser des surcharges locales dans `_discover.scss`**
   ```scss
   .discover-page-container {
       /* Toutes les surcharges Discover ici */
   }
   ```

---

## 📚 Fichiers affectés par la modification de `_variables.scss`

Quand tu changes une variable globale, elle affecte **TOUS ces fichiers qui l'utilisent:**

```
_variables.scss (LA SOURCE)
    ↓
_base.scss (règles génériques h1, p, a, etc.)
    ↓
CHAQUE PAGE en hérite:
    - _home.scss
    - _discover.scss
    - _event_show.scss
    - _dashboard.scss
    - _navbar.scss
    - _buttons.scss
    - TOUTES les autres pages...
```

---

## 🔐 Résumé: Hiérarchie CSS et portée

```
┌─ GLOBAL (affecte tout)
│  └─ :root { --color-primary }
│     └─ _base.scss { h1, p, a }
│        └─ TOUTES LES PAGES en héritent
│
└─ LOCAL (affecte une page)
   └─ _discover.scss { .discover-title }
      └─ UNIQUEMENT Discover l'utilise
```

**Règle d'or:** Plus une variable/règle est générale, plus elle affecte de pages!

---

## 💡 Leçon apprendre

**Quand modifier quoi:**

| Besoin | Fichier | Portée |
|--------|---------|--------|
| Changer une couleur PARTOUT | `_variables.scss` | 🔴 GLOBAL (toutes pages) |
| Changer une couleur SUR UNE PAGE | `pages/_pagename.scss` | 🟢 LOCAL (une page) |
| Changer un composant | `components/_component.scss` | 🟡 COMPOSANT (utilisé partout) |
| Ajouter une police/spacing | `_variables.scss` | 🔴 GLOBAL (toutes pages) |

---

## 🎓 Conclusion

**Pourquoi tout est devenu blanc:**
1. Tu as changé `--color-primary` dans `_variables.scss` (GLOBAL)
2. `--color-title` et `--color-body-text` héritent de `--color-primary`
3. `h1, p, a` dans `_base.scss` utilisent ces variables (GLOBAL)
4. TOUTES les pages héritent de ces règles
5. Résultat: tout le texte du projet devient blanc! 🚨

**Comment l'éviter:**
- Laisser les variables globales intactes
- Utiliser des surcharges CSS spécifiques par page (classes locales)
- Ne modifier `_variables.scss` que si tu veux vraiment changer TOUTES les pages

---

**Status:** ✅ ANALYSÉ ET COMPRIS
**Recommandation:** Toujours utiliser les classes spécifiques par page pour éviter les effets de bord globaux
