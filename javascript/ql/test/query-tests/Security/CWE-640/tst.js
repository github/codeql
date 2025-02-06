let nodemailer = require('nodemailer');
let express = require('express');
let app = express();
let backend = require('./backend');

app.post('/resetpass', (req, res) => {
  let email = req.query.email;

  let transport = nodemailer.createTransport({});

  let token = backend.getUserSecretResetToken(email);

  transport.sendMail({
    from: 'webmaster@example.com',
    to: email,
    subject: 'Forgot password',
    text: `Hi, looks like you forgot your password. Click here to reset: https://${req.host}/resettoken/${token}`, // $ Alert
    html: `Hi, looks like you forgot your password. Click <a href="https://${req.host}/resettoken/${token}">here</a> to reset.` // $ Alert
  });

  transport.sendMail({
    from: 'webmaster@example.com',
    to: email,
    subject: 'Forgot password',
    text: `Hi, looks like you forgot your password. Click here to reset: https://example.com/resettoken/${token}`,
    html: `Hi, looks like you forgot your password. Click <a href="https://example.com/resettoken/${token}">here</a> to reset.`
  });
});
