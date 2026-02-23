# Advocato UI/UX Modernization Blueprint

## Current UI audit based on your screenshots

Your current build already has the correct **information architecture** (bottom nav with Home/Hearings/Activity/Menu; profile + dashboard actions; case list + FAB; hearing calendar; settings). The biggest gaps are **visual hierarchy**, **brand identity**, and **motion consistency**.

What’s working well (foundation is solid):
- The app is already “feature-aligned” with your SRD: Home list + FAB, Hearings calendar + upcoming list, Activity sections, and a menu overlay concept.
- Layout is clean and uncluttered (but currently too “blank” because color + typography + elevation aren’t doing enough).

What looks “basic” right now (and why it feels off):
- **Typography** is very default and uniform: headings don’t feel “heading-like,” and text doesn’t create hierarchy.
- **Color usage is minimal**: almost everything is grayscale with a faint blue highlight. This makes the UI feel unfinished and reduces “scanability.”
- **Component styling is inconsistent**: chips/buttons/cards feel standard and not part of a cohesive design system.
- **The hamburger/menu panel**: it looks like a generic dialog card floating somewhere rather than a deliberate “bottom-left quadrant panel.” It needs precise positioning, a better shape, better spacing, and a better entrance/exit transition.
- **Transitions are mostly absent**: navigation feels abrupt; form opening/closing feels “teleporty.” Material 3 UIs feel modern largely because of motion and subtle micro-interactions. citeturn0search12turn0search30

The highest-impact fixes (in priority order):
1. Establish a **real design system** (ColorScheme + typography + radius + elevations) and apply globally.
2. Upgrade navigation polish: switch to **Material 3 NavigationBar** and smooth screen changes with “fade through / shared axis.” citeturn0search18turn0search15turn0search30
3. Redesign the **Menu quadrant** as a properly anchored overlay with refined shape + blur/scrim + better motion (not a random card).
4. Add a **proper splash**: native splash for startup + an in-app animated loading splash while initialization runs. Flutter explicitly supports doing splash screens either manually or via packages. citeturn0search22turn0search0

---

## Design system upgrade for a sleek “legal-grade” look

A professional legal app should feel **calm, trustworthy, and structured**. Material 3 is already motion-rich and token-based, but you need to actually “turn on” a strong color system + typography and apply it consistently. Flutter’s Material widgets implement Material 3 and are intended to be used as the base for modern app UI. citeturn0search12turn2search20

### Color strategy

Use Material 3’s tonal palette behavior via `ColorScheme.fromSeed` (best for speed + consistency). Flutter’s docs specify that `ColorScheme.fromSeed` constructs tonal palettes based on the Material 3 color system and aims to provide harmonious colors meeting contrast requirements. citeturn4search7turn4search11  
Material’s M3 color guidance also emphasizes accessible, hierarchical schemes. citeturn4search3

Recommended brand direction for Advocato:
- **Seed/Primary**: Navy (you already chose) `#1E3A5F`
- **Secondary**: Slate/Teal toned (for chips, small highlights)
- **Tertiary**: Warm accent (subtle; for “alerts” like overdue hearings)
- **Surfaces**: light mode off-white; dark mode deep gray (not pure black)

Implementation approach:
- Use **flex_color_scheme** to create sophisticated ThemeData with consistent component styling and radius, building on Material 3 seeded schemes. citeturn1search0turn1search8

### Typography strategy

Pick 1 main font + 1 optional display font. With **google_fonts**, you can use runtime fetching during development, but for offline-first production you should bundle fonts as assets; the package explicitly notes that bundled assets are prioritized and are useful for offline-first apps. citeturn2search0turn2search7

Suggested modern font options:
- **Inter**: excellent for dense lists and a contemporary “system-like” feel.
- **Source Sans 3**: very readable for notes and form-heavy screens.
- **Manrope**: slightly more premium for headings (optional).

### Shape, spacing, and surfaces

Adopt a consistent set of tokens:
- Radius: 16 (cards), 20–24 (modals), 12 (chips)
- Spacing: 8pt grid (8, 16, 24)
- Elevation: subtle (cards 1–2, overlays 8–16)
- Surface layering: use `colorScheme.surfaceContainer*` roles (Flutter’s updated ColorScheme roles in Material 3 now include more surface roles and deprecations; be mindful when theming). citeturn4search11

image_group{"layout":"carousel","aspect_ratio":"16:9","query":["Flutter Material 3 NavigationBar modern UI example","Material Design 3 search bar app bar examples","Flutter modal sheet modern UI example","Flutter animated splash screen lottie example"],"num_per_query":1}

---

## Motion and micro-interaction plan for “cool but professional” animations

Material motion is meant to help users understand spatial relationships and navigation changes; the official **animations** package exists specifically to provide these transition patterns. citeturn0search30turn0search2turn0search14  
For micro-interactions (tiny fades, slides, scale pulses), **flutter_animate** is a clean and performant approach. citeturn3search2turn3search26

### A motion “rulebook” for Advocato

Use three layers of motion:

- **Navigation motion**: 250–400ms, consistent curve, used when switching screens or tabs.
  - Use **FadeThroughTransition** for bottom nav screen swaps.
  - Use **OpenContainer** for case card → case detail.
  - Use **SharedAxisTransition** for wizard-like flows (e.g., Add Case sections). citeturn0search8turn0search14turn0search30

- **Component motion**: 150–250ms, subtle.
  - Cards: fade+slide in
  - Chips: fade in
  - Dashboard counters: count-up animation

- **Feedback motion**: 80–150ms.
  - FAB tap: small scale + ripple
  - Menu open: slide+fade with a scrim

### Loading polish

Instead of showing empty space or a static spinner, skeleton states make the app feel dramatically more modern. **skeletonizer** specifically converts your existing layouts into skeleton loaders with minimal effort. citeturn1search2turn1search10

---

## Menu quadrant redesign plan

Your current menu overlay “card” is visually off because it behaves like a generic dialog rather than a purpose-designed component anchored to the bottom-left.

The cleanest way to fix it is to make it:
- **anchored** to bottom-left
- a **fractional-size panel** (e.g., ~60% width, ~55% height)
- a **proper overlay route** with a scrim and optional blur
- animated with a unified slide+fade

Flutter’s `showGeneralDialog` is explicitly designed to display a dialog above the current content and allows customization, including custom transitions via `transitionBuilder`. citeturn1search3turn1search7  
This makes it a good tool for implementing your “menu quadrant panel” as a custom animated overlay.

### Geometry and styling spec

Target geometry (tune visually):
- Width factor: 0.62
- Height factor: 0.55
- Alignment: bottom-left
- Shape: rounded inside edges more than outside edges  
  Example border radius:
  - top-right: 28
  - top-left: 16
  - bottom-right: 16
  - bottom-left: 0–8 (optional; gives “anchored” feel)

Visual styling:
- Use `Material` with elevation (12–16).
- Use surface color from the active ColorScheme (not hard-coded white).
- Add a subtle **divider** between groups:
  - Quick toggles (Theme, Large Text)
  - Navigation items (Profile, Courts, Settings)
  - Info (FAQs, About)

### Recommended animation

Entrance: slide from slightly left/down + fade in (220–280ms).  
Exit: reverse.

Also add:
- “Tap outside to close”
- Escape key close (web/desktop)
- optional close icon

### Cursor-ready implementation instructions

Have Cursor implement this EXACT component and replace the current menu behavior.

**Create:** `lib/features/menu/quadrant_menu.dart`

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

Future<void> showQuadrantMenu({
  required BuildContext context,
  required Widget child,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Menu',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, anim1, anim2) {
      // The dialog content itself. The barrier is handled by showGeneralDialog.
      return Align(
        alignment: Alignment.bottomLeft,
        child: SafeArea(
          minimum: const EdgeInsets.all(12),
          child: FractionallySizedBox(
            widthFactor: 0.62,
            heightFactor: 0.55,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(28),
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Material(
                  elevation: 16,
                  color: Theme.of(context).colorScheme.surface,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.10, 0.10),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
```

Then implement `QuadrantMenuContent` as a widget containing:
- Top row: “Menu” title + close button
- Quick toggles row: Theme mode and Large Text (switch or segmented)
- ListTiles: Profile, Courts Manager, Settings, FAQs, About
- Footer: version and “Send feedback”

---

## Dynamic settings architecture that feels modern

“Dynamic settings” should mean two things:
1. Changing a setting immediately updates the UI (theme, text scale, etc.)
2. The settings screen adapts: it shows/hides details based on toggles and shows previews

For persistence, **shared_preferences** is a standard Flutter plugin for key-value storage and works across Android/iOS by wrapping platform equivalents. citeturn4search0

For reactive UI, **flutter_riverpod** is a strong fit; it explicitly targets handling async and separating logic from UI. citeturn4search1turn4search17

### Recommended settings model

Use a single `AppSettings` model:
- `ThemeMode themeMode` (system/light/dark)
- `bool largeText`
- `bool remindersEnabled`
- optional: `bool useDynamicColor` (Android/desktop only; fallback elsewhere)

If you choose to integrate **dynamic_color**, note it’s supported on Android and desktop platforms but not iOS/web (you must fallback to seeded schemes). citeturn1search1turn1search9turn4search7

### Dynamic settings UI behaviors

Settings screen:
- Theme section:
  - Show a small palette preview row (primary/secondary/tertiary swatches)
  - Toggle between Light/Dark/System (SegmentedButton)
- Accessibility section:
  - Toggle Large Text
  - Live preview “Aa” text tile that changes size immediately
- Reminders section:
  - Toggle enable/disable
  - If disabled: collapse time/day info
  - If enabled: show “07:00” and “Mon–Sat” as read-only tiles (per your SRD)

Menu quadrant:
- Show “quick toggles” for theme + large text
- The toggles must update the app immediately (no need to open settings)

---

## Splash screen modernization with animation

A polished startup experience typically has two layers:

### Native splash screen

Flutter’s platform integration docs describe splash screens as an initial experience while the engine loads and point out you can implement them via packages or manually. citeturn0search22  
**flutter_native_splash** generates platform-native splash assets and code for Android/iOS/web and supports background colors and images (including dark mode). citeturn0search0turn0search6

This solves: the “blank white screen” during engine boot.

### In-app animated splash (while app initializes)

For the “loading time” after Flutter is running (opening DB, loading settings), use a dedicated `SplashScreen` route with a lightweight animation.

**Lottie** is widely used for this because it renders JSON animations and explicitly supports Android/iOS/macOS/Linux/Windows/web. citeturn0search1

Implementation concept:
- App starts → native splash shows instantly (flutter_native_splash)
- Flutter boot → show in-app `SplashScreen` with a **Lottie** animation + app name
- Run initialization (`loadSettings`, `openDatabase`, etc.)
- When done, transition to AppShell with a fade-through

### Cursor instructions for splash

Dependencies:
- `flutter_native_splash` (dev dependency) for native splash setup citeturn0search0  
- `lottie` for in-app animation citeturn0search1

flutter_native_splash setup:
- Add config and run: `dart run flutter_native_splash:create` as per package instructions. citeturn0search0

In-app splash widget:
- A centered column: Lottie animation + “Advocato”
- Keep minimum display time (e.g., 900ms) so it doesn’t flash too fast

---

## Cursor execution plan with detailed, paste-ready instructions

This section assumes you are developing on Windows with web-first testing (Chrome). It is designed to be copied into Cursor step-by-step.

### Plan of work

You should not try to “polish everything” at once. Do it in the order that gives maximal visual payoff:

- Phase A: Theme + typography + NavigationBar (instant modern look)
- Phase B: Motion system (tab transitions, card-to-details, FAB)
- Phase C: Menu quadrant rebuild (fix the “off looking” menu)
- Phase D: Splash (native + in-app)
- Phase E: Screen-by-screen refinement (Home cards, Hearings calendar styling, Activity cards, Settings dynamics)

### Cursor task prompts

Use these as separate Cursor prompts, one per task.

#### Theme foundation prompt
> Refactor the app to use Material 3 theming with `flex_color_scheme` and `ColorScheme.fromSeed(seedColor: Color(0xFF1E3A5F))` for light and dark themes. Apply consistent radius (16) across cards/buttons/inputs, and set global typography via `google_fonts` (Inter). Add a central `AdvocatoTheme` class and apply it in `MaterialApp`.

Supporting sources for Cursor context: Material 3 color roles and `ColorScheme.fromSeed` behavior are documented in Flutter’s API. citeturn4search7turn4search11  
flex_color_scheme positions itself as a sophisticated ThemeData builder with seeded ColorSchemes. citeturn1search0  
google_fonts supports asset bundling for offline-first apps. citeturn2search0turn2search7

#### NavigationBar upgrade prompt
> Replace BottomNavigationBar with Material 3 `NavigationBar` using 4 `NavigationDestination`s (Home, Hearings, Activity, Menu). Implement animated tab switching using the `animations` package with `FadeThroughTransition`. Preserve state of each tab (IndexedStack) and apply the new ColorScheme for selected/unselected icon styling.

Flutter’s `NavigationBar` is the Material 3 navigation bar component. citeturn0search18turn0search15  
Material motion transitions are available via the `animations` package. citeturn0search2turn0search30

#### Home polish prompt
> Upgrade Home to use Material 3 `SearchBar` (not a plain TextField) and style FilterChips with the active ColorScheme. Add subtle list entrance animations using `flutter_animate` (fade + slide). Improve empty state with a centered icon, 2-line copy, and a primary button “Add your first case.”

Material 3 SearchBar behavior is defined in Flutter’s API docs. citeturn2search3turn2search16  
flutter_animate provides unified animation effects and is actively maintained. citeturn3search2turn3search26

#### Case card transition prompt
> Use `OpenContainer` from the `animations` package so a CaseCard morphs into the CaseDetail placeholder screen (container transform). Apply consistent card shape and surface colors from the theme.

OpenContainer is documented as a container that grows to fill the screen and reveals new content. citeturn0search14turn0search2

#### Menu quadrant rebuild prompt
> Replace the current hamburger menu card with a true bottom-left quadrant overlay using `showGeneralDialog`. Implement: scrim, optional blur, anchored FractionallySizedBox (widthFactor ~0.62, heightFactor ~0.55), rounded shape, and slide+fade transition. Add quick toggles for Theme + Large Text and navigate to Settings/Profile screens.

`showGeneralDialog` supports custom dialog presentation and animations. citeturn1search3turn1search7

#### Settings “dynamic” prompt
> Implement an `AppSettingsController` using `shared_preferences` for persistence and `flutter_riverpod` for reactive updates. Settings screen should dynamically show/hide reminder details based on toggle, and provide ThemeMode selection (Light/Dark/System) with an immediate preview effect. Also expose Theme + Large Text toggles in the menu quadrant and keep them in sync.

shared_preferences stores key-value pairs across platforms. citeturn4search0  
flutter_riverpod is designed for reactive state and async handling. citeturn4search1turn4search17

#### Splash implementation prompt
> Add a native splash screen using `flutter_native_splash` (configure background color and logo; run `dart run flutter_native_splash:create`). Then implement an in-app `SplashScreen` that plays a local Lottie animation while initializing settings/database; after completion, transition to AppShell with a fade-through animation.

Flutter documentation outlines splash screen options, including packages. citeturn0search22turn0search0  
Lottie supports cross-platform including web. citeturn0search1

### Combined “do it all” Cursor prompt for your current stage

Paste this as a single Cursor prompt when you are ready to refactor in one cohesive sweep:

```text
Goal: Modernize Advocato UI/UX to a polished Material 3 style with consistent theming, better colors, sleek animations, an improved bottom-left quadrant menu, dynamic settings, and an animated splash.

Environment: Flutter 3.41.x, Dart 3.11.x, Windows dev with Chrome testing. Keep cross-platform Android/iOS/web compatibility.

1) Dependencies:
   Add/update:
   - flex_color_scheme
   - google_fonts
   - animations
   - flutter_animate
   - skeletonizer
   - shared_preferences
   - flutter_riverpod
   - lottie
   Dev dependency:
   - flutter_native_splash
   Run flutter pub get.

2) Theming:
   - Create AdvocatoTheme using ColorScheme.fromSeed(seedColor: 0xFF1E3A5F) for light/dark.
   - Use flex_color_scheme to set unified radius, input styles, cards, buttons.
   - Apply GoogleFonts Inter globally.
   - Ensure colors are used for surfaces, selected states, chips, and buttons.

3) Navigation:
   - Replace BottomNavigationBar with Material 3 NavigationBar.
   - Implement tab switching with FadeThroughTransition (animations package) and keep tabs alive via IndexedStack.

4) Home polish:
   - Replace search TextField with Material 3 SearchBar (styled).
   - Improve FilterChips style.
   - Add micro animations to empty state + FAB (flutter_animate).
   - Wrap case list loading states with skeletonizer.

5) Case card transitions:
   - Implement OpenContainer for CaseCard -> CaseDetail placeholder.

6) Menu quadrant:
   - Rebuild hamburger menu as a bottom-left quadrant overlay using showGeneralDialog:
     * widthFactor ~0.62, heightFactor ~0.55, anchored bottom-left
     * scrim + optional blur
     * slide+fade animation
     * quick toggles: Theme + Large Text
     * menu items: Profile, Courts Manager, Settings, FAQs, About

7) Dynamic Settings:
   - Implement AppSettingsController using shared_preferences + flutter_riverpod.
   - Settings screen updates immediately (ThemeMode, large text).
   - Reminder toggle hides/shows detail tiles.

8) Splash:
   - Configure flutter_native_splash and generate native splash.
   - Create in-app SplashScreen with a local Lottie animation while initialization runs.
   - Transition to AppShell using FadeThroughTransition.

Deliverables:
- UI looks significantly more modern and branded (colors, typography, surfaces).
- Menu quadrant is properly positioned and animated.
- Smooth transitions and micro-interactions exist but remain professional.
- Splash experience looks polished on web (in-app) and mobile (native + in-app).
```

