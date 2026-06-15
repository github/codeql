app.delete("/api/delete", async (req, res) => {
  let id = req.body.id;
  if (typeof id !== "string") {
    res.status(400).json({ status: "error" });
    return;
  }
  await Todo.deleteOne({ _id: id }); // GOOD: id is guaranteed to be a string

  res.json({ status: "ok" });
});
