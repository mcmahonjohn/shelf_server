# shelf_server

A ready to use server for any web content.

## Getting Started

### Dart
* [Install Dart](https://www.dartlang.org/install/archive)  >= 2.14.0
* Add the Dart SDK to your path.
* From a new command window, type `dart --version` to verify that Dart is now available.

### Dart Plugin for your IDE
* If you are using IntelliJ, [install and configure the Dart plugin](https://www.dartlang.org/tools/jetbrains-plugin).

### Setting up Dart on your IDE
* Set up the Dart SDK and Dartium by going in your IDE's settings and add the Dart SDK
* Note: For HomeBrew Mac users the Dart SDK and Dartium locations are:
  * SDK directory: `HOMEBREW_INSTALL/dart/2.14.0/libexec`

## Using shelf_server

To use shelf_server from anywhere, use Dart to make it globally available.

From the root directory of this project run:
`dart pub global activate --source path . --executable ./bin/server.dart`

Then execute the app using `dart pub global run`:

`dart pub global run shelf_server`

## Options

Currently, there's only one option:

**--port | -p**: Defines what port number to use when serving the web content.
`dart pub global run shelf_server --port 8082`

By default, shelf_server uses 127.0.0.1 (localhost) and port 8082