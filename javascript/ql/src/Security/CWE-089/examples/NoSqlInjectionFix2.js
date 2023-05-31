const express = require("express");
const mongoose = require("mongoose");
const Todo = mongoose.model(
  "Todo",
  new mongoose.Schema({ text: { type: String } }, { timestamps: true })
);

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.delete("/api/delete", async (req, res) => {
  let id = req.body.id;
  if (typeof id !== "string") {
    res.status(400).json({ status: "error" });
    return;
  }
  await Todo.deleteOne({ _id: id }); // GOOD: id is guaranteed to be a string

  res.json({ status: "ok" });
});
