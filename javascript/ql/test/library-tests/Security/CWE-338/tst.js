Math.random();
var random = Math.random;
random();

var rn = require('random-number');
rn();

var randomInt = require('random-int');
randomInt(5);

var randomFloat = require('random-float');
randomFloat(5);

var randomSeed = require('random-seed').create();
randomSeed();

var uniqueRandom = require('unique-random')(1, 10);
uniqueRandom();

var Chance = require('chance'),
    chance = new Chance();
chance.XYZ();

let crypto = require('crypto');
crypto.pseudoRandomBytes(100);
new crypto.pseudoRandomBytes(100);
