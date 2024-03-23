import express from "express";
import bodyParser from "body-parser";

const app = express();
const port = 3000;
const server_key = process.env["FLASHCARD_SERVER_KEY"];

app.use(bodyParser.json());

// Open a flashcard set
app.post("/open", (req, res) => {
  console.log(`Trying to open "${req.body.name}"`);
  let foundIndex = flashcard_sets.findIndex((value, index, array) => value.name === req.body.name);
  if (foundIndex === -1) {
    res.status(404).send(JSON.stringify(req.body));
    console.log(JSON.stringify(req.body));
  } else {
    res.status(200).send(JSON.stringify(flashcard_sets[foundIndex]));
  }
});

// Save a flashcard set (may replace an existing one with the same name)
app.post("/save", (req, res) => {
  console.log(req.body);
  console.log(`Trying to save "${req.body.name}"`);
  let foundIndex = flashcard_sets.findIndex((value, index, array) => value.name === req.body.name);
  if (foundIndex === -1) {
    flashcard_sets.push(req.body);
  } else {
    flashcard_sets[foundIndex] = req.body;
  }
  res.status(200).send(JSON.stringify(req.body));
});

app.listen(port, () => {
  console.log(`Successfully started server on port ${port}.`);
});

let flashcard_sets = [
  {
    name: "Greetings",
    cards: [
      {back: "Goodbye", front: "Hello"}
    ]
  }
]