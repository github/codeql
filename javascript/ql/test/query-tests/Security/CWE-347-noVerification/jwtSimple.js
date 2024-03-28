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
app.get('/jwtSimple1', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-simple
    // jwt.decode(token, key, noVerify, algorithm)
    // BAD: no signature verification
    jwt_simple.decode(UserToken, getSecret(), true);
})

app.get('/jwtSimple2', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-simple
    // jwt.decode(token, key, noVerify, algorithm)
    // GOOD: with signature verification
    jwt_simple.decode(UserToken, getSecret(), false);
    jwt_simple.decode(UserToken, getSecret());
})

app.get('/jwtSimple3', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-simple
    // jwt.decode(token, key, noVerify, algorithm)
    // GOOD: first without signature verification then with signature verification for same UserToken
    jwt_simple.decode(UserToken, getSecret(), true);
    jwt_simple.decode(UserToken, getSecret());
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
