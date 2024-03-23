import express from "express";
import bodyParser from "body-parser";

const app = express();
const port = 3000;
const server_key = process.env["FLASHCARD_SERVER_KEY"];

app.use(bodyParser.json());

// Open a named flashcard set
app.post("/open", (req, res) => {
  console.log(req.body);
  console.log(`Trying to open "${req.body.name}"`);
  res.status(200).send("Success!");
});

// Save a named flashcard set (may replace an existing one with the same name)
app.post("/save", (req, res) => {
  console.log(req.body);
  console.log(`Trying to save "${req.body.name}"`);
  res.status(200).send("Success!");
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