# Cafeloca

Cafeloca is a mobile app for discovering cafés based on what you need at the moment, whether it's a place to work, study, hang out, or just grab a coffee nearby.

The project started as a UI/UX concept and is currently being developed into a working Flutter application.

## Current progress

The app currently includes:

- Home and café discovery
- Explore and search
- Café detail
- Café facilities and menu preview
- Live crowd status UI
- Table booking flow
- Login and register UI
- Saved and profile navigation

Most café data is still local dummy data. Authentication, booking, maps, and live status are not connected to a production backend yet.

## Screenshots

Screenshots will be added as the UI develops.

## Tech stack

- Flutter
- Dart
- go_router
- Material 3

Planned:

- Riverpod
- Supabase
- PostgreSQL
- Supabase Auth
- Supabase Storage
- Supabase Realtime
- Maps integration
- Next.js for the café owner/admin dashboard

## Project structure

The project is organized by feature.

```text
lib/
├── app/
│   ├── router/
│   ├── shell/
│   └── theme/
├── core/
│   └── widgets/
└── features/
    ├── auth/
    ├── booking/
    ├── cafe/
    ├── explore/
    ├── home/
    ├── profile/
    ├── saved/
    ├── splash/
    └── welcome/
```

Café-related code is further separated into data, domain, and presentation layers.

## Running the project

Make sure Flutter is installed and available on your machine.

```bash
flutter doctor
```

Clone the repository:

```bash
git clone <repository-url>
cd cafeloca-mobile
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

## Roadmap

### v0.1

- [x] Base design system
- [x] Navigation
- [x] Home
- [x] Explore
- [x] Café detail
- [x] Booking flow
- [x] Local café data

### v0.2

- [ ] Riverpod
- [ ] Repository layer
- [ ] Authentication state
- [ ] Guest/auth guard

### v0.3

- [ ] Supabase integration
- [ ] User authentication
- [ ] Café database
- [ ] Saved cafés
- [ ] Booking persistence
- [ ] Reviews

### Later

- [ ] Maps and location
- [ ] Realtime crowd status
- [ ] Café owner dashboard
- [ ] Notifications

## About the project

Cafeloca is currently a personal project and is still in active development.

The main idea is simple: instead of only showing cafés that are nearby, Cafeloca tries to help users find a café that fits what they want to do.

**Find Your Place.**
