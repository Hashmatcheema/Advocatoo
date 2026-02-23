# ADVOCATO
## Legal Practice Management Application
### Software Requirements Document (SRD)
**Built on Flutter • Mobile-First • Offline-First • Pakistan**

| Document Version | 1.0 |
|---|---|
| Platform | Flutter (Android / iOS / Web) |
| Model | Incremental Development Model |
| Target Users | Pakistani Lawyers / Advocates |
| Architecture | Single-User, Offline-First (SQLite) |
| Date | February 2026 |

---

## 1. Introduction

### 1.1 Purpose
This Software Requirements Document (SRD) defines the complete functional and non-functional requirements for Advocato, a Flutter-based mobile-first legal practice management application. Advocato is designed specifically for lawyers and advocates practising in Pakistan. The document serves as the primary reference for incremental development, enabling a structured, milestone-driven approach to building and delivering the application.

### 1.2 Scope
Advocato will allow individual advocates to manage their case portfolio, track hearing schedules, maintain document evidence, monitor deadlines, and receive timely reminders — all without an internet connection. The initial release (v1.0) targets single-user, offline usage. Future increments will introduce authentication, multi-user collaboration, and cloud synchronisation.

### 1.3 Definitions & Abbreviations
| Term | Definition |
|---|---|
| SRD | Software Requirements Document |
| Advocate / Lawyer | The primary end-user of the application |
| Case | A legal matter being managed within the app |
| Hearing | A scheduled court appearance tied to a case |
| SQLite | Embedded on-device relational database |
| DD/MM/YYYY | Date format used throughout the application |
| 12h | 12-hour (AM/PM) time format used throughout |
| FAB | Floating Action Button — the "+" button on the Home screen |

### 1.4 Development Approach: Incremental Model
The Incremental Development Model was chosen to allow early, usable releases while progressively adding functionality. Each increment builds upon the previous and delivers testable, working software. This is especially appropriate for a single-developer project where requirements may be refined during development.

Each increment described in Section 6 maps to a Cursor development session and represents a self-contained, deployable slice of functionality.

---

## 2. Overall System Description

### 2.1 Product Overview
Advocato is an offline-first, mobile-first Flutter application. Data is stored locally using SQLite (via the drift or sqflite package). The app targets Android as its primary platform, with browser-based testing on Windows during development. The UI is modern, sleek, and follows Material Design 3 principles, while supporting both light and dark themes, and a large-text accessibility mode.

### 2.2 User Class
A single class of user exists in v1.0: the Advocate. This user has full read and write access to all data within their device. No authentication is required in this increment.

### 2.3 Constraints
- No internet connection is required or assumed.
- All data must persist across app restarts via local SQLite storage.
- Push notifications must work on Android without FCM in offline scenarios (local notifications only via flutter_local_notifications).
- Date format: DD/MM/YYYY throughout the entire application.
- Time format: 12-hour (AM/PM) throughout.
- Reminders fire at 07:00 every day except Sunday.
- Only the Case Title field is mandatory; all other case fields are optional.
- Only one hearing per case per calendar day is permitted.

### 2.4 Assumptions
- The device running the app has a camera.
- The app is initially built and tested on a web browser in a Windows environment using Flutter web.
- Pakistan Standard Time (PKT, UTC+5) is the default timezone.
- Multi-user and authentication features are deferred to a future increment.

---

## 3. Navigation Architecture

### 3.1 Bottom Navigation Bar
A persistent bottom navigation bar is displayed on all top-level screens. It contains four items:

| Tab | Label | Description |
|---|---|---|
| 1 | Home | Case list with search, filters, and FAB to add new cases |
| 2 | Hearings | Calendar view and upcoming hearing list |
| 3 | Activity | Reminders, notifications, and next hearing updates |
| 4 | Menu (☰) | Hamburger icon opening a bottom-left drawer panel |

### 3.2 Back Navigation
Android back button and in-app back arrows must be implemented consistently. Back navigation is applied on: Case Detail Screen, Add/Edit Case Screen, Document Folder View, Hearing Detail, and Settings sub-screens. The bottom navigation bar does not display a back button. Modal cards (Add Case, Edit Hearing) dismiss on back.

---

## 4. Functional Requirements by Screen

### 4.1 Home Screen

#### 4.1.1 Top Navigation Bar
- **Left:** Circular profile avatar (tappable, navigates to Profile screen).
- **Center:** App name "Advocato" in branded typography.
- **Right:** Dashboard icon (opens a modal/bottom sheet showing key statistics).

#### 4.1.2 Dashboard Modal
When the dashboard icon is tapped, a bottom sheet or modal panel slides up showing:
- Total Cases (all time)
- Active Cases (no closed date set)
- Pending Hearings (today + future)
- Hearings This Week
- Cases by Type (mini bar or count breakdown: Civil / Criminal / Family / Corporate)
- Next Hearing: case title + date/time
- Cases added this month

#### 4.1.3 Search & Filter Bar
Below the top nav bar, a search text field and a filter icon are displayed. Filter options include:
- **Case Type:** Civil, Criminal, Family, Corporate
- **Court:** District, High Court, Supreme Court
- **Status:** Active, Closed
- **Date Range:** custom range picker

#### 4.1.4 Case Cards List
Cases are displayed as scrollable cards. Each card shows:
- Case Title (prominent)
- Case Type badge (colour-coded)
- Client Name (if added)
- Court Name + Bench
- Next Hearing Date (DD/MM/YYYY) and Purpose
- A small document count icon showing the number of document folders

#### 4.1.5 Add Case FAB
A circular Floating Action Button ("+") is fixed at the bottom-right of the screen, above the bottom nav bar. Tapping it opens the Add Case screen (full-screen card/modal). This screen includes all case input fields (see Section 4.4). Save and Cancel buttons are present. Only Case Title is mandatory.

### 4.2 Case Detail Screen
Tapping a case card navigates to the Case Detail Screen. This screen is divided into tabs or sections:

#### 4.2.1 Overview Tab
- Case Title, Case Type, Status
- Client Details: Name, Contact Number, CNIC (optional), Address
- Court: Court Name, Court Hierarchy Level, Bench, Courtroom Number
- Opposite Party / Counsel name (optional)
- Case Registration Number (optional)
- Date Filed (DD/MM/YYYY)
- Notes / Description (free text)

#### 4.2.2 Hearings Tab
A chronological list of all hearings for this case. Each hearing entry shows:
- Date (DD/MM/YYYY), Time (12h), Purpose, Outcome
- Past hearings marked differently from upcoming
- Tap to view/edit hearing detail
- Add Hearing button (validated: no duplicate date per case)

#### 4.2.3 Documents Tab
Documents are organised into folders. Each folder contains images (photos taken in-app or selected from gallery) and can be exported as a PDF.
- List of folders with name, document count, and creation date
- Tap a folder to view its images in a grid
- Create New Folder button
- Inside a folder: Add Image (camera or gallery), Delete image, Reorder images
- Export Folder as PDF option
- Folder can be renamed or deleted

#### 4.2.4 Edit / Delete Case
- Edit button opens the same full-screen Add/Edit Case card, pre-filled
- Delete case shows a confirmation dialog; deletion removes associated hearings and documents

### 4.3 Hearings Screen (Tab 2)

#### 4.3.1 Calendar View
A full calendar (TableCalendar or equivalent Flutter package) is displayed. Requirements:
- Shows current month by default
- Navigation to future and past months
- Dates with scheduled hearings show a small badge (e.g., a dot or number) indicating hearing count
- Tapping a date shows a list below (or in a bottom sheet) of all cases scheduled on that date, displaying Case Title, Purpose, Court Name, and Time
- Dates in the past are visually distinguishable

#### 4.3.2 Upcoming Hearings List
Below the calendar, an "Upcoming" section lists all future hearings sorted ascending by date. Each item shows Case Title, Date (DD/MM/YYYY), Time (12h), Court, and Purpose.

#### 4.3.3 Hearing Detail
Tapping a hearing from the calendar or the upcoming list opens the Hearing Detail screen. Fields include:
- Date (DD/MM/YYYY) — read-only after creation unless editing
- Time (12h format with AM/PM picker)
- Purpose: dropdown — Bail, Evidence, Arguments, Judgment, Framing of Charges, Reconciliation, Mediation, Other
- Outcome: free text (filled after the hearing has passed)
- Linked Case name (read-only reference)
- Notes
- Edit and Delete options

### 4.4 Add / Edit Case Screen
This screen is presented as a full-screen modal (appears to be a new screen). It is divided into logical sections:

#### 4.4.1 Basic Information
- **Case Title*** (mandatory, text field)
- **Case Type:** dropdown — Civil, Criminal, Family, Corporate
- **Case Registration Number** (optional)
- **Date Filed** (DD/MM/YYYY date picker, optional)
- **Status:** Active / Closed toggle
- **Notes / Description** (multi-line, optional)

#### 4.4.2 Court Details
- **Court Hierarchy Level:** dropdown — District Court, High Court, Supreme Court
- **Court Name:** searchable dropdown populated from saved courts list
- **Option to add a new court** inline from this dropdown ("Add New Court…")
- **Bench:** text field (judge/bench name)
- **Courtroom Number:** text field

#### 4.4.3 Client Details
- Client Name (optional)
- Client Contact Number (optional)
- Client CNIC (optional, format: XXXXX-XXXXXXX-X)
- Client Address (optional, multi-line)

#### 4.4.4 Opposite Party
- Opposite Party Name (optional)
- Opposite Counsel Name (optional)

#### 4.4.5 Action Buttons
- **Save:** validates Case Title is not empty, saves and closes
- **Cancel:** shows confirmation dialog if fields have been modified

### 4.5 Activity Screen (Tab 3)
- Upcoming reminder cards: "Next Hearing" for each active case with date and days remaining
- Overdue hearings: cases where a hearing date has passed with no outcome recorded
- Recent activity log: case added, hearing added, document uploaded (last 30 actions)
- Notification history: list of past triggered reminders

### 4.6 Menu / Hamburger Panel (Tab 4)
Tapping the hamburger icon on the bottom nav bar opens a panel that slides in from the bottom-left, occupying the bottom-left quadrant of the screen (approximately 50% width, 55% height, with rounded top-right corner). It overlays the screen with a translucent dark background on the rest of the screen.

Menu items:
- **Profile** — Edit advocate name, bar number, specialisation, profile photo
- **Courts Manager** — Add, edit, or delete courts from the master list
- **Settings** — Navigates to the Settings screen
- **FAQs** — Accordion-style FAQ screen
- **About** — App version, credits, legal notice
- **Send Feedback** — Opens chooser for Email or WhatsApp
- **Dark Mode Toggle** — Quick toggle visible in the panel
- **Large Text Toggle** — Quick toggle visible in the panel

### 4.7 Settings Screen
- **Theme:** Light / Dark / System Default
- **Accessibility:** Large Text Mode (increases base font size by 20%)
- **Notifications:** Enable / Disable daily reminders
- **Reminder Time:** fixed at 07:00, displayed for information
- **Reminder Days:** Mon–Sat (Sunday excluded, displayed for information)
- **Date Format:** DD/MM/YYYY (displayed, non-editable in v1.0)
- **Time Format:** 12-hour (displayed, non-editable in v1.0)
- **Data Backup:** Export all data as JSON file (future increment)
- **Data Restore:** Import JSON backup (future increment)

### 4.8 Courts Manager Screen
Accessible from the Menu panel. Allows the advocate to maintain a master list of courts.
- List of all saved courts with hierarchy level, name, and city
- Add New Court: fields are Hierarchy (District/High/Supreme), Court Name, City
- Edit existing court
- Delete court (with confirmation; warns if court is linked to active cases)

### 4.9 Profile Screen
- Profile photo (from gallery or camera)
- Advocate full name
- Bar Council enrollment number
- Specialisation (e.g., Criminal, Civil, Family)
- Phone number
- Email address
- Save button

---

## 5. Non-Functional Requirements

### 5.1 Performance
- App cold start must complete within 3 seconds on a mid-range Android device.
- Case list with up to 500 entries must scroll at 60 fps without jank.
- Document image loading must use lazy loading to avoid blocking UI.

### 5.2 Usability
- All tap targets must be at least 48x48 dp per Material Design guidelines.
- Date and time pickers must follow DD/MM/YYYY and 12h formats consistently.
- Error messages must be descriptive and placed near the relevant field.
- Confirmation dialogs are required for all destructive actions.

### 5.3 Accessibility
- Large Text Mode increases the base font scale factor by 20%.
- Sufficient colour contrast ratios (WCAG AA minimum) must be maintained in both themes.
- All interactive elements must have semantic labels for screen readers.

### 5.4 Reliability & Data Integrity
- SQLite transactions must be used for all write operations to prevent partial saves.
- Hearing uniqueness constraint (one per case per day) enforced at both UI and database level.
- Case deletion cascades to related hearings and document metadata.

### 5.5 Notifications
- Local notifications are scheduled daily at 07:00 (Mon–Sat) using flutter_local_notifications.
- Each notification summarises upcoming hearings for the next 7 days.
- Notification permission is requested on first launch (Android 13+).

### 5.6 Security (v1.0 Scope)
- No network access is required; no data leaves the device.
- No authentication in v1.0; the device's own lock screen provides access control.
- Sensitive fields (CNIC, phone) are stored in plaintext in SQLite in v1.0.

### 5.7 Theme & Appearance
- **Light Mode:** White/off-white backgrounds, navy/blue-grey accents (#1E3A5F primary).
- **Dark Mode:** Dark grey backgrounds (#121212, #1E1E1E), same accent colours.
- Theme persists across restarts (stored in SharedPreferences).
- Material Design 3 components are used throughout.

### 5.8 Localisation
- Language: English (Pakistan locale).
- Date: DD/MM/YYYY. Time: 12h AM/PM.
- Currency and number formatting: Pakistani conventions where applicable.

---

## 6. Incremental Development Plan

The project is divided into six increments. Each increment is a fully working, testable slice of the application. Cursor development sessions should address one increment at a time.

**Instruction for Cursor:** After completing each increment, run `flutter run -d chrome` and verify all features listed in that increment before starting the next.

### Increment 1 — Project Scaffold & Navigation Shell
**Goal:** A running Flutter app with correct navigation structure, theme switching, and no functionality yet.
- Flutter project creation with correct folder structure (features/, models/, services/, utils/)
- Bottom navigation bar with 4 tabs: Home, Hearings, Activity, Menu
- Placeholder screens for each tab
- Top app bar on Home with Profile avatar, "Advocato" title, Dashboard icon
- Hamburger panel: bottom-left quadrant slide-in panel with placeholder menu items
- Theme system: Light and Dark mode, toggled from menu panel, persisted via SharedPreferences
- Large Text accessibility mode scaffold (font scale factor)
- Date/time format constants established globally (DD/MM/YYYY, 12h)
- App icon and splash screen (basic)

**Cursor Prompt Suggestion:** "Build Increment 1 of Advocato: Flutter project scaffold with bottom nav bar (Home, Hearings, Activity, Menu), placeholder screens, sliding hamburger panel from bottom-left, light/dark theme toggle persisted in SharedPreferences, and global date/time format constants."

### Increment 2 — Case Management (Core CRUD)
**Goal:** Full case creation, viewing, editing, and deletion with local SQLite storage.
- SQLite database setup (drift or sqflite) with Cases table
- Case model with all fields: title, type, status, reg. number, date filed, notes, client details, court details, opposite party
- Add Case full-screen modal with all input sections and validation (only title mandatory)
- Case cards on Home screen (showing key fields)
- Case Detail screen with Overview tab
- Edit Case functionality
- Delete Case with confirmation dialog
- Search bar filtering by case title
- Filter panel: by case type, court level, status
- Courts Manager screen with CRUD for court master data
- Inline "Add New Court" from the case form dropdown

**Cursor Prompt Suggestion:** "Build Increment 2 of Advocato: SQLite-backed case CRUD. Full-screen Add Case modal (only title mandatory), case cards on Home with search and filter, Case Detail Overview tab, Edit/Delete case, and Courts Manager screen accessible from the hamburger menu."

### Increment 3 — Hearings Module
**Goal:** Full hearing lifecycle tied to cases, calendar view, and duplicate-date enforcement.
- Hearings table in SQLite (linked to cases by foreign key)
- Hearings tab in Case Detail: list of hearings (past + upcoming), Add Hearing button
- Add/Edit Hearing screen: date picker (DD/MM/YYYY), time picker (12h), purpose dropdown, outcome text, notes
- Validation: block duplicate date for same case
- Hearings screen (Tab 2): full calendar (TableCalendar package)
- Calendar badges showing hearing counts per date
- Tap date to show list of hearings on that date
- Upcoming Hearings list below calendar
- Hearing Detail screen with edit/delete

**Cursor Prompt Suggestion:** "Build Increment 3 of Advocato: Full hearings module. SQLite hearings table with case foreign key. Add/Edit Hearing screen (date DD/MM/YYYY, time 12h, purpose dropdown, outcome). Enforce one hearing per case per day. Hearings Tab 2 with TableCalendar showing badges per date. Tap date to list hearings. Upcoming hearings list."

### Increment 4 — Documents Module
**Goal:** Folder-based document management with camera and gallery support and PDF export.
- Documents tab in Case Detail screen
- DocumentFolders and DocumentImages tables in SQLite
- Create, rename, delete folders
- Add images to folder from device gallery (image_picker package)
- Add images from camera (image_picker with camera source)
- Grid view of images inside a folder
- Delete individual images
- Reorder images within a folder (drag-and-drop)
- Export folder as PDF (pdf package, images embedded in sequence)

**Cursor Prompt Suggestion:** "Build Increment 4 of Advocato: Documents module inside Case Detail. Folder CRUD in SQLite. Add images via camera or gallery using image_picker. Grid view per folder. Drag-to-reorder. Export folder as PDF using the pdf package."

### Increment 5 — Notifications, Activity & Reminders
**Goal:** Daily local push notifications at 07:00 (Mon–Sat), Activity screen, and notification history.
- flutter_local_notifications integration
- Daily notification scheduled at 07:00 (skipped on Sunday)
- Notification content: list of cases with hearings in the next 7 days
- Notification permission request on first launch (Android 13+)
- Activity screen: upcoming hearing cards, overdue hearings, recent activity log
- Notification history list in Activity screen
- Settings screen: enable/disable notifications, display reminder time and excluded days

**Cursor Prompt Suggestion:** "Build Increment 5 of Advocato: Local notifications via flutter_local_notifications, scheduled daily at 07:00 Mon-Sat with next-7-day hearing summary. Activity screen with upcoming hearings, overdue hearings, and recent activity log. Settings screen with notification toggle."

### Increment 6 — Polish, Dashboard & Remaining Features
**Goal:** Dashboard modal, profile screen, accessibility polish, Send Feedback, FAQs, About, and final UI refinement.
- Dashboard modal: total cases, active cases, hearings this week, cases by type, next hearing
- Profile screen: photo, name, bar number, specialisation, contact
- Send Feedback: platform chooser to open email client or WhatsApp
- FAQs screen: accordion-style expandable questions
- About screen: version number, developer credits
- Large Text Mode: apply font scale factor throughout app
- App-wide UI polish: consistent spacing, transitions, error states, empty states
- Empty state illustrations on Home and Hearings when no data
- Accessibility review: all tap targets ≥48dp, semantic labels, contrast check
- Performance review: lazy loading on image grids, paginated case list if > 100 cases

**Cursor Prompt Suggestion:** "Build Increment 6 of Advocato: Dashboard modal with stats, Profile screen, Send Feedback via email/WhatsApp, FAQs accordion, About screen, Large Text Mode, empty states, and final UI polish pass following Material Design 3."

---

## 7. Data Model (SQLite Schema)

### 7.1 Cases Table
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment primary key |
| title | TEXT NOT NULL | Mandatory field |
| case_type | TEXT | Civil/Criminal/Family/Corporate |
| status | TEXT | Active/Closed |
| registration_number | TEXT | Optional |
| date_filed | TEXT | Stored as ISO date string |
| court_id | INTEGER FK | References courts.id |
| bench | TEXT | Judge/bench name |
| courtroom_number | TEXT | Optional |
| client_name | TEXT | Optional |
| client_phone | TEXT | Optional |
| client_cnic | TEXT | Optional |
| client_address | TEXT | Optional |
| opposite_party | TEXT | Optional |
| opposite_counsel | TEXT | Optional |
| notes | TEXT | Free text |
| created_at | TEXT | ISO datetime |
| updated_at | TEXT | ISO datetime |

### 7.2 Courts Table
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment primary key |
| name | TEXT NOT NULL | Court name |
| hierarchy | TEXT | District/High/Supreme |
| city | TEXT | Optional |

### 7.3 Hearings Table
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment primary key |
| case_id | INTEGER FK | References cases.id (cascade delete) |
| hearing_date | TEXT NOT NULL | ISO date; UNIQUE(case_id, hearing_date) |
| hearing_time | TEXT | HH:MM 24h stored, displayed as 12h |
| purpose | TEXT | Bail/Evidence/Arguments/etc. |
| outcome | TEXT | Free text |
| notes | TEXT | Optional |

### 7.4 Document Folders Table
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment primary key |
| case_id | INTEGER FK | References cases.id (cascade delete) |
| name | TEXT NOT NULL | Folder display name |
| created_at | TEXT | ISO datetime |

### 7.5 Document Images Table
| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Auto-increment primary key |
| folder_id | INTEGER FK | References document_folders.id (cascade) |
| file_path | TEXT NOT NULL | Absolute path on device |
| sort_order | INTEGER | For drag-to-reorder |
| added_at | TEXT | ISO datetime |

---

## 8. Recommended Flutter Packages

| Package | Purpose | Notes |
|---|---|---|
| sqflite / drift | Local SQLite database | drift preferred for type-safety |
| shared_preferences | Theme and settings persistence | Simple key-value store |
| table_calendar | Full calendar widget | Supports event markers |
| image_picker | Gallery and camera image selection | Android + iOS support |
| flutter_local_notifications | Daily push notifications | Scheduled local only |
| pdf | PDF generation from images | dart_pdf / printing package |
| path_provider | Device file paths | For saving images and PDFs |
| url_launcher | Open email / WhatsApp for feedback | Required for Send Feedback |
| provider / riverpod | State management | Riverpod 2.x recommended |
| go_router | Navigation and routing | Supports nested navigation |
| intl | Date/time formatting | DD/MM/YYYY, 12h AM/PM |

---

## 9. Future Increments (Post v1.0)

The following features are acknowledged but explicitly deferred to future development cycles:

### Authentication & Multi-User
- User registration and login (email/phone + password)
- JWT-based session management
- Separate data stores per user

### Cloud Synchronisation
- Firebase Firestore or Supabase backend
- Real-time sync across devices
- Conflict resolution for offline edits

### Advanced Features
- Shared case access between co-counsel
- Billing and invoice generation
- Court fee calculator
- Export full case file as PDF
- Urdu language support
- Data backup to Google Drive / iCloud
- Case timeline / Gantt view

---

## Appendix A — Screen Summary

| Screen | Access Point | Increment |
|---|---|---|
| Home | Bottom Nav Tab 1 | 1 (shell), 2 (data) |
| Hearings | Bottom Nav Tab 2 | 3 |
| Activity | Bottom Nav Tab 3 | 5 |
| Menu Panel | Bottom Nav Tab 4 | 1 (shell), 6 (items) |
| Add / Edit Case | FAB / Case Detail Edit | 2 |
| Case Detail | Tap case card | 2 (overview), 3 (hearings), 4 (docs) |
| Hearing Detail | Tap hearing | 3 |
| Document Folder | Tap folder in case | 4 |
| Courts Manager | Menu panel | 2 |
| Settings | Menu panel | 5 |
| Profile | Menu panel / Top nav avatar | 6 |
| Dashboard Modal | Top nav dashboard icon | 6 |
| FAQs | Menu panel | 6 |
| About | Menu panel | 6 |

---

**End of Document — Advocato SRD v1.0**