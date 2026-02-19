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

### 8. Fix Undo Feature (F5)
- **Status**: Done
- Fixed selector bug: `#act-` instead of `#activity-`
- Added error handling and validation
- Shows "Undoing..." toast during operation

### 9. Keyboard Shortcuts (F3)
- **Status**: Done
- `N` - Focus new activity input
- `↑↓` or `JK` - Navigate up/down in column
- `←→` or `HL` - Navigate between day columns
- `Enter` - Expand/collapse selected card
- `Delete` - Delete selected card (with confirmation)
- `Esc` - Deselect card
- `?` - Show keyboard shortcuts help
- Click card to select, blue outline shows selection

---

## Backlog - Frontend (Trello-like Experience)

*All major frontend improvements completed!*

---

## Backlog - Backend

### B1. WebSocket Real-time Updates (Action Cable)
- Real-time sync for collaborators editing same trip
- Essential for participants feature
- **Priority**: Medium

### B2. ~~Fix N+1 Queries~~ ✅ Done
- Eager loading via `includes(trip_days: { activities: :main_category })` in `set_trip`
- Replaced all Ruby `.sort` with SQL `order` scopes on associations
- Refactored `my_trips` to single query

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

## Backlog - Trip Show Page (`/trips/:id`)

### T1. Banner & Hero Section
- Add dark gradient overlay for text readability on any photo
- Display trip dates, category, and activity count in the hero
- Show author avatar next to "By: username"
- **Priority**: Medium

### T2. Sticky Day Tabs Navigation
- Add sticky tabs at top to navigate between days without scrolling
- Show badge with activity count per day
- **Priority**: Medium

### T3. Empty State Improvement
- Replace bare "No activities yet" with illustration/icon
- Add CTA "Start planning this day" for owner, neutral message for visitors
- **Priority**: Low

### T4. Interactive Map
- Replace static map image with interactive Google Maps (gmaps4rails already available)
- Show route/itinerary between activities of the same day
- Clickable pins linking to activity cards
- **Priority**: High

### T5. Timeline Enhancements
- Add estimated times and travel duration between activities
- Add Google Maps directions link between consecutive activities
- **Priority**: Medium

### T6. Enable Share Button
- Uncomment existing share button (currently commented out in show.html.erb)
- Implement `navigator.share` API with fallback to copy-link
- **Priority**: Low

### T7. Responsive Layout Fix
- `col-md-6` causes unbalanced layout on 3-day trips (2+1)
- Consider full-width per day or carousel/swiper
- **Priority**: Low

### T8. SEO & Open Graph Meta Tags
- Add OG meta tags (title, description, image) for social media previews
- **Priority**: Medium

### T9. Unassigned Activities Card Redesign
- Current `col-md-3` cards are too small
- Switch to `col-md-4` or horizontal list layout with larger photos
- **Priority**: Low

---

## Backlog - Backend (General)

### B7. Async Email Delivery
- `send_trip` uses `deliver_now` which blocks the request
- Switch to `deliver_later` with Active Job
- **Priority**: Medium

### B8. Fix `create_trip_days` Multiple Saves
- Currently calls `@trip.save` on every loop iteration
- Build all trip_days first, then save once
- **Priority**: Low

### B9. Fragment Caching
- Russian doll caching on trip show page (day cards, activity cards)
- Cache static map URLs (deterministic)
- **Priority**: Low

### B10. Trip View Counter
- Add view counter on public trips (impressionist gem or counter_cache)
- Useful for ranking popular trips
- **Priority**: Low

### B11. JSON API for Trip Show
- Add jbuilder/jsonapi-serializer for trip show endpoint
- Prepares for future frontend modernization (React/Vue/Turbo)
- **Priority**: Low

---

## Backlog - Sign Up

### S1. Remove Username Field
- Enlever le champ "Nom d'utilisateur" (username)
- **Priority**: Medium

### S2. Add CAPTCHA
- Ajouter un détecteur de robots (reCAPTCHA ou similaire)
- **Priority**: Medium
