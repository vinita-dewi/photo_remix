# Photo Remix

Flutter app that lets a signed-in Firebase user upload an image, call a Cloud Function to generate transformed images via Hugging Face Inference, and view the generated results. Storage uses the Firebase Storage emulator; Firestore talks to your live project.

## Demo
<img src="docs/Screen_recording_20251206_231157.gif" alt="Screen recording 2025-12-06" width="200" />

## Prerequisites
- Flutter SDK (matching the version in `pubspec.lock`)
- Firebase CLI (for emulators / deploys)
- Node 18 for Firebase Functions
- Hugging Face account with an access token that can call the chosen model (`HF_TOKEN`)

## Project layout
- `lib/` – Flutter app (Bloc, UI, etc.)
- `functions/` – Firebase Cloud Functions (Hugging Face text-to-image/img2img proxy)
- `firestore.rules` / `storage.rules` – security rules
- `.secret.local` (not committed) – local secrets for functions

## Setup
1) Install Flutter deps:
   ```bash
   flutter pub get
   ```
2) Functions deps:
   ```bash
   cd functions
   npm install
   ```
3) Create `functions/.secret.local` (do **not** commit):
   ```
   HF_TOKEN=your_hf_token_here
   HF_MODEL_ID=stabilityai/stable-diffusion-xl-base-1.0   # or another accessible model
   ```
   Restart the Functions emulator after changing secrets.

## Running locally
In one terminal (project root):
```bash
firebase emulators:start --only functions,storage
```
- Storage emulator runs on `127.0.0.1:9197` per current config.
- Firestore points to your production project (no emulator).

In another terminal:
```bash
flutter run
```

## Cloud Function (functions/index.js)
- Callable function `generateImage`:
  - Validates input (`category`, base64 image).
  - Calls Hugging Face Inference router with `HF_TOKEN` and `HF_MODEL_ID`.
  - Uses img2img settings tuned to preserve the subject and returns one generated image (base64) per call.
  - The app calls this four times in parallel and stores results in Storage + Firestore.


## Deploying
- Functions:
  ```bash
  cd functions
  npm run lint   # optional
  firebase deploy --only functions
  ```
- Rules:
  ```bash
  firebase deploy --only firestore:rules,storage:rules
  ```

## Troubleshooting
- 401/404 from HF: verify `HF_TOKEN` scope and that `HF_MODEL_ID` is accessible with your token via `curl` to `https://huggingface.co/api/models/<model>`.
- JSON/binary errors: ensure you’re on the latest `functions/index.js` (it handles both JSON and binary HF responses).
- node_modules showing in `git status`: run `git rm -r --cached node_modules functions/node_modules` once, then commit.

## Limitations
- Free-tier Hugging Face inference can be slow, rate-limited, and may swap or simplify subjects; quality/subject fidelity is not guaranteed.
- Models like `stabilityai/stable-diffusion-xl-base-1.0` are text-to-image first; img2img preservation is best-effort and may still drift.
- No paid Gemini/Nano Banana models are used, so accuracy may be below production expectations until a higher-fidelity model is available.
