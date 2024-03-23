import mongoose from "mongoose";

const port = 27017;

// Connect to the MongoDB server
mongoose.connect(
  `mongodb://localhost:${port}/flashcardsDB`
).then(() => {
  console.log(`Successfully connected to MongoDB on port ${port}.`);
}).catch((err) => {
  console.log(`Error connecting to MongoDB: ${err}`);
});

// Set up the schema for a single flashcard
const flashcardSchema = new mongoose.Schema({
  front: {
    type: String,
    required: true,
    default: ""
  },
  back: {
    type: String,
    required: true,
    default: ""
  }
});

// Set up the schema for a flashcard set
const flashcardSetSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    default: null
  },
  cards: {
    type: [flashcardSchema],
    required: true,
    default: []
  }
});

// Create and export a model for a flashcard set
const FlashcardSet = mongoose.model("FlashcardSet", flashcardSetSchema);
export default FlashcardSet;
