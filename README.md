EgoLift App
===========
![egoliftpreview](https://github.com/user-attachments/assets/96d50ead-710e-43f3-a3c8-c3b921dc39aa)

Table of Contents
-----------------

1.  [Overview](#overview)
2.  [Features](#features)
3.  [Requirements](#requirements)
4.  [Installation](#installation)
5.  [Usage](#usage)
6.  [Project Structure](#project-structure)
7.  [Database](#database)
8.  [License](#license)

Overview
--------

EgoLift is a comprehensive fitness tracking app designed to help users manage their workout routines, track water intake, and maintain exercise notes. The app is built using SwiftUI and leverages SQLite for persistent data storage.

Features
--------

-   **Workout Management**: Create, view, and delete workouts.
-   **Exercise Tracking**: Add, view, and delete exercises associated with specific workouts. Exercises can be added directly or selected from a pre-defined library.
-   **Water Intake Tracking**: Track daily water consumption with adjustable goals.
-   **Timer**: A built-in timer for tracking exercise recovery periods.
-   **Notes**: Add and manage notes for each exercise.
-   **Categories**: Organize exercises by categories such as Chest, Back, Shoulders, etc.

Requirements
------------

-   iOS 14.0+
-   Xcode 12.0+
-   Swift 5.0+

Installation
------------

1.  **Clone the Repository or download the zip in the [Release](https://github.com/MichBattle/EgoLiftApp/releases)**

2.  **Open the Projec in Xcode**

3.  **Build and Run**: Select the desired simulator or device and click on the build and run button in Xcode.

Usage
-----

1.  **Home Screen**: Displays the list of workouts and a widget for tracking daily water intake.
2.  **Add Workout**: Use the '+' button on the home screen to create a new workout.
3.  **Workout Details**: View the list of exercises in a workout, add new exercises, and manage existing ones.
4.  **Exercise Details**: View exercise details, start/stop the timer, and add notes.
5.  **Exercise Library**: Browse exercises by category and add them to workouts.
6.  **Water Intake Widget**: Tap to reset or adjust daily water goal and log water intake.

For a more in-depth understanding of how the app works check out the [instruction manual](https://github.com/MichBattle/EgoLiftApp/blob/main/instructionManual.md)

Project Structure
-----------------

The project is structured as follows:

-   **Views**: Contains all the SwiftUI views.

    -   `ContentView.swift`: The main view containing the home screen and navigation.
    -   `EsercizioDetailView.swift`: View for displaying exercise details and managing the timer.
    -   `EsercizioEditView.swift`: View for editing exercise details.
    -   `EsercizioNoteDetailView.swift`: View for displaying and managing notes for an exercise.
    -   `EserciziCategoriaView.swift`: View for displaying exercises by category.
    -   `EserciziLibraryView.swift`: View for selecting exercises from the library.
    -   `NoteListView.swift`: View for listing and managing notes.
    -   `WaterIntakeWidget.swift`: Widget for tracking daily water intake.
    -   `EserciziListView.swift`: View for displaying categories of exercises.
-   **Models**: Contains the data models.

    -   `Allenamento.swift`: Model representing a workout.
    -   `Esercizio.swift`: Model representing an exercise.
    -   `EsercizioNote.swift`: Model representing a note for an exercise.
    -   `TimerManager.swift`: Singleton for managing the timer state.
    -   `SharedState.swift`: ObservableObject for managing shared state across views.
-   **Database**: Contains the database manager.

    -   `DatabaseManager.swift`: Singleton class for managing SQLite database operations.
-   **AppDelegate.swift**: Manages app lifecycle events.

-   **EgoLiftApp.swift**: The main entry point for the app.

Database
--------

The app uses SQLite for data persistence. The database schema includes tables for workouts (`allenamenti`) and exercises (`esercizi`). Exercises can be linked to multiple workouts and have associated notes.

### Schema

-   **Allenamenti Table**:

    -   `id`: Integer, Primary Key
    -   `nome`: String, Unique
-   **Esercizi Table**:

    -   `id`: Integer, Primary Key
    -   `allenamento_id`: Integer, Foreign Key
    -   `nome`: String
    -   `descrizione`: String
    -   `tempo_recupero`: Integer
    -   `note`: String
    -   `numero_set`: String
    -   `tipo`: String
    -   `is_original`: Boolean, Default False

### Migrations

The `DatabaseManager` includes logic for database migrations, such as adding new columns to existing tables.

License
-------

This project is licensed under the MIT License. See the `LICENSE` file for details.
