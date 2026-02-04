# CLAUDE.md - Project Context for Yalla

## Project Overview
**Yalla** is a trip planning web application built with Ruby on Rails. Users can:
- Create and organize trips with activities
- Drag & drop activities between days (Trello-like UX)
- Collaborate with friends via invitations
- Find inspiration from public trips
- Use "Make my day" algorithm for automatic activity sorting

## Tech Stack
- **Ruby**: 3.2.3
- **Rails**: 7.1.5
- **Database**: PostgreSQL
- **Frontend**: Bootstrap 3, jQuery, jQuery UI (drag & drop)
- **Authentication**: Devise + OmniAuth (Facebook)
- **File uploads**: Carrierwave + Cloudinary
- **Maps**: gmaps4rails, Geocoder
- **Other**: Figaro (env vars), Kaminari (pagination), acts_as_votable

## Common Commands
```bash
# Start server
bin/rails server

# Console
bin/rails console

# Run tests
bin/rails test

# Database
bin/rails db:migrate
bin/rails db:seed

# Linting
bundle exec rubocop
```

## Project Structure
```
app/
├── controllers/
│   ├── activities_controller.rb   # CRUD for activities
│   ├── trips_controller.rb        # Main trip management
│   ├── trip_days_controller.rb    # Day columns in trips
│   ├── invites_controller.rb      # Trip invitations
│   └── participants_controller.rb # Trip collaborators
├── models/
│   ├── trip.rb          # Main entity, has_many :trip_days, :activities
│   ├── trip_day.rb      # Day column, belongs_to :trip
│   ├── activity.rb      # Individual activity/place
│   ├── user.rb          # Devise user
│   ├── participant.rb   # User-Trip join (collaborators)
│   └── invite.rb        # Pending invitations
└── views/
    └── trips/edit.html.erb  # Main trip planning interface
```

## Key Routes
- `GET /` - Home page
- `GET /trips` - List public trips
- `GET /my_trips` - User's trips
- `GET /trips/:id/edit` - Main trip planning interface (drag & drop)
- `PUT /activities/:id/change_position` - AJAX for drag & drop
- `GET /trips/:id/map_markers.json` - Map markers API

## Database Schema (Key Models)
- **trips**: title, city, country, lat/lon, photo, public, user_id
- **trip_days**: title, date, trip_id
- **activities**: title, description, address, lat/lon, trip_id, trip_day_id, index (position)
- **participants**: user_id, trip_id, role
- **invites**: email, trip_id, sender_id, recipient_id, token

## Environment Variables (via Figaro)
Required in `config/application.yml`:
- `CLOUDINARY_URL` - Image uploads
- Facebook OAuth credentials
- Google Maps API key

## Recent Changes & Learnings

### Deprecation Fixes (Jan 2025)
- Replaced all `redirect_to :back` with `redirect_back(fallback_location: root_path)` (Rails 5+ deprecation)

### Manage Trip Page Redesign (Jan 2025)
- Modernized `/trips/:id` show page with card-based layout
- Added participant avatars, better visual hierarchy

### Cloudinary Configuration
- Added explicit initializer at `config/initializers/cloudinary.rb`

### Unsplash Photo Search
- Fixed by stripping country code from search queries

## Code Conventions
- ERB templates (not Haml/Slim)
- jQuery for frontend interactivity
- JS responses (`.js.erb`) for AJAX updates
- Bootstrap 3 classes for styling
- I18n support (en, fr, de locales)

## Known Issues / Backlog
See `STORIES.md` for detailed backlog. Key items:
- "Make my day" algorithm needs rework
- N+1 queries in some controllers
- Consider WebSocket for real-time collaboration
