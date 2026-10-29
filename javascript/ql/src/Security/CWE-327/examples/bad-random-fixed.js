const cryptoRandomString = require('crypto-random-string');

const digits = cryptoRandomString({length: 10, type: 'numeric'});