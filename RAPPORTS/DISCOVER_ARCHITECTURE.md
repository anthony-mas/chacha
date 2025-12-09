# Architecture Discover Page - Cartographie complète des dépendances

**Date:** 9 décembre 2025  
**Auteur:** Mahé  
**Objet:** Documenter tous les fichiers qui interagissent avec la page Discover

---

## 📍 Vue d'ensemble

La page **Discover** n'existe pas en isolation - elle dépend d'une architecture complexe de fichiers SCSS, HTML, Ruby, et configurations. Ce document cartographie chaque connexion.

---

## 🗂️ Arborescence complète - Fichiers Discover

```
discover/
├── HTML/ERB
│   └── /app/views/events/discover.html.erb
│
├── SCSS/CSS
│   ├── /app/assets/stylesheets/pages/_discover.scss (DIRECT)
│   ├── /app/assets/stylesheets/pages/_index.scss (IMPORT)
│   ├── /app/assets/stylesheets/application.scss (MAIN)
│   ├── /app/assets/stylesheets/base/_variables.scss (VARIABLES GLOBALES)
│   ├── /app/assets/stylesheets/base/_base.scss (RÈGLES GÉNÉRIQUES)
│   ├── /app/assets/stylesheets/base/_links.scss (LINKS)
│   ├── /app/assets/stylesheets/config/_colors.scss
│   ├── /app/assets/stylesheets/config/_bootstrap_variables.scss
│   └── /app/assets/stylesheets/components/ (TOUS LES COMPOSANTS)
│
├── RUBY/CONTROLLER
│   ├── /app/controllers/events_controller.rb
│   └── /config/routes.rb
│
├── PARTIALS/COMPONENTS
│   ├── /app/views/events/discover.html.erb
│   ├── /app/views/events/_event_card.html.erb
│   ├── /app/views/shared/_bottom_navbar.html.erb
│   └── /app/views/layouts/application.html.erb
│
├── CONFIGURATION
│   └── /app/assets/stylesheets/application.scss
│
└── RAPPORTS
    ├── /RAPPORTS/TEXT_COLOR_DISCOVER_PAGE_UPDATE.md
    └── /RAPPORTS/CSS_CASCADE_INVESTIGATION.md
```

---

## 🔴 FICHIERS CRITIQUES (affectent Discover directement)

### 1. `/app/views/events/discover.html.erb` - HTML de la page
**Type:** Vue ERB (Template HTML)  
**Rôle:** Structure visuelle complète de la page Discover

**Contient:**
- `.discover-page-container` (conteneur principal)
- `.discover-title` (titre "Discover")
- `.filter-bar` avec `.filter-tag` (filtres Paris, Top, Friends, etc.)
- `.trending-subtitle` (sous-titre)
- `.text-muted` (texte descriptif)
- `.event-cards-list` (liste des événements)
- `.no-events-message` (message si aucun événement)

**Exemple:**
```erb
<div class="discover-page-container">
  <div class="container pt-4 pb-4">
    <h1 class="discover-title mb-3">Discover</h1>
    <div class="filter-bar mb-4">
      <%= link_to "Top", discover_path(...), class: "filter-tag" %>
    </div>
    <h2 class="trending-subtitle">Trending near you</h2>
    <p class="text-muted mb-4">Public events you can crash</p>
  </div>
</div>
```

**Impact:** Chaque classe CSS utilisée ici doit être définie dans les fichiers SCSS

---

### 2. `/app/assets/stylesheets/pages/_discover.scss` - Styles Discover
**Type:** Feuille de styles SCSS  
**Rôle:** Styles spécifiques à la page Discover

**Contient:**
```scss
.discover-page-container { }      // Conteneur principal
.discover-title { }                // Titre "Discover"
.trending-subtitle { }             // Sous-titre
.filter-bar { }                    // Barre de filtres
.filter-tag { }                    // Tags de filtres
.filter-tag.active { }             // Tags actifs
.event-card-v2 { }                 // Cartes d'événements
.no-events-message { }             // Message aucun événement
```

**Dépendances CSS:**
- Variables de `_variables.scss`
- Héritage des règles de `_base.scss`

**Connexions:**
```scss
// Utilisé depuis: /app/assets/stylesheets/pages/_index.scss
@import "discover";
```

---

### 3. `/app/controllers/events_controller.rb` - Logique métier
**Type:** Controller Rails  
**Rôle:** Traiter la requête `/discover` et préparer les données

**Action:** `discover`
```ruby
def discover
  @current_location = params[:location] || "Paris"
  @current_filter = params[:filter] || "top"
  @categories = Category.all
  @events = Event.where(location: @current_location)
             .public_events
             .by_filter(@current_filter)
end
```

**Prépare pour le template:**
- `@current_location` → Affichage du filtre location actif
- `@current_filter` → Determine quel filtre est `.active`
- `@categories` → Affiche tous les filtres de catégories
- `@events` → Liste des événements à afficher

**Lien vers vue:**
- `discover.html.erb` utilise ces variables

---

## 🟡 FICHIERS DÉPENDANCES (héritages SCSS)

### 4. `/app/assets/stylesheets/pages/_index.scss` - Index des pages
**Type:** SCSS Index  
**Rôle:** Importe TOUS les fichiers de pages

```scss
@import "home";
@import "discover";      // 👈 IMPORTE discover.scss
@import "dashboard";
@import "event_show";
```

**Lien:** Quand on change `discover.scss`, c'est importé via ce fichier

---

### 5. `/app/assets/stylesheets/base/_variables.scss` - Variables globales
**Type:** SCSS Variables  
**Rôle:** Définit TOUTES les variables CSS du projet

**Variables utilisées par Discover:**
```scss
--color-background: var(--color-white-subtle);   // Fond page
--color-text-primary: #EEE9DF;                   // Texte principal
--color-text-secondary: #F5F1E8;                 // Texte secondaire
--color-text-tertiary: #E5DCCF;                  // Texte tertiaire
--color-primary: #111111;                        // Noir (titres)
--color-title: var(--color-primary);             // Couleur titres h1
--color-card: var(--color-white-secondary);      // Cartes
--color-white-primary: #EEE9DF;                  // Blanc cassé
--color-white-secondary: #F5F1E8;                // Blanc secondaire
--gradient-primary: linear-gradient(...);        // Fond gradient
--spacing-*: [...];                              // Espacement
--font-*: [...];                                 // Polices
```

**⚠️ ATTENTION:** Changer une variable ici affecte TOUTES les pages!

---

### 6. `/app/assets/stylesheets/base/_base.scss` - Règles génériques
**Type:** SCSS Base  
**Rôle:** Définit les styles par défaut pour les éléments HTML

**Règles génériques qui affectent Discover:**
```scss
h1, h2, h3, h4 {
    color: var(--color-title);  // Tous les h1 = noir
}

p {
    color: var(--color-body-text);  // Tous les <p> = noir
}

a {
    color: var(--color-title);  // Tous les liens = noir
}
```

**Impact:** 
- `.discover-title` (h1) hérite la couleur noire de base
- Les `.filter-tag` (links) hériteront la couleur noire de base
- Must override with `!important` dans `_discover.scss`

---

### 7. `/app/assets/stylesheets/base/_links.scss` - Styles links
**Type:** SCSS Links  
**Rôle:** Définit le style des tous les liens `<a>`

```scss
a {
    color: var(--color-title);      // Bleu/Noir par défaut
    text-decoration: none;
    transition: color 0.2s;
}

a:hover {
    color: #5d6ea7;                 // Changement au hover
}
```

**Impact sur Discover:**
- Les `.filter-tag` sont des `<a>` tags
- Hériteront cette couleur par défaut
- Doit être overridé dans `_discover.scss`

---

### 8. `/app/assets/stylesheets/config/_colors.scss` - Palette couleurs
**Type:** SCSS Config  
**Rôle:** Définit les couleurs de base utilisées par Bootstrap

```scss
$red: #FD1015;
$blue: #0D6EFD;
$yellow: #FFC65A;
$orange: #E67E22;
$green: #1EDD88;
$gray: #0E0000;              // Noir → utilisé par Bootstrap
$light-gray: #F4F4F4;

$discover-background: #FEF7E6;
$discover-title-blue: #234E70;
```

**Impact:** Bootstrap utilise `$gray` pour `.text-muted`

---

### 9. `/app/assets/stylesheets/config/_bootstrap_variables.scss` - Config Bootstrap
**Type:** SCSS Config Bootstrap  
**Rôle:** Override les variables Bootstrap AVANT son import

