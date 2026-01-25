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

---

## Backlog - Frontend (Trello-like Experience)

### F1. Optimistic UI Updates
- Update UI immediately when dragging activities
- Show subtle "saving..." indicator
- Rollback only if server fails
- **Priority**: High

### F2. Inline Editing
- Click on activity title/description to edit directly in card
- Use contenteditable or inline input fields
- Save on blur or Enter key
- **Priority**: Medium

### F3. Keyboard Shortcuts
- `N` - Add new activity
- `Esc` - Cancel current action
- Arrow keys - Navigate between cards
- `Enter` - Open activity details
- **Priority**: Low

### F4. Better Drag Visual Feedback
- Ghost/placeholder showing where card will land
- Highlight target day column on hover
- Animate cards shifting to make room
- **Priority**: High

### F5. Undo/Redo
- History stack of actions
- Toast notification: "Activity moved" with Undo button (5s timeout)
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

---

## Backlog - Sign Up

### S1. Remove Username Field
- Enlever le champ "Nom d'utilisateur" (username)
- **Priority**: Medium

### S2. Add CAPTCHA
- Ajouter un détecteur de robots (reCAPTCHA ou similaire)
- **Priority**: Medium
