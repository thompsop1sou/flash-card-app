import express from "express";
import bodyParser from "body-parser";

import FlashcardSet from "./model.js";

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Open a flashcard set
app.post("/open", async (req, res) => {
  console.log(`Trying to open "${req.body.name}"`);
  // Try to find the set by name
  let foundSet = await FlashcardSet.findOne({name: req.body.name});
  // If the set was not found, indicate that to the client
  if (foundSet == null) {
    res.status(404).send(JSON.stringify(req.body));
    console.log("Failed to find.")
  // Otherwise, return the set to the client
  } else {
    let foundSetNoIds = {name: foundSet.name, cards: []};
    for (let i = 0; i < foundSet.cards.length; i++) {
      foundSetNoIds.cards.push({front: foundSet.cards[i].front, back: foundSet.cards[i].back});
    }
    res.status(200).send(JSON.stringify(foundSetNoIds));
    console.log("Succeeded!")
  }
});

// Save a flashcard set (may replace an existing one with the same name)
app.post("/save", async (req, res) => {
  console.log(`Trying to save "${req.body.name}"...`);
  // Try to find the set by name
  let foundSet = await FlashcardSet.findOne({name: req.body.name});
  // If the set was not found, create a new one
  if (foundSet == null) {
    FlashcardSet.create({name: req.body.name, cards: req.body.cards})
  // Otherwise, if the set was found, replace the existing set
  } else {
    foundSet.updateOne({name: req.body.name, cards: req.body.cards});
  }
  res.status(200).send(JSON.stringify(req.body));
  console.log("Succeeded!");
});

// Start the server
app.listen(port, () => {
  console.log(`Successfully started server on port ${port}.`);
});
