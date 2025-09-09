# Habit Tracker for Garmin Forerunner 265

A modern Garmin Connect IQ app to track daily habits directly on your Garmin Forerunner 265.

## Overview

This app helps you stay on top of your daily habits by allowing you to:

- Track your progress for 5 predefined habits:
  1. Take Vitamins
  2. Take Creatine
  3. Workout
  4. Learn 30 minutes
  5. Meditate
- Emoji-based 2x3 grid UI for habits
- Toggle habit completion (mark/unmark)
- View a modern progress bar for daily completion
- Scroll between two pages: habits and 7-day history graph
- See a stylish, centered bar graph of the last 7 days' completions
- Dotted, light blue vertical separator lines for graph bars
- Numbers for each day shown below the graph
- Navigation via UP/DOWN/LEFT/RIGHT buttons
- Start button disabled on the graph page
- Persistent progress and history (auto-reset at midnight)

---

## Features

- Emoji grid UI for habits
- Toggle completion for each habit
- Modern, colorful progress bar
- 7-day rolling history with stylish graph
- Dotted, faded blue separator lines in graph
- Numbers below graph bars for clarity
- Paging between habits and history graph
- Navigation optimized for Forerunner 265 (round, 416x416px)
- Persistent storage of progress and history
- Auto-reset at midnight

---

## Installation

1. Compile the project using the Garmin Connect IQ SDK.
2. Transfer the `.prg` file to your Garmin Forerunner 265:
   - Via USB: Copy the file to `GARMIN/APPS/`
   - Or via Garmin Express / Connect IQ mobile app
3. Open the app on your watch and start tracking your habits.

---

## Usage

- Use **UP/DOWN** to scroll habits or switch pages
- Use **LEFT/RIGHT** to switch between habits and graph
- Press **ENTER** to toggle habit completion (only on habits page)
- View your daily progress bar and 7-day history graph
- Progress and history are saved automatically

---

## Development

- Written in **Monkey C** for Garmin Connect IQ 3.2+
- Project structure:
  - `source/HabitTrackerApp.mc`: Main app logic, persistence, history
  - `source/HabitTrackerView.mc`: UI rendering, emoji grid, graph, paging
  - `source/HabitTrackerDelegate.mc`: Input handling, navigation, toggle logic
  - `source/HabitTrackerMenuDelegate.mc`: Menu input delegate (optional)
  - `resources/`: Layouts, icons, strings

---

## Changelog

- Modern emoji grid UI
- 7-day history graph with dotted blue separators
- Numbers below graph bars
- Paging between habits and graph
- Persistent progress and history
- Optimized for Forerunner 265

---

## License

MIT License
