# Plan d'Action: Titres blancs UNIQUEMENT sur Discover

**Date:** 9 décembre 2025
**Problème:** Titres blancs appliqués partout au lieu que sur Discover uniquement
**Solution:** CSS spécifique à Discover, sans toucher aux variables globales

---

## 🎯 Objectif final

```
Homepage:    h1, h2, h3 = NOIR ✅
Events:      h1, h2, h3 = NOIR ✅
Dashboard:   h1, h2, h3 = NOIR ✅
Discover:    h1, h2, h3 = BLANC ✅  ← UNIQUEMENT ICI
```

---

## 🔴 Problème actuel

**Ce qui ne faut PAS faire:**
```scss
// ❌ MAUVAIS - Change la variable globale
:root {
  --color-primary: #ffff;  // Affecte TOUTES les pages!
}

// ❌ MAUVAIS - Ajoute du blanc global sur tous les h1
.discover-page-container {
  h1, h2, h3, h4 { color: #FFFFFF; }  // Trop large!
}
```

---

## ✅ Solution SIMPLE ET EFFICACE

### Étape 1: Garder les variables globales INTACTES
**Fichier:** `/app/assets/stylesheets/base/_variables.scss`

```scss
--color-primary: #111111;   // ✅ RESTE NOIR partout
--color-title: var(--color-primary);  // ✅ RESTE NOIR partout
```

**Action:** NE RIEN CHANGER dans ce fichier!

---

### Étape 2: Utiliser une classe de conteneur spécifique
**Fichier:** `/app/assets/stylesheets/pages/_discover.scss`

```scss
// Conteneur de la page Discover UNIQUEMENT
.discover-page-container {
  // Aucune règle globale ici! Juste du spacing/layout
  min-height: 100vh;
  background-color: var(--color-background);
}

// Override SPÉCIFIQUE pour les titres DANS Discover
.discover-page-container .discover-title {
  color: #FFFFFF !important;  // Blanc UNIQUEMENT sur cette classe
}

.discover-page-container .trending-subtitle {
  color: #FFFFFF !important;  // Blanc UNIQUEMENT sur cette classe
}

// Override SPÉCIFIQUE pour les filtres DANS Discover
.discover-page-container .filter-tag {
  color: #FFFFFF !important;  // Blanc UNIQUEMENT sur cette classe
}
```

**Résultat:**
- `.discover-title` = blanc (car dans `.discover-page-container`)
- `h1` partout ailleurs = noir (car hérité de `--color-primary`)
- `.filter-tag` = blanc (car dans `.discover-page-container`)

---

## 📋 Étapes à exécuter IMMÉDIATEMENT

### ÉTAPE 1: Vérifier `/app/assets/stylesheets/base/_variables.scss`

```scss
/* Semantic aliases */
--color-text-primary:       #EEE9DF;
--color-text-secondary:     #F5F1E8;
--color-text-tertiary:      #E5DCCF;
--color-border:             #7D7564;
--color-primary:            #111111;   // ✅ DOIT ÊTRE NOIR
--color-overlay-dark:       rgba(0, 0, 0, 0.65);

--color-title: var(--color-primary);       // ✅ DOIT RESTER NOIR
--color-body-text: var(--color-primary);   // ✅ DOIT RESTER NOIR
```

**✅ SI C'EST BON:** Continue à l'étape 2

**❌ SI C'EST BLANC:** Corrige immédiatement:
```scss
// REMPLACER
--color-primary: #ffff;   // ❌ BLANC

// PAR
--color-primary: #111111; // ✅ NOIR
```

---

### ÉTAPE 2: Modifier `/app/assets/stylesheets/pages/_discover.scss`

**REMPLACER tout le bloc `.discover-page-container` existant PAR:**

```scss
.discover-page-container {
  min-height: 100vh;
  background-color: var(--color-background);
  padding-bottom: var(--spacing-md);

  .container {
    padding-top: var(--spacing-md);
  }

  // ⚠️ IMPORTANT: Ne pas ajouter h1, h2, p ici!
}

// UNIQUEMENT les classes spécifiques à Discover
.discover-page-container .discover-title {
  font-family: var(--font-headline);
  font-size: 2.5rem;
  font-weight: 800;
  color: #FFFFFF !important;  // ✅ Blanc UNIQUEMENT ici
}

.discover-page-container .trending-subtitle {
  font-size: 1.2rem;
  font-weight: 600;
  color: #FFFFFF !important;  // ✅ Blanc UNIQUEMENT ici
}

.discover-page-container .filter-tag {
  color: #FFFFFF !important;   // ✅ Blanc UNIQUEMENT ici
}

.discover-page-container .text-muted {
  color: var(--color-text-tertiary) !important;
}
```

**Clé:** Utiliser `.discover-page-container .classe` pour cibler UNIQUEMENT les éléments DANS la page Discover

---

### ÉTAPE 3: Vérifier le HTML (`discover.html.erb`)

**Vérifier que la structure est:**

```erb
<div class="discover-page-container">  ✅ BON - Conteneur spécifique
  <div class="container">
    <h1 class="discover-title">Discover</h1>  ✅ Classe personnalisée
    <h2 class="trending-subtitle">Trending near you</h2>  ✅ Classe personnalisée
    <div class="filter-bar">
      <a class="filter-tag">Paris</a>  ✅ Classe spécifique
    </div>
  </div>
</div>
```

**Ne rien changer au HTML!**

---

## 🧪 Test de validation

Une fois changé, ouvre les pages et vérifie:

| Page | h1, h2 | Expected | Status |
|------|--------|----------|--------|
| Homepage | Couleur | NOIR | ✅ ou ❌ |
| Events | Couleur | NOIR | ✅ ou ❌ |
| Dashboard | Couleur | NOIR | ✅ ou ❌ |
| Discover | h1.discover-title | BLANC | ✅ ou ❌ |
| Discover | h2.trending-subtitle | BLANC | ✅ ou ❌ |
| Discover | .filter-tag | BLANC | ✅ ou ❌ |

---

## 🔍 Si ça ne marche pas

### Symptôme 1: Titres PARTOUT en blanc
**Cause:** Variables globales encore en blanc
**Correction:** Vérifier `_variables.scss` ligne 30-40
```scss
--color-primary: #111111;  // Doit être NOIR
```

### Symptôme 2: Titres Discover restent NOIR
**Cause:** `.discover-page-container .class` ne trouve pas les éléments
**Solution:** Vérifier le chemin CSS:
```scss
// Le sélecteur doit matcher l'HTML:
.discover-page-container .discover-title { }
// Si discover-title est directement dans discover-page-container ✅
// Si discover-title est dans container, utiliser:
.discover-page-container .container .discover-title { }
```

### Symptôme 3: Les filtres restent NOIR
**Cause:** `.filter-tag` n'est pas dans `.discover-page-container`
**Vérifier:** Le HTML:
```erb
<div class="discover-page-container">
  <div class="filter-bar">  ✅ DANS le conteneur
    <a class="filter-tag">Top</a>
  </div>
</div>
```

---

## 📌 Règle d'or à retenir

```
❌ NE PAS changer de variables globales
✅ UTILISER des classes spécifiques + !important

Format:
.discover-page-container .ma-classe {
  color: #FFFFFF !important;
}

Résultat:
- Affecte UNIQUEMENT les éléments DANS .discover-page-container
- N'affecte PAS les autres pages
```

---

## 📊 Comparaison avant/après

### ❌ AVANT (tout en blanc)
```scss
:root {
  --color-primary: #ffff;  // Blanc global
}

.discover-page-container {
  h1, h2, h3 { color: #FFFFFF; }  // Trop large
}

RÉSULTAT: Homepage, Events, Dashboard TOUTES en blanc! 🚨
```

### ✅ APRÈS (Discover blanc, autres noir)
```scss
:root {
  --color-primary: #111111;  // Noir partout
}

.discover-page-container .discover-title {
  color: #FFFFFF !important;  // Blanc UNIQUEMENT ici
}

RÉSULTAT:
- Homepage h1 = noir ✅
- Events h1 = noir ✅
- Discover h1.discover-title = blanc ✅
```

---

## ✅ Checklist d'exécution

- [ ] Vérifier `_variables.scss` → `--color-primary: #111111` (noir)
- [ ] Modifier `_discover.scss` → Utiliser `.discover-page-container .classe`
- [ ] Tester Homepage → titres noirs ✅
- [ ] Tester Events → titres noirs ✅
- [ ] Tester Dashboard → titres noirs ✅
- [ ] Tester Discover → titres blancs ✅
- [ ] Vérifier que les filtres sont blancs ✅
- [ ] Valider le contraste des couleurs ✅

---

## 💡 Résumé en une ligne

**Garder les variables globales noires, utiliser des sélecteurs CSS spécifiques (`.discover-page-container .classe`) pour rendre UNIQUEMENT les éléments de Discover blancs.**

---

**Complexité:** Très simple (3 étapes)
**Risque:** Aucun (isolation complète)
**Durée:** 5 minutes maximum
**Status:** 🎯 PRÊT À EXÉCUTER
