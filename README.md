# Flash Card App

A 3D flash card app. The front end is built in Godot and the back end is built using Node, Express, and MongoDB.

## Description

This app allows you to scroll through a set of flash cards in a 3D interface. You can load or save flashcards to the back-end server using two buttons on the left side of the interface. You can upload or download flashcard sets to your device (as JSON files) using two buttons on the right side of the interface.

To see this in action, visit the front-end app at https://thompsop1sou.github.io/flash-cards/.

> **Note:** The back end is not currently hosted anywhere, so this front end is limited in its functionality. In particular, the buttons to load or save to the back-end server do not work.

## How to Run (Locally)

1. Get the following software:
   * Download and install Node and npm (to run the back end).
      * Node version 21.6 or later
      * npm version 10.2 or later
      * Visit https://docs.npmjs.com/downloading-and-installing-node-js-and-npm to learn how to install
   * Download Godot (to run the front end).
      * Version 4.2 or later
      * Visit https://godotengine.org/download/ to download
      * Note that Godot is a standalone executable and does not need to be installed

> **Note:** Instead of downloading Godot to run the front end, you should also be able to clone the `export` branch of this repo and run that on a local server that you already have set up.

2. Clone (or download) the repo to your machine.

3. Install back-end dependencies using npm.
   * Open a terminal window to the `back-end` folder.
   * Run `npm install`.

4. Start the back end.
   * Open a terminal window to the `back-end` folder.
   * Run `node index.js` (or `nodemon index.js` if preferred).

5. Start the front end.
   * Run the Godot executable.
   * From the Project Manager window, import the front-end project.
      * You should be able to navigate to the `front-end` folder and click "Import and Edit"
   * With the project open, click the run button in the top right (or press `F5`).