```scss
$font-family-sans-serif: $body-font;
$body-bg: $light-gray;
$body-color: $gray;         // Couleur texte par défaut
$primary: $blue;
```

**Impact:** 
- `$body-color: $gray` → Texte noir partout
- `.text-muted` utilise une variable Bootstrap affectée

---

### 10. `/app/assets/stylesheets/application.scss` - Fichier main
**Type:** SCSS Main  
**Rôle:** Importe TOUS les fichiers dans le bon ordre

```scss
@import "config/fonts";
@import "config/colors";
@import "config/bootstrap_variables";

@import "bootstrap";              // 👈 Bootstrap importé ICI
@import "font-awesome";

@import "base/index";             // Variables + règles génériques
@import "components/index";       // Composants
@import "pages/index";            // Pages (dont discover.scss)
```

**⚠️ ORDRE D'IMPORT CRITIQUE:**
1. Variables sont définies (`_variables.scss`)
2. Bootstrap est importé (applique ses styles)
3. Pages sont importées (peuvent override avec `!important`)

---

## 🔵 COMPOSANTS RÉUTILISÉS (partials)

### 11. `/app/views/events/_event_card.html.erb` - Partial carte événement
**Type:** Partial ERB  
**Rôle:** Affiche UNE carte d'événement

**Appelé par:** `discover.html.erb`
```erb
<% @events.each do |event| %>
  <%= render "events/event_card", event: event %>
<% end %>
```

**Classe CSS utilisée:**
- `.event-card-v2` → stylisée dans `_discover.scss`

---

### 12. `/app/views/shared/_bottom_navbar.html.erb` - Bottom navbar
**Type:** Partial ERB  
**Rôle:** Navigation en bas de page

**Affichée sur:** Toutes les pages incluant Discover

**Classes CSS:**
- `.bottom-navbar` → stylisée dans `components/_bottom_navbar.scss`

---

### 13. `/app/views/layouts/application.html.erb` - Layout principal
**Type:** Layout ERB  
**Rôle:** Conteneur HTML principal de l'app

**Contient:**
- `<head>` avec stylesheets
- `<body>` avec `<%= yield %>`
- Navbar top
- Bottom navbar

**Lien:** 
```erb
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
```

---

## 🟢 FICHIERS CONNEXES (indirectement liés)

### 14. `/app/models/Event.rb` - Modèle Event
**Type:** Rails Model  
**Rôle:** Logique métier des événements

**Utilisé par:** Controller `discover` pour récupérer `@events`

**Scopes utilisés:**
- `.public_events` → Filtre événements publics
- `.by_filter(@current_filter)` → Filtre par "Top", "Friends", etc.

---

### 15. `/app/models/Category.rb` - Modèle Category
**Type:** Rails Model  
**Rôle:** Définit les catégories (Social, Sport, Art & Culture, etc.)

**Utilisé par:** Controller pour `@categories`

---

### 16. `/config/routes.rb` - Routes Rails
**Type:** Rails Routes  
**Rôle:** Définit l'URL `/discover` et son mapping

```ruby
get 'discover', to: 'events#discover'
```

**Lien:**
- URL `localhost:3000/discover` → appelle `events#discover`
- Data passées au template `discover.html.erb`

---

## 📊 Matrice des dépendances

| Fichier | Type | Affecte Discover | Affecté par | Lien |
|---------|------|------------------|------------|------|
| discover.html.erb | HTML/ERB | ✅ Direct | CSS, Controller | Contient les éléments |
| _discover.scss | SCSS | ✅ Direct | Variables, Base | Style des éléments |
| events_controller.rb | Ruby | ✅ Direct | Models, Routes | Logique métier |
| _variables.scss | SCSS | ✅ Global | Config | Fournit les couleurs |
| _base.scss | SCSS | ✅ Global | Variables | Règles génériques |
| _index.scss (pages) | SCSS | ✅ Import | discover.scss | Importe discover.scss |
| application.scss | SCSS | ✅ Main | Config, Pages | Import principal |
| _bottom_navbar.html.erb | HTML/ERB | ✅ Partial | SCSS navbar | Affichée sur Discover |
| _event_card.html.erb | HTML/ERB | ✅ Partial | SCSS discover | Affichée dans Discover |
| _colors.scss | SCSS | 🟡 Indirect | Bootstrap | Couleurs globales |
| _bootstrap_variables.scss | SCSS | 🟡 Indirect | Bootstrap | Config Bootstrap |
| _links.scss | SCSS | 🟡 Indirect | Variables | Héritage liens |
| application.html.erb | HTML/ERB | 🟡 Wrapper | CSS | Conteneur principal |
| Event.rb | Ruby | 🟡 Data | Controller | Récupère les données |
| Category.rb | Ruby | 🟡 Data | Controller | Catégories affichées |
| routes.rb | Ruby | 🟡 Route | Controller | URL `/discover` |

---

## 🔗 Flux de données complet

```
1. UTILISATEUR accède à /discover
                    ↓
2. routes.rb route vers events#discover
                    ↓
3. events_controller.rb :discover
   - Récupère données via Event.rb, Category.rb
   - Prépare @current_location, @current_filter, @events, @categories
                    ↓
4. discover.html.erb reçoit les variables
   - Affiche: titre, filtres, sous-titre, cartes d'événements
   - Utilise classes CSS: .discover-title, .filter-tag, .trending-subtitle, etc.
                    ↓
5. CSS charge depuis application.scss
   - Variables globales (:root)
   - Règles génériques (h1, p, a)
   - Styles spécifiques (_discover.scss)
                    ↓
6. NAVIGATEUR affiche page stylisée
```

---

## 🚨 Points de rupture critiques

### Si tu changes...

| Fichier | Change | Impact |
|---------|--------|--------|
| `discover.html.erb` | Structure HTML | Les classes CSS doivent exister |
| `_discover.scss` | Couleurs, dimensions | Apparence visuelle |
| `_variables.scss` | Couleurs globales | TOUTES les pages changent! ⚠️ |
| `_base.scss` | Règles h1, p, a | TOUTES les pages héritent! ⚠️ |
| `events_controller.rb` | Logique métier | Données affichées changent |
| `Event.rb` | Scopes | Filtres ne fonctionnent plus |
| `routes.rb` | Route | URL `/discover` casse! |

---

## ✅ Checklist de modification Discover

Avant de changer quelque chose, demande-toi:

1. **Est-ce que je change une variable dans `_variables.scss`?**
   - ⚠️ Cela affecte TOUTES les pages
   - ✅ Utilise une override locale dans `_discover.scss` avec `!important`

2. **Est-ce que je change une règle dans `_base.scss`?**
   - ⚠️ Cela affecte TOUTES les pages
   - ✅ Override dans `_discover.scss` avec `!important`

3. **Est-ce que je change le HTML dans `discover.html.erb`?**
   - ✅ Assure-toi que les classes CSS existent dans `_discover.scss`
   - ✅ Teste que la structure reste cohérente

4. **Est-ce que je change la logique dans `events_controller.rb`?**
   - ✅ Vérifie que `discover.html.erb` utilise les bonnes variables
   - ✅ Teste les filtres et la pagination

5. **Est-ce que je veux affecter UNIQUEMENT Discover?**
   - ✅ Modifie `_discover.scss` avec `.discover-page-container { ... }`
   - ✅ Pas `_variables.scss` ou `_base.scss`!

---

## 📚 Fichiers à consulter pour...

| Besoin | Fichier |
|--------|---------|
| Changer couleur titre | `/pages/_discover.scss` → `.discover-title` |
| Changer couleur filtres | `/pages/_discover.scss` → `.filter-tag` |
| Ajouter un nouveau filtre | `discover.html.erb` + `events_controller.rb` |
| Changer le fond | `/pages/_discover.scss` → `.discover-page-container` |
| Changer l'espacement | `/pages/_discover.scss` + `_variables.scss` |
| Ajouter une nouvelle page | Créer `/pages/_newpage.scss` + Importer dans `_index.scss` |
| Changer polices | `/base/_variables.scss` → `--font-*` |
| Changer la logique des filtres | `/app/controllers/events_controller.rb` |

---

**Status:** ✅ DOCUMENTÉ  
**Dernière mise à jour:** 9 décembre 2025  
**Complexité:** Moyenne (7 niveaux d'héritage CSS + logique Rails)
