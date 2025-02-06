let nodemailer = require('nodemailer');
let express = require('express');
let app = express();
let backend = require('./backend');

app.post('/private_message', (req, res) => {
  let transport = nodemailer.createTransport({});
  transport.sendMail({
    from: 'webmaster@example.com',
    to: backend.getUserEmail(req.query.receiver),
    subject: 'Private message',
    text: `Hi, you got a message from someone. ${req.query.message}.`,
    html: `Hi, you got a message from someone. ${req.query.message}.`, // $ Alert
  });
});
