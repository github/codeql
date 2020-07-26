const express = require('express')
var bodyParser = require('body-parser');
const crypto = require('crypto');
const { request } = require('http');
const { response } = require('express');
const app = express()
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const port = 5061
const key = crypto.randomBytes(32);

function encrypt(text) {
    let cipher;
    let trueRandomIv = crypto.randomBytes(16);
    cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(key), trueRandomIv);
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return { iv: trueRandomIv.toString('hex'), encryptedData: encrypted.toString('hex') };
}
   
function decrypt(ciphertext , ct_iv) {
    let iv = Buffer.from(ct_iv, 'hex');
    let encryptedText = Buffer.from(ciphertext, 'hex');
    let decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(key), iv);
    let decrypted = decipher.update(encryptedText);
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
}

app.post('/decrypt', (request, response) => {
    var ciphertext = request.param("ct", "");
    var iv = request.param("iv", "");
    response.send("Decryption " + decrypt(ciphertext, iv));
})

app.post('/encrypt', (request, response) => {
    var plaintext = request.param("pt", "");
    var cp = encrypt(plaintext);
    response.send("Encrypted  " + plaintext + " = " + cp.encryptedData + "|"+ cp.iv);
})

app.listen(port, (err) => {
if (err) {
    return console.log('something bad happened', err)
}

console.log(`server is listening on ${port}`)
})