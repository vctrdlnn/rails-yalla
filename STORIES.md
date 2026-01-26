# User Stories - trips/edit

## Completed

### 1. Activity Type Recognition
- **Status**: Done
- Auto-classify locations (Museum, Restaurant, Park, etc.) from Google Places API
- Added `getBestPlaceType()` in JS and `humanize_place_type()` helper in Ruby

### 2. Horizontal Scroll for Multi-Day Trips
- **Status**: Done
- Drag/scroll functionality for day columns
- Gradient fade indicator when more days exist
- Touch support for mobile

### 3. Responsive Design Overhaul
- **Status**: Done
- Mobile tabs: Plan | Days | Map
- Panels hidden/shown based on active tab on mobile

### 4. Bug Fixes
- **Status**: Done
- Fixed map markers not updating (partial format issue)
- Fixed activity title not updating on subsequent searches
- Fixed JS scope issue with checkOverflow function
- Fixed modal edit (update.js.erb) - proper modal close, accordion init

### 5. Better Drag Visual Feedback (F4)
- **Status**: Done
- Animated striped placeholder showing drop target
- Dragged card has rotation, scale, shadow
- Target column highlights blue when dragging over

### 6. Optimistic UI Updates (F1)
- **Status**: Done
- UI updates immediately when dragging/editing
- Toast notifications: "Saving...", "Saved", error states
- Automatic rollback on server error

### 7. Inline Editing (F2)
- **Status**: Done
- Double-click to edit: title, description, URL
- Single-click dropdown for category
- Photo upload with file picker
- Enter to save, Escape to cancel

---

## Backlog - Frontend (Trello-like Experience)

### F3. Keyboard Shortcuts
- `N` - Add new activity
- `Esc` - Cancel current action
- Arrow keys - Navigate between cards
- `Enter` - Open activity details
- **Priority**: Low

### F5. Fix Undo Feature
- **Issue**: Current undo implementation doesn't work correctly
- Undo button appears but action fails
- Need to debug and fix the undo logic
- **Priority**: Medium

---

## Backlog - Backend

### B1. WebSocket Real-time Updates (Action Cable)
- Real-time sync for collaborators editing same trip
- Essential for participants feature
- **Priority**: Medium

### B2. Fix N+1 Queries
- Use `includes(:trip_day)` for eager loading
- Profile and optimize slow queries
- **Priority**: Medium

### B3. API Endpoints for AJAX
- Proper JSON API for activities CRUD
- Replace JS.erb responses with JSON
- **Priority**: Low

### B4. Background Jobs for "Make My Day"
- Move algorithm to Sidekiq job
- Add progress updates
- **Note**: Algorithm needs to be fixed first - current implementation doesn't make sense
- **Priority**: Low (blocked)

### B5. Request Debouncing
- Debounce save requests when rapidly dragging cards
- Save only after 300ms of no movement
- **Priority**: Low

### B6. Activity Change History / Audit Log
- Track meaningful changes made by participants
- Store: who, what, when for each change
- Display history in UI (timeline or log view)
- Useful for collaboration and accountability
- Consider: Activity created, moved, edited, deleted
- **Priority**: Medium

---

## Backlog - Sign Up

### S1. Remove Username Field
- Enlever le champ "Nom d'utilisateur" (username)
- **Priority**: Medium

### S2. Add CAPTCHA
- Ajouter un détecteur de robots (reCAPTCHA ou similaire)
- **Priority**: Medium
