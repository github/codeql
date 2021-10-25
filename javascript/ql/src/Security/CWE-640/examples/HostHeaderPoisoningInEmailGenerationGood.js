let nodemailer = require('nodemailer');
let express = require('express');
let backend = require('./backend');

let app = express();

let config = JSON.parse(fs.readFileSync('config.json', 'utf8'));

app.post('/resetpass', (req, res) => {
  let email = req.query.email;
  let transport = nodemailer.createTransport(config.smtp);
  let token = backend.getUserSecretResetToken(email);
  transport.sendMail({
    from: 'webmaster@example.com',
    to: email,
    subject: 'Forgot password',
    text: `Click to reset password: https://${config.hostname}/resettoken/${token}`,
  });
});
