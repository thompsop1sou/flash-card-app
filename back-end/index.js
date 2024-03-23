import express from "express";
import bodyParser from "body-parser";

const app = express();
const port = 3000;
const server_key = process.env["FLASHCARD_SERVER_KEY"];

app.use(bodyParser.urlencoded({ extended: true }));

// Open a named flashcard set
app.post("/open", (req, res) => {
  let set_name = req.query.name;
  console.log(`Trying to open ${set_name}`);
  res.status(200);
});

// Save a named flashcard set (may replace an existing one with the same name)
app.post("/save", (req, res) => {
  let set_name = req.query.name;
  console.log(`Trying to save ${set_name}`);
  res.status(200);
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