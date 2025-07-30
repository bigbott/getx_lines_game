# Player Generator for GetX Lines Game

## Overview
This directory contains scripts to generate random players with score for the leaderboard in the GetX Lines Game.

## Files
- `player_generator.dart` - The original player generator script (requires Flutter project dependencies)
- `standalone_player_generator.dart` - A standalone version that can be run independently

## How to Run the Standalone Generator

### Prerequisites
- Dart SDK installed
- Appwrite SDK for Dart (`appwrite` package)

### Installation
1. Make sure you have the Appwrite SDK installed:
   ```
   dart pub add appwrite
   ```

### Running the Generator
1. Navigate to the project root directory
2. Run the standalone generator script:
   ```
   dart run test/standalone_player_generator.dart
   ```

### What it Does
The script will:
1. Generate 100 random players with:
   - Unique user IDs
   - Random nicknames (adjective + animal format)
   - Random score between 0 and 9999
2. Save each player to the Appwrite database
3. Display progress as it runs

### Output
The script will print progress information to the console, including:
- Each player added with their nickname and score
- Progress count (x/100)
- Final summary of how many players were successfully added