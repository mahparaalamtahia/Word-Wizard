# FixBuddy Current State

**Snapshot date:** May 13, 2026

FixBuddy is currently a Flutter app built with Clean Architecture, Riverpod, and Supabase. The core platform is in place, and the app is past the initial scaffolding stage.

## What Is Working

- Auth flow is implemented with Supabase login, registration, logout, and session handling.
- App startup routing is wired through `MaterialApp` with named routes and session-aware redirects.
- Worker listing is implemented with search, category filtering, area filtering, and rating-based sorting.
- Admin profile support is in place, including role-aware profile creation and route protection.
- The design system, theme, and reusable auth widgets are already established.

## What Is Partial

- Booking features exist at the schema and repository level, but the full user flows are not complete.
- Reviews and ratings are partially implemented, with schema and backend support but missing UI polish.
- Notifications have schema and basic data access, but realtime behavior and push support are still pending.
- Admin dashboard screens are still mostly placeholder/stub work.

## What Is Still Pending

- Chat feature implementation.
- Favorites UI and full profile management screens.
- Booking detail, acceptance, rejection, and history screens.
- Reviews submission and display flows.
- Testing coverage, especially unit, widget, and integration tests.
- Deployment polish and store-ready release work.

## Current Technical Shape

- Frontend: Flutter + Material Design 3
- State: Riverpod
- Backend: Supabase
- Database: PostgreSQL through Supabase
- Architecture: Clean Architecture with domain, data, and presentation layers
- Routing: Named routes with startup session handling

## Notes

- The repo already contains a more detailed progress log in `DEVELOPMENT_STATUS.md`.
- Routing behavior should keep the canonical workers route aligned with the current app router setup.