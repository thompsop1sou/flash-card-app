# Flash Card App

A 3D flash card app. The front end is built in Godot and the back end is built using Node, Express, and MongoDB.

## Description

This app allows you to scroll through a set of flash cards in a 3D interface. You can load or save flashcards to the back-end server using two buttons on the left side of the interface. You can upload or download flashcard sets to your device (as JSON files) using two buttons on the right side of the interface.

To see this in action, visit the front-end app at https://thompsop1sou.github.io/flash-card-app/.

> **Note:** The back end is not currently hosted anywhere, so this front end is limited in its functionality. In particular, the buttons to load or save to the back-end server do not work.

## How to Run (Locally)

1. Get the following software:
   * Download and install MongoDB Community Edition (to run the back-end database).
      * Version 7.0 or later
      * Visit https://www.mongodb.com/docs/manual/administration/install-community/ to learn how to install
   * Download and install Node and npm (to run the back-end server).
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

4. Start the MongoDB instance.
   * This may have happened automatically when installing MongoDB Community Edition. If not, read the details on https://www.mongodb.com/docs/manual/administration/install-community/ to learn how to start the instance on your operating system.

5. Start the back-end server.
   * Open a terminal window to the `back-end` folder.
   * Run `node index.js` (or `nodemon index.js` if preferred).

6. Start the front end.
   * Run the Godot executable.
   * From the Project Manager window, import the front-end project.
      * You should be able to navigate to the `front-end` folder and click "Import and Edit"
   * With the project open, click the run button in the top right (or press `F5`).

## How It Works

### Back End

The back end follows the typical structure of a MERN stack (minus the "R"):
* In `model.js`, the MongoDB database is initialized using the Mongoose package. It just has a single model, `FlashcardSet`, which is composed of two schemas: `flashcardSetSchema` for the main document and `flashcardSchema` for the subdocuments that are contained therein.
* In `index.js`, Node and Express are used to handle incoming HTTP requests. Based on the endpoint of the request and its contents, some sort of call is made to the database, and the corresponding data is sent back to the front end.

### Front End

The front end makes use of Godot's 3D capabilities along with its node system and scene tree. I would suggest seeing the official docs for an introduction to these concepts: https://docs.godotengine.org/en/stable/getting_started/introduction/key_concepts_overview.html.

In summary, `table.tscn` is the "main" scene for this project, which means that it is the first scene that is loaded up by the project. In this scene, there is a table-top surface and a row of buttons along the bottom of the surface. The scene also contains three spots where flashcards can be placed called `DrawStack`, `CenterCardSpot`, and `DiscardStack`.

In addition, `table.tscn` has a script called `table.gd` attached to it. When the project is started up, the `_ready()` method of `table.gd` is run automatically. For now, this method just adds 10 placeholder cards to the `DrawStack`.

After that, the `table.gd` script waits for the user to press one of the buttons along the bottom of the scene. When a button is pressed, one of the following methods will be called in response:
* `_on_open_pressed()`
   * Called when the "open" button is pressed (the cloud with the downward facing arrow).
   * Makes a request to the back end to open a flaschard set with some user-defined name.
* `_on_save_pressed()`
   * Called when the "save" button is pressed (the cloud with the upward facing arrow).
   * Makes a request to the back end to save the current flaschard set with some user-defined name.
* `_on_left_arrow_pressed()`
   * Called when the left arrow is pressed.
   * Moves the displayed flashcards one step to the left.
* `_on_loop_pressed()`
   * Called when the "loop" button is pressed.
   * Resets the displayed flashcards, moving them all back to the draw stack.
* `_on_right_arrow_pressed()`
   * Called when the right arrow is pressed.
   * Moves the displayed flashcards one step to the right.
* `_on_download_pressed()`
   * Called when the "download" button is pressed (the box with the downward facing arrow).
   * Prompts the user to download the current flashcard set as JSON to their device.
* `_on_upload_pressed()`
   * Called when the "upload" button is pressed (the box with the upward facing arrow).
   * Prompts the user to upload a flashcard set as JSON from the their device.
