let nodemailer = require('nodemailer');
let config = require('./account-config');

function sendMessage() {
	let transporter = nodemailer.createTransport({
	    host: config.host,
	    port: config.host,
	    auth: config.auth
	});
	let mailOptions = {
	    from: 'sender@example.com',
	    to: 'receiver1@example.com, receiver2@example.com',
	    subject: 'Some subject',
	    text: 'Hi',
	    html: '<b>Hi</b>'
	};
	transporter.sendMail(mailOptions, (error, info) => {
	    console.log('Message sent');
	});
}
