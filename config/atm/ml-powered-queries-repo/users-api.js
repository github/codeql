const express = require('express')

Logger = require('./logger').Logger;
const router = module.exports.router = express.Router();

router.post('/updateName', async (req, res) => {
  Logger.log("/updateName called with new name", req.body.name);
  await User.findOneAndUpdate({
    token: req.body.token
  }, {
    name: req.body.name
  }).exec();
  res.json({
    name: req.body.name
  });
});

router.post('/getName', async (req, res) => {
  const user = await User.findOne({
    token: req.body.token
  }).exec();
  res.json({
    name: user.name
  });
});
