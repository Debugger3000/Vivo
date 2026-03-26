# Vivo

Vivo is a Map Based social app to find local live events + hobby groups. Users, friends, messaging, meeting new people.

## Setup

1. Server:
   - `cd server`
   - Create a `.env` with `DATABASE_URL` and optional `PORT` (default: `3001`)
   - Run `go run index.go`

2. Client:
   - `cd client/vivo_front`
   - Create a `.env` with `HOST_IP`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `MAPS_API_KEY`, `S3_ACCESS_KEY`, and `S3_SECRET_KEY`
   - Run `flutter pub get`
   - Run `flutter run`
