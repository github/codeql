app.delete("/api/delete", async (req, res) => {
  let id = req.body.id;
  await Todo.deleteOne({ _id: { $eq: id } }); // GOOD: using $eq operator for the comparison

  res.json({ status: "ok" });
});