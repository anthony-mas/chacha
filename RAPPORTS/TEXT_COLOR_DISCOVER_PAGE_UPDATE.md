# Pull Request: Text Color Discover Page Update

**Date:** 9 décembre 2025
**Branch:** `Mahé_css`
**Auteur:** Mahé

---

## 📋 Résumé

Refonte complète de la couleur du texte sur la page **Discover** pour assurer une cohérence visuelle premium avec le design system gradient dark (teal-blue). Tous les textes affichent maintenant en blanc/blanc cassé pour le contraste optimal sur le fond gradient sombre.

---

## 🎯 Objectifs accomplies

1. ✅ Faire afficher tout le texte de la page Discover en blanc
2. ✅ Identifier et corriger les problèmes de cascade CSS
3. ✅ Harmoniser les variables de couleur Bootstrap avec le design system
4. ✅ Corriger les règles génériques qui overridaient les styles spécifiques

---

## 🔍 Problèmes identifiés et résolus

### Problème 1: Texte `text-muted` en gris au lieu de blanc

**Cause:** Bootstrap utilise `$gray` pour `.text-muted` par défaut, et `$gray` était défini comme noir quasi pur (`#0E0000`)

**Fichier:** `/config/_colors.scss`
```scss
$gray: #0E0000;  // Noir
```

**Solution:** Ajouté `$secondary: #FFFFFF;` dans `_bootstrap_variables.scss` pour redéfinir la couleur muted avant l'import de Bootstrap

**Résultat:**
- "Public events you can crash" ✅ blanc
- "No public events found..." ✅ blanc

---

### Problème 2: Titre "Discover" et "Trending near you" en noir

**Cause:** Règle générique dans `_base.scss` appliquait `color: var(--color-title)` à TOUS les `h1, h2, h3, h4`
- `var(--color-title)` = `var(--color-primary)` = `#111111` (noir)
- Cette règle overridait le CSS spécifique de discover.scss

**Fichier:** `/base/_base.scss` ligne 23-25
```scss
h1, h2, h3, h4, .title-lg, .title-md {
    font-family: var(--font-title);
    color: var(--color-title);  // Noir pour tous les h1, h2...
}
```

**Solution:** Ajouté `!important` sur `.discover-title` et `.trending-subtitle` pour forcer le blanc

**Fichier modifié:** `/pages/_discover.scss`
```scss
.discover-title {
  color: var(--color-text-primary) !important;  // Blanc cassé #EEE9DF
}

.trending-subtitle {
  color: var(--color-text-primary) !important;  // Blanc cassé #EEE9DF
}
```

**Résultat:**
- "Discover" ✅ blanc cassé
- "Trending near you" ✅ blanc cassé
- Filtres (Paris, Top, Friends, etc.) ✅ blanc cassé

---

### Problème 3: Filtres en bleu au lieu de blanc

**Cause:** Fichier `_links.scss` appliquait `color: var(--color-title)` à TOUS les `<a>` tags

**Fichier:** `/base/_links.scss` ligne 2
```scss
a {
    color: var(--color-title);  // Bleu/Noir
}
```

**Solution:** Ajouté `color: var(--color-text-primary) !important;` spécifiquement sur `.filter-tag`

**Résultat:** Tous les filtres affichent en blanc cassé

---

## 📝 Fichiers modifiés

### 1. `/app/assets/stylesheets/pages/_discover.scss`

**Changements:**
- Ajouté `!important` sur `.discover-title` pour forcer blanc cassé
- Ajouté `!important` sur `.trending-subtitle` pour forcer blanc cassé
- Ajouté `!important` sur `.filter-tag` color pour forcer blanc cassé
- Ajouté `!important` sur `.text-muted` pour forcer blanc cassé

### 2. `/app/assets/stylesheets/config/_bootstrap_variables.scss`

**Changements:**
- Ajouté `$secondary: #FFFFFF;` pour redéfinir la couleur des éléments muted

---

## 🎨 Palette de couleurs appliquées

| Élément | Couleur | Variable | Valeur hex |
|---------|---------|----------|-----------|
| Titre Discover | Blanc cassé | `--color-text-primary` | `#EEE9DF` |
| Subtitle Trending | Blanc cassé | `--color-text-primary` | `#EEE9DF` |
| Filtres actifs | Blanc cassé | `--color-text-primary` | `#EEE9DF` |
| Texte muted | Blanc pur | `$secondary` (Bootstrap) | `#FFFFFF` |
| Fond page | Gradient teal-blue | `--gradient-primary` | Gradient |

---

## 🧪 Validation

**Page testée:** `/discover`

**Éléments texte vérifiés:**
- ✅ "Discover" → blanc cassé
- ✅ "Paris" (location tag) → blanc cassé
- ✅ "Top", "Friends", "Social", "Sport", etc. → blanc cassé
- ✅ "Trending near you" → blanc cassé
- ✅ "Public events you can crash" → blanc pur
- ✅ "No public events found..." → blanc pur

**Contraste:** Vérifié sur fond gradient sombre - Conforme WCAG AA

---

## 📚 Variables CSS impliquées

```scss
// Base variables
--color-text-primary: #EEE9DF;        // Blanc cassé (texte sur gradient)
--color-text-secondary: #F5F1E8;      // Blanc secondaire
--color-text-tertiary: #E5DCCF;       // Blanc tertiaire (muted)
--color-primary: #111111;             // Noir (par défaut h1, h2, links)
--color-title: var(--color-primary);  // Hérite du noir par défaut
--gradient-primary: linear-gradient(...); // Fond teal-blue sombre
```

---

## 🔄 Impact sur d'autres pages

⚠️ **À vérifier:**
- Pages utilisant `.text-muted` → afficheront maintenant en blanc (potentiellement approprié si sur fond sombre)
- Pages utilisant `h1, h2` → conserveront leur couleur noire (sauf si override comme Discover)

✅ **Recommandation:** Vérifier les pages light-themed pour s'assurer que le blanc n'est pas appliqué sur fond clair

---

## 📌 Notes importantes

1. **!important utilisé:** L'utilisation de `!important` indique une cascade CSS complexe. À long terme, restructurer l'ordre d'import serait plus propre.

2. **Variable `--color-background-btn-home`:** Testée mais finalement non utilisée (restaurée en blanc).

3. **Bootstrap override:** La redéfinition de `$secondary` avant l'import de Bootstrap est la manière correcte de faire - pas de hacks.

---

## ✨ Prochaines étapes recommandées

1. Vérifier les autres pages utilisant `.text-muted`
2. Envisager une refactorisation de la cascade CSS pour éviter `!important`
3. Documenter les règles d'utilisation des couleurs par page
4. Créer un guide des couleurs pour light-themed vs dark-themed pages

---

**Status:** ✅ COMPLÉTÉ
**Reviewed by:** Mahé
**Date de merge anticipée:** 9 décembre 2025
