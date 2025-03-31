# Pokemon
# Pokémon App

## Introduction
The Pokémon App is a fun and interactive game where users can test their knowledge of Pokémon by identifying Pokémon from images. The app fetches data from the Pokémon API and presents multiple-choice questions to the user. This project is built using SwiftUI, and async/await for smooth and responsive gameplay.

## Features
- Guess the Pokémon from the displayed image.
- Multiple-choice options to select the correct Pokémon name.
- Real-time score tracking.
- Next and Reset buttons to move between rounds or start over.
- Sleek and responsive UI with SwiftUI components.
- Asynchronous data loading with async/await.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ManjFirstProject/Pokemon.git
   ```
2. Open the project in Xcode:
   ```bash
   cd Pokemon
   open Pokemon.xcodeproj
   ```
3. Run the app on a simulator or a connected device:
   - Press `Cmd + R` to build and run.

## Usage
- Launch the app.
- Tap on one of the four options to select the Pokémon name.
- Use the 'Next' button to move to the next round.
- Press 'Reset' to start over.
- The score will be displayed on the top of the screen.

## Architecture
The app follows the MVVM (Model-View-ViewModel) architecture pattern for clean separation of concerns.

- **Model:** Represents the Pokémon data structure.
- **ViewModel:** Handles data fetching and game logic using async/await.
- **ContentView:** SwiftUI components that display the game interface.
- **MyNetworking:** Uses the `Router` and `RestAPI` to fetch data from the Pokémon API asynchronously.

## Testing
Unit tests are written using XCTest to validate the ViewModel and networking components.

- Mocking techniques are used to test network requests without making actual API calls.
- Tests cover success and failure scenarios to ensure robustness.

To run tests, use:
```bash
Cmd + U
```

## Technologies Used
- SwiftUI for UI components
- Async/Await for asynchronous networking
- URLSession for HTTP requests
- XCTest for unit testing

## Future Improvements
- Add more Pokémon data with pagination.
- Implement a leaderboard for high scores.
- Enhance UI with more animations and transitions.
- Add sound effects for correct and incorrect answers.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

