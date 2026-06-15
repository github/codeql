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

app.get('/jose1', async (req, res) => {
    const UserToken = req.headers.authorization;
    // GOOD: with signature verification
    await jose.jwtVerify(UserToken, new TextEncoder().encode(getSecret()))
})

app.get('/jose2', async (req, res) => {
    const UserToken = req.headers.authorization;
    // GOOD: first without signature verification then with signature verification for same UserToken
    jose.decodeJwt(UserToken)
    await jose.jwtVerify(UserToken, new TextEncoder().encode(getSecret()))
})

app.get('/jwtSimple1', (req, res) => {
    const UserToken = req.headers.authorization;
    // GOOD: first without signature verification then with signature verification for same UserToken
    jwt_simple.decode(UserToken, getSecret(), false);
    jwt_simple.decode(UserToken, getSecret());
})

app.get('/jwtSimple2', (req, res) => {
    const UserToken = req.headers.authorization;
    // GOOD: with signature verification
    jwt_simple.decode(UserToken, getSecret(), true);
    jwt_simple.decode(UserToken, getSecret());
})

app.get('/jwtJsonwebtoken1', (req, res) => {
    const UserToken = req.headers.authorization;
    // GOOD: with signature verification
    jwtJsonwebtoken.verify(UserToken, getSecret())
})

app.get('/jwtJsonwebtoken2', (req, res) => {
    const UserToken = req.headers.authorization;
    // GOOD: first without signature verification then with signature verification for same UserToken
    jwtJsonwebtoken.decode(UserToken)
    jwtJsonwebtoken.verify(UserToken, getSecret())
})


app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})