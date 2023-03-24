const express = require('express')

const router = module.exports.router = express.Router();

function serializeNote(note) {
  return {
    title: note.title,
    body: note.body
  };
}

router.post('/find', async (req, res) => {
  const notes = await Note.find({
    ownerToken: req.body.token
  }).exec();
  res.json({
    notes: notes.map(serializeNote)
  });
});

router.get('/findPublic', async (_req, res) => {
  const notes = await Note.find({
    isPublic: true
  }).exec();
  res.json({
    notes: notes.map(serializeNote)
  });
});

router.post('/findVisible', async (req, res) => {
  const notes = await Note.find({
    $or: [
      {
        isPublic: true
      },
      {
        ownerToken: req.body.token
      }
    ]
  }).exec();
  res.json({
    notes: notes.map(serializeNote)
  });
});
