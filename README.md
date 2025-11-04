# Flutter To-Do List App

## Overview
A simple, clean-architecture to-do list built with Flutter, Riverpod, and sqflite. Features:
- Add, edit, delete tasks (title, description, due date).
- Toggle complete/incomplete.
- Local persistence with sqflite.
- Tasks sorted by due date (ascending).
- Filter by completed/incomplete.
- Clean architecture (presentation/domain/data).
- Unit test for task sorting.

## Tech stack
- Flutter
- flutter_riverpod
- sqflite
- path_provider
- intl
- uuid

## Setup
1. Clone repo:
   ```bash
   git clone https://github.com/NimeshDeepamal/Todo_App
   cd todo_app
2. Install deps:
    flutter pub get
3. Run app:
    flutter run
4. Tests:
    flutter test


## Architecture
- Domain: Entities and repository interfaces.
- Data: sqflite local datasource, repository implementation.
- Presentation: Riverpod StateNotifier for tasks and UI screens.
I chose Flutter + Riverpod because Riverpod provides an easy, testable state management with good separation of concerns and Riverpod integrates cleanly into Flutter apps. sqflite provides reliable local persistence and ordering via SQL.

## Challenges & solutions
- Date/time selection UX: combined date + time pickers to provide full date-time support.
- Sorting: ensured repo/db query orders by dueDate ASC and re-sorted after load as a safety net.
- Persistence edge cases: used ConflictAlgorithm.replace to avoid duplicate-id insertion issues.