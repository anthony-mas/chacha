# 🎯 CREATE EVENT PAGE - REFACTO CSS ONLY

**Date:** 8 décembre 2025
**Status:** Planning Phase
**Branch:** `css_new_design`
**Scope:** 🎨 STYLE ONLY — Aucune modification HTML / copie / logique

---

## 📌 CONTRAINTE CRITIQUE

**HTML = GELÉ** ✅
**Contenu = GELÉ** ✅
**Architecture fonctionnelle = GELÉE** ✅

**À faire = CSS/SCSS uniquement** 🎨

---

## 📊 PROBLÈMES DE STYLE IDENTIFIÉS

### 1️⃣ EN-TÊTE / NAVBAR (STYLE CASSÉ)**État actuel (HTML figé):**
```html
<a>ChaCha</a> | <span>Create Event</span> | <button>Log out</button> | <img avatar>
```

**Problèmes de STYLE uniquement:**
```
❌ Pas de fond / bordure visuelle délimitant la navbar
❌ Pas d'alignement vertical clair (items mal centrés)
❌ Pas de hauteur / padding défini → semble "compressé"
❌ Texte "Create Event" = même style que le reste
❌ Bouton "Log out" = style natif navigateur (gris, borders cheap)
❌ Avatar = pas de taille / border-radius / spacing contrôlés
```

**Solution CSS-only:**
- Ajouter `background`, `border-bottom`, `padding`, `height` au container navbar
- Styliser le lien "ChaCha" (typography, color)
- Styliser le texte "Create Event" (font-size, font-weight, color)
- Styliser le bouton "Log out" comme `--btn-secondary` discret
- Ajouter `width`, `height`, `border-radius`, `object-fit` à l'avatar
- Utiliser flexbox/grid pour alignement vertical + espacement

---

### 2️⃣ TITRE PRINCIPAL "Create a new event" (STYLE CASSÉ)

**État actuel (HTML figé):**
```html
<h1>Create a new event</h1>  (ou <p> / <div>, peu importe)
```

**Problèmes de STYLE uniquement:**
```
❌ Typographie = même style que le body
❌ Aucune margin-top / espacement "respirant"
❌ Font-size trop petit pour un titre principal
❌ Font-weight pas distinct
❌ Pas de relation visuelle claire avec le formulaire qui suit
```

**Solution CSS-only:**
- Augmenter `font-size` → utiliser `--font-size-4xl` ou `--font-size-5xl`
- Augmenter `font-weight` → `--font-weight-semibold` ou `--font-weight-bold`
- Ajouter `color: var(--color-text-primary)`
- Ajouter `margin-bottom: var(--spacing-3xl)` pour la respiration
- Optionnel: `margin-top: var(--spacing-2xl)`

---

### 3️⃣ BLOC BANNIÈRE / BACKGROUND (STYLE CASSÉ) 🔴 PRIORITAIRE

**État actuel (HTML figé):**
```html
<button>Choose from library</button>
<span>Add Background</span>
<button>✕</button>
<span>Choose a Banner</span>
<img>hero_1</img>
<img>hero_2</img>
<img>hero_3</img>
<img>hero_4</img>
```

**Problèmes de STYLE uniquement:**
```
❌ ZÉRO grouping visuel:
   → Pas de card / background / border
   → Pas de padding interne
   → Éléments collés à d'autres blocs

❌ BOUTONS natifs:
   → "Choose from library" = style bouton gris par défaut
   → Croix "✕" = bouton brut sans aucun style
   → Pas cohérents avec le design system

❌ IMAGES sans hiérarchie:
   → Pas de border / radius / shadow
   → Pas d'indication de "cliquable"
   → Pas d'état "selected" visible
   → Pas d'effet hover

❌ TEXTES pas distingués:
   → "Add Background" = même style que le reste
   → "Choose a Banner" = même style
   → Pas de h3 / section title visual

❌ LAYOUT:
   → Probablement colonne unique
   → Images l'une après l'autre (ou mal alignées)
   → Pas de grille 2x2 / 3x3 visible
   → Pas de marge bottom suffisante avant la section suivante
```

**Solution CSS-only:**

```scss
/* Container */
.banner-section {
  background: var(--color-white-subtle);  /* #FBF9F4 */
  border: 1px solid var(--color-border);
  border-radius: 0;  /* Premium = angles droits */
  padding: var(--spacing-2xl);
  margin-bottom: var(--spacing-3xl);
}

/* Section title "Choose a Banner" */
.banner-title {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin-bottom: var(--spacing-lg);
}

/* Buttons styling */
.btn-choose-library {
  /* Utiliser vars boutons existants */
  color: var(--btn-color);
  border: var(--btn-border-width) solid var(--btn-border-color);
  background: var(--btn-background);
  padding: var(--btn-padding-vertical) var(--btn-padding-horizontal);
  cursor: pointer;
}

.btn-choose-library:hover {
  background: var(--btn-hover-background);
  color: var(--btn-hover-color);
}

.btn-close {
  width: 32px;
  height: 32px;
  border: 1px solid var(--color-border);
  background: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Images grid */
.banner-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);  /* 2x2 */
  gap: var(--spacing-lg);
  margin-top: var(--spacing-lg);
}

.banner-image {
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border: 2px solid var(--color-border);
  cursor: pointer;
  transition: var(--transition-base);
}

.banner-image:hover {
  border-color: var(--color-white-primary);
  box-shadow: var(--shadow-md);
}

.banner-image.selected {
  border-color: var(--color-white-primary);
  border-width: 3px;
  box-shadow: 0 0 0 4px rgba(238, 233, 223, 0.3);
}
```

---

### 4️⃣ BLOC FORMULAIRE (Title/Description/Category/Location) (STYLE CASSÉ)

**État actuel (HTML figé):**
```html
<label>Title</label>
<input type="text" value=""/>

<label>Description</label>
<textarea></textarea>

<label>Category</label>
<select>
  <option></option>
</select>

<label>Location</label>
<input type="text" value=""/>
```

**Problèmes de STYLE uniquement:**
```
❌ INPUTS/TEXTAREA bruts:
   → Border grise par défaut navigateur
   → Pas de border-radius (ou sharp)
   → Pas de focus state designé
   → Pas d'outline couleur premium
   → Padding / height pas cohérents

❌ LABELS pas stylisés:
   → Même font-size / weight que body text
   → Pas de color distincte
   → Pas de margin-bottom contrôlé
   → Pas visibles comme "labels de formulaire"

❌ SELECT très moche:
   → Style natif complètement cassé visuellement
   → Totalement different des inputs
   → Pas d'icône custom
   → Pas de padding / border cohérents

❌ STRUCTURE:
   → Pas de "form-group" wrapper
   → Pas de card/section background
   → Champs collés les uns aux autres
   → Pas de margin-bottom entre groupes

❌ SPACING:
   → Probablement aucun gap entre label/input
   → Probablement aucun gap entre groupes
```

**Solution CSS-only:**

```scss
/* Form group wrapper (si existent dans HTML) */
.form-group {
  margin-bottom: var(--spacing-2xl);
  display: flex;
  flex-direction: column;
}

/* Labels */
label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin-bottom: var(--spacing-sm);
  text-transform: capitalize;
  letter-spacing: var(--letter-spacing-wide);
}

/* Tous les inputs */
input[type="text"],
input[type="email"],
input[type="number"],
input[type="datetime-local"],
textarea,
select {
  font-family: var(--font-body);
  font-size: var(--font-size-base);
  color: var(--color-text-primary);
  background: transparent;
  border: 0;
  border-bottom: var(--input-border-width) solid var(--color-border);
  padding: var(--input-padding);
  transition: var(--input-transition);

  &::placeholder {
    color: var(--color-text-tertiary);
  }

  &:focus {
    outline: none;
    border-bottom-color: var(--color-white-primary);
    border-bottom-width: 2px;
  }
}

/* Textarea spécifique */
textarea {
  min-height: 120px;
  resize: vertical;
  font-family: var(--font-body);
}

/* Select styling (hack CSS) */
select {
  appearance: none;
  background-image: url("data:image/svg+xml;...");
  background-repeat: no-repeat;
  background-position: right 0.5em center;
  background-size: 1.5em;
  padding-right: 2.5em;
}
```---

### 6️⃣ BLOC SCHEDULE (Starts on / Ends on) (STYLE CASSÉ)

**État actuel (HTML figé):**
```html
<label>Starts on</label>
<input type="datetime-local" value="2025-12-08T12:00"/>

<label>Ends on</label>
<input type="datetime-local" value="2025-12-08T13:00"/>
```

**Problèmes de STYLE uniquement:**
```
❌ LAYOUT VERTICAL:
   → Champs empilés un sous l'autre
   → Pas une grille 2 colonnes côte à côte
   → Visuel peu "paired" pour start/end dates

❌ INPUTS datetime bruts:
   → Pire composant natif du web visuellement
   → Pas de border-radius
   → Pas de padding cohérent
   → Pas de focus state

❌ PAS D'INDICATION:
   → Pas de label visuel clair
   → Pas de hint "duration"
   → Pas de format humain affiché

❌ SPACING:
   → Probablement collés au bloc précédent
   → Pas de margin-bottom clair
   → Manque de respiration visuelle
```

**Solution CSS-only:**

```scss
/* Container pour 2 colonnes */
.datetime-group {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--spacing-lg);
  margin-bottom: var(--spacing-2xl);
}

/* Sur mobile: stack */
@media (max-width: 768px) {
  .datetime-group {
    grid-template-columns: 1fr;
  }
}

/* Input datetime styling */
input[type="datetime-local"] {
  font-family: var(--font-body);
  font-size: var(--font-size-base);
  color: var(--color-text-primary);
  background: transparent;
  border: 0;
  border-bottom: var(--input-border-width) solid var(--color-border);
  padding: var(--input-padding);
  transition: var(--input-transition);

  &:focus {
    outline: none;
    border-bottom-color: var(--color-white-primary);
  }
}
```---

### 7️⃣ BLOC PRIVACY / DISCOVERABILITY (STYLE CASSÉ)

**État actuel (HTML figé):**
```html
<h3>Privacy</h3>
<input type="checkbox"/>
<label>Private event ?</label>
<text>(Placeholder - description)</text>

<h3>Discoverability</h3>
<input type="checkbox"/>
<label>Make this event discoverable</label>
<text>(Placeholder - description)</text>
```

**Problèmes de STYLE uniquement:**
```
❌ CHECKBOXES brutes:
   → Style natif très daté
   → Pas de custom styling
   → Pas cohérent avec design system premium

❌ HIÉRARCHIE TYPOGRAPHIQUE:
   → Titre "Privacy" = même style que le reste
   → Label checkbox = même style que titre
   → Pas de différenciation visuelle claire
   → Confusion: est-ce une section title ou un label?

❌ TEXTE en parenthèses:
   → "(Placeholder - description)" = même style que body
   → Très brut, impression "draft"
   → Pas distingué comme "help text"

❌ LAYOUT:
   → Probablement colonne unique
   → Pas de card/section background
   → Pas de spacing clair entre sections

❌ SPACING:
   → Aucune margin-bottom clair
   → Pas de gap entre checkbox/label
   → Bloc collé au précédent
```

**Solution CSS-only:**

```scss
/* Titre de section */
h3 {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin-bottom: var(--spacing-md);
  margin-top: var(--spacing-lg);
  text-transform: capitalize;
}

/* Checkbox wrapper */
.checkbox-group {
  margin-bottom: var(--spacing-lg);
  display: flex;
  align-items: flex-start;
  gap: var(--spacing-sm);
}

/* Checkbox styling */
input[type="checkbox"] {
  width: 20px;
  height: 20px;
  margin-top: 2px;
  cursor: pointer;
  accent-color: var(--color-white-primary);

  &:focus {
    outline: 2px solid var(--color-white-primary);
    outline-offset: 2px;
  }
}

/* Label pour checkbox */
.checkbox-group label {
  font-size: var(--font-size-base);
  font-weight: var(--font-weight-regular);
  color: var(--color-text-primary);
  cursor: pointer;
  user-select: none;
}

/* Help text / description */
.help-text,
.checkbox-group > p {
  font-size: var(--font-size-sm);
  color: var(--color-text-tertiary);
  margin: 0;
  margin-top: var(--spacing-xs);
  margin-left: 28px;  /* Align avec le texte du label */
}
```---

## 🎨 VISION DE REFONTE

### Design Principles
```
✅ PREMIUM EDITORIAL APPROACH
   → Vibe "magazine culturel / Apple beige"
   → Espacement généreux
   → Typographie hiérarchisée

✅ STRUCTURE PAR SECTIONS
   → Chaque bloc = une "card" ou "section" visuellement distincte
   → Titres de section clairs + descriptions
   → Micro-copy guidant à chaque étape

✅ FEEDBACK VISUEL
   → États clairs (hover, active, disabled)
   → Validations en temps réel
   → Sélections visibles (bannière choisie = border/highlight)

✅ HIÉRARCHIE CLAIRE
   → Qu'est-ce que je dois faire maintenant?
   → Quel est l'ordre logique des étapes?
   → Où est le CTA principal (créer l'event)?
```

---

## 🎯 PLAN D'ATTAQUE (ÉTAPES)

### ÉTAPE 1: REFONDRE LA NAVBAR ⭐
**Fichiers à modifier:** `app/views/layouts/_navbar.html.erb`

**Objectifs:**
- Créer une **navbar premium structurée** (logo + nav links + user menu)
- Retirer "Create Event" de la navbar (c'est le titre de page)
- Styler "Log out" + avatar selon design system
- Hiérarchie claire: logo à gauche, user menu à droite

**Composants:**
- Logo "ChaCha" (lien home)
- Dropdown user menu (avatar + log out)
- Utiliser les variables de couleur (--color-text-primary, --color-white-primary, etc.)
- Apply --btn-color white pour cohérence

---

### ÉTAPE 2: REFONDRE LE BLOC BANNIÈRE/BACKGROUND 🔴 PRIORITAIRE
**Fichiers à modifier:** `app/views/events/new.html.erb` (section background)

**Objectifs:**
- **Clarifier conceptuellement:** on choisit UNE bannière pour le background de l'event
- Créer une **section "Event Banner"** avec card structure
- Titre de section: "Choose event banner"
- Sous-texte: "This image will be shown as your event's cover"
- Grille d'images avec:
  - Labels clairs sous chaque image
  - Visual feedback (border/highlight sur sélection)
  - État "selected" clair
  - Hover effect premium

**Composants à créer:**
- Component: `_banner_picker.html.erb` (réutilisable)
- CSS: `app/assets/stylesheets/components/_banner_picker.scss`
- Comportement: Radio buttons ou data-attributes pour tracking de la sélection
- Visuals:
  - Images en grille 2x2 ou 3x3
  - Border subtle par défaut (--color-border)
  - Border prominent (--color-white-primary) au hover
  - Border filled (--color-white-primary avec background) si selected

---

### ÉTAPE 3: REFONDRE LE TITRE PRINCIPAL ⭐
**Fichiers à modifier:** `app/views/events/new.html.erb`

**Objectifs:**

- Créer une **section "Page Header"** structurée
- Titre principal "Create a new event" + sous-texte guidant
- Microcopy: "Design your next event from scratch"
- Layout: titre + sous-texte centrés ou left-aligned (à décider)

**Composants:**
- `<h1>` "Create a new event"
- `<p class="subtitle">` description
- Utiliser hierarchy: --font-size-4xl ou 5xl pour titre
- Espacing: --spacing-3xl avant la section suivante

---

### ÉTAPE 4: REFONDRE LE BLOC FORMULAIRE (Title/Description/Category/Location)
**Fichiers à modifier:** `app/views/events/new.html.erb`, `app/assets/stylesheets/components/_form_fields.scss`

**Objectifs:**
- Ajouter **placeholders** à tous les champs
- Ajouter **micro-copy** sous les labels
- Grouper les champs en **card/section structure**
- Styliser selon design system

**Champs + Placeholders/Micro-copy:**
```
TITLE
  Placeholder: "e.g., Summer Rooftop Dinner"
  Help text: "Choose a catchy, memorable name"

DESCRIPTION
  Placeholder: "Describe the vibe, activities, dress code..."
  Help text: "Tell people what to expect"

CATEGORY
  Options: Birthday, Concert, Dinner, Gaming, Party, Meetup, Workshop, Other
  Help text: "Helps people discover your event"

LOCATION
  Placeholder: "e.g., Paris, Online, Bar Le Verre"
  Help text: "Where or how people will join"
```

**Structure CSS:**
- Groupe champs: `.form-group` ou `.event-section`
- Label styling: --font-weight-semibold, --color-text-primary
- Help text: `<small class="help-text">` avec --color-text-tertiary
- Input styling: utiliser vars (--input-padding, --input-border-color, etc.)

---

### ÉTAPE 5: REFONDRE LE BLOC SCHEDULE (Starts on / Ends on)
**Fichiers à modifier:** `app/views/events/new.html.erb`, `app/assets/stylesheets/components/_datetime_picker.scss`

**Objectifs:**
- Layout en **colonnes côte à côte** (2 colonnes)
- Ajouter **micro-copy** (timezone, format humain)
- Améliorer visual du datetime input (wrapper custom)
- Ajouter duration calculation display (ex: "Duration: 1 hour")

**Composants:**
```
SECTION: "Schedule"

[Starts on]           [Ends on]
<input datetime>      <input datetime>
Help: UTC timezone    Help: UTC timezone

Duration: 1 hour
```

**Style:**
- 2-column grid sur desktop
- Stack sur mobile
- Input wrapper avec border bottom (--input-border-width)
- Help text en tertiary color
- Duration display: petit texte informatif

---

### ÉTAPE 6: REFONDRE LE BLOC PRIVACY / DISCOVERABILITY
**Fichiers à modifier:** `app/views/events/new.html.erb`, `app/assets/stylesheets/components/_toggle_field.scss`

**Objectifs:**
- Créer des **toggles stylisés premium** (pas checkboxes brutes)
- Ajouter **micro-copy** expliquant les conséquences
- Clarifier la logique (Private ≠ Discoverable)
- Layout en card

**Composants:**
```
SECTION: "Event Settings"

Privacy
  🔘 Private event
  Help: "Only invited guests can see and join"

Discoverability
  🔘 Make discoverable
  Help: "Let others find your event in the app"

Max Guests (optional)
  <input type="number" placeholder="No limit">
  Help: "Leave empty for unlimited guests"
```

**Style:**
- Créer component `_toggle_field.scss` avec toggle style premium
- Toggle: cercle animé (smooth transition)
- Labels + help text bien séparés
- Utiliser --transition-base pour animation

---

### ÉTAPE 7: REFONDRE LE BLOC CTA (CREATE EVENT BUTTON)
**Fichiers à modifier:** `app/views/events/new.html.erb`

**Objectifs:**
- Créer un **CTA primary** bien visible en bas de la page
- Button premium stylisé (blanc border/texte sur gradient background)
- États: normal, hover, disabled
- Micro-copy: "Create Event" ou "Let's Go"

**Composants:**
```
<div class="form-actions">
  <button class="btn btn-primary">Create Event</button>
  <a href="/" class="btn btn-secondary">Cancel</a>
</div>
```

**Style:**
- Utiliser --btn-color, --btn-hover-color vars
- Primary button: white border + white text, hover: white bg + black text
- Secondary button: transparent, subtle
- Centré ou full-width (à décider)
- Padding: --spacing-lg pour prominence

---

## 🗂️ FICHIERS À MODIFIER

**Frontend (Rails Views):**
1. `/app/views/layouts/_navbar.html.erb` — Refondre navbar
2. `/app/views/events/new.html.erb` — Refondre tout le formulaire

**Styling (SCSS):**
1. `/app/assets/stylesheets/components/_navbar.scss` — Navbar premium
2. `/app/assets/stylesheets/components/_banner_picker.scss` — NEW
3. `/app/assets/stylesheets/components/_form_fields.scss` — Form styling
4. `/app/assets/stylesheets/components/_datetime_picker.scss` — NEW (optionnel)
5. `/app/assets/stylesheets/components/_toggle_field.scss` — NEW

**Variables (déjà en place):**
- `/app/assets/stylesheets/base/_variables.scss` ✅ (utiliser les vars existantes)
- `/app/assets/stylesheets/base/_reset.scss` ✅ (body gradient déjà appliqué)

---

## 🎨 DESIGN TOKENS À APPLIQUER

```scss
/* Typographie */
--font-size-4xl: 32px    (Titre principal)
--font-size-2xl: 24px    (Section titles)
--font-size-lg: 18px     (Labels)
--font-size-base: 16px   (Body text)
--font-size-sm: 14px     (Help text, tertiary)

/* Couleurs */
--color-text-primary:    #EEE9DF  (Main text)
--color-text-secondary:  #F5F1E8  (Secondary text)
--color-text-tertiary:   #E5DCCF  (Help text, labels subtle)
--color-primary:         #111111  (Buttons, strong elements)
--color-border:          #7D7564  (Borders, dividers)
--color-white-primary:   #EEE9DF  (White elements)
--color-gradient-primary: linear-gradient(90deg, #0E2B3A, #0f4c3d)

/* Spacing */
--spacing-sm: 8px
--spacing-md: 12px
--spacing-lg: 16px
--spacing-xl: 24px
--spacing-2xl: 32px
--spacing-3xl: 48px

/* Effects */
--transition-base: 150ms ease-out
--shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1)
```

---

## 📋 CHECKLIST IMPLÉMENTATION

### PHASE 1: Navbar Refonte
- [ ] Créer structure navbar premium
- [ ] Styler logo + user menu
- [ ] Appliquer variables de couleur
- [ ] Tester sur mobile/desktop

### PHASE 2: Titre Principal
- [ ] Ajouter section header
- [ ] Titre + sous-texte
- [ ] Spacing et typographie

### PHASE 3: Banner Picker 🔴 PRIORITAIRE
- [ ] Clarifier la logique (1 bannière = background)
- [ ] Créer component `_banner_picker.html.erb`
- [ ] Styler grille + sélection
- [ ] Radio buttons backend
- [ ] Tester sélection/feedback

### PHASE 4: Form Fields
- [ ] Ajouter placeholders + help text
- [ ] Créer section structure (cards)
- [ ] Styler labels + inputs
- [ ] Remplir select Category

### PHASE 5: Schedule Section
- [ ] Layout 2-colonnes
- [ ] Ajouter duration display
- [ ] Micro-copy timezone

### PHASE 6: Privacy/Discoverability
- [ ] Créer toggle components
- [ ] Ajouter help text
- [ ] Clarifier logique

### PHASE 7: CTA + Testing
- [ ] Créer button "Create Event"
- [ ] Test complet page
- [ ] Responsive design
- [ ] Validation visuels

---

## 🎯 PRIORITÉS

**URGENT (Confusant pour l'utilisateur):**
1. 🔴 Refondre bloc bannière (clarifier la logique)
2. 🟠 Refondre navbar (hiérarchie claire)
3. 🟠 Ajouter placeholders + help text aux champs

**IMPORTANT (UX):**
4. Refondre schedule (layout + duration)
5. Refondre privacy/discoverability (toggles + clarity)

**NICE TO HAVE (Polish):**
6. Améliorer datetime picker visuel
7. Ajouter animations transitions

---

## 🚀 APPROCHE IMPLÉMENTATION

**CSS-ONLY = Aucun changement HTML**
- Utiliser les selectors CSS existants
- Appliquer les variables SCSS du design system
- Pas de wrapper/div/class ajoutés
- Ciblage spécifique par type/tagName/id/data-attr

**Fichiers à créer:**
1. `/app/assets/stylesheets/pages/_events_new.scss` — Page spécifique
2. `/app/assets/stylesheets/components/_form_styling.scss` — Inputs/Labels/Selects

**Importer dans `application.scss`:**
```scss
@import 'pages/events_new';
@import 'components/form_styling';
```

---

## ✅ CHECKLIST FINALE

- [ ] Navbar = card visuelle distincte
- [ ] Titre = h1/h2 bien mis en évidence
- [ ] Bannière = section avec background + border + padding
- [ ] Images = grid 2 colonnes + border/hover/selected
- [ ] Inputs = border-bottom style (cohérent avec design)
- [ ] Labels = semibold small + uppercase + tracking
- [ ] Select = appearance:none + custom dropdown
- [ ] Checkboxes = accent-color blanc
- [ ] Schedule = 2 colonnes desktop / 1 mobile
- [ ] CTA = bouton blanc premium visible
- [ ] Responsive = OK mobile/tablet/desktop
- [ ] Contraste = WCAG AA minimum
