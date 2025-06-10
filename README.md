# tiktok

A new Flutter project.

## 🔥 Firebase Setup Guide

This project uses [Firebase](https://firebase.google.com/) with Flutter via the official [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/). Follow the steps below to get started after cloning this repo.

---

### 🧱 Prerequisites

- Flutter SDK
- Firebase CLI: `npm install -g firebase-tools`
- FlutterFire CLI: `dart pub global activate flutterfire_cli`

---

### 🚀 Firebase Project Setup

#### 1. Create Firebase Project

- Visit [console.firebase.google.com](https://console.firebase.google.com)
- Create a new project (e.g. `flutter_video_feed`)
- Add platforms (Android/iOS/Web)

#### 2. Enable Firebase Services

- **Authentication** → Enable **Anonymous** or **Email/Password**
- **Firestore Database** → Create DB (test mode for dev)
- **Storage** → Get Started (test mode)

#### 3. Configure Firebase with FlutterFire

Run this command in the project root:

```bash
flutterfire configure
