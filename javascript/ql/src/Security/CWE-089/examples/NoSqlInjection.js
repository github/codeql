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

  await Todo.deleteOne({ _id: id }); // BAD: id might be an object with special properties

  res.json({ status: "ok" });
});
