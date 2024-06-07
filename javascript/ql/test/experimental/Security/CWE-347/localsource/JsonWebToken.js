const express = require('express')
const app = express()
const jwtJsonwebtoken = require('jsonwebtoken');
const jwt_decode = require('jwt-decode');
const jwt_simple = require('jwt-simple');
const jose = require('jose')
const port = 3000

function getSecret() {
    return "A Safe generated random key"
}

function aJWT() {
    return "A JWT provided by user"
}

(function () {
    const UserToken = aJwt()

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken) // NOT OK
})();

(function () {
    const UserToken = aJwt()

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken) // NOT OK
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256", "none"] }) // NOT OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: with signature verification
    jwtJsonwebtoken.verify(UserToken, getSecret())  // OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken)  // OK
    jwtJsonwebtoken.verify(UserToken, getSecret())  // OK
})();

(function () {
    const UserToken = aJwt()

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken) // OK
    jwtJsonwebtoken.verify(UserToken, getSecret(), { algorithms: ["HS256"] }) // OK
})();