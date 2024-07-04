# pokedex

https://pokeapi.co/docs/v2

This is a Flutter app that follows the Vanilla software development philosophy, so that it has the following advantages (similar to the ones obtained by using VanillaJS in web development):

- No external dependencies required besides the ones specified in pubspec.yaml, reducing complexity.

- No special IDE required. Reducing set up steps to almost 0.

- 0 Visual Studio Code plugins required. So, no possibility of being victim of common malware present in plugins. Source: Malicious VSCode extensions with millions of installs discovered
https://www.bleepingcomputer.com/news/security/malicious-vscode-extensions-with-millions-of-installs-discovered

- No third-party state management, only the Flutter standard library, thus performance is literally the best Flutter can possibly offer.

- Reduce to almost zero the possibility of having issues related to dependencies versions conflicts. Which tend to raise to the sky the costs of maintenance.


## Set up instructions

1. Open this directory in the terminal
2. Launch an Android emulator (usually with a command like this: flutter emulators --launch <my-emulator-name>) or connect an Android phone to the laptop (with "USB debugging" option enabled in "Settings/Developer options").
3. Execute: flutter run


## Build APK

Execute this in Windows terminal in the project root directory:

- flutter build apk
- rem Just to open the directory faster than manually:
- cd build\app\outputs\apk\release
- explorer .


## Image copyright

App icon was generated using Dall-E 3 AI from the official Microsoft Copilot Android app.
Path: assets/logo.png


## Cache

To Follow this:

"Fair Use Policy: Locally cache resources whenever you request them"
- Source: https://pokeapi.co

The app uses Hive local database for data persistance. When the app does a GET request, it checks if the resource was previously saved in cache to avoid doing it twice. This cache persists over app sessions.


## Data persistance in the app

This app uses Hive as a local database for data persistance.
https://pub.dev/packages/hive

According to multiple benchmarks, Hive is better than popular options like SharedPreferences or SQLite. Source:
https://github.com/hivedb/hive_benchmark

And it requires just 5 extra lines of code in main.dart to work on all app pages. So maintainance costs is significantly lower compared to other options that requires a complex set up.


## Hive data

Hive stores data in boxes, and each box consists of key-value pairs.

Data fetched from the API is stored locally as cache in the "cache" Hive box:

• Key: "All names"
Value: List<String>.

• key: <pokemon-name>
Value: Map<String,Map>, the key here is the pokemon name and the value is a map with its data, which consists of these fields:
  id: int,
  name: String,
  height: int,
  weight: int,
  abilities: List<String>
  stats: List<String>

• Key: "favorites"
Value: List<String>. Favorites pokemons names.