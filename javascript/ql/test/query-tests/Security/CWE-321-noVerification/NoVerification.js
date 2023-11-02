const express = require('express')
const app = express()
const jwtJsonwebtoken = require('jsonwebtoken');
const { getSecret } = require('./Config.js');
const jwt_decode = require('jwt-decode');
const jwt_simple = require('jwt-simple');
const jose = require('jose')
const port = 3000

async function startSymmetric(token) {
    const { payload, protectedHeader } = await jose.jwtVerify(token, new TextEncoder().encode(getSecret()))
    return {
        payload, protectedHeader
    }
}

app.get('/jose', (req, res) => {
    const UserToken = req.headers.authorization;

    // jose
    // BAD: no signature verification
    jose.decodeJwt(UserToken)
    // GOOD: with signature verification
    startSymmetric(UserToken).then(result => console.log(result))


})


app.get('/jwtDecode', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-decode
    // BAD: no signature verification
    jwt_decode(UserToken)
})

app.get('/jwtSimple', (req, res) => {
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
    // GOOD: first decode without signature verification and then verify the signature later
    jwt_simple.decode(UserToken, getSecret(), true);
    jwt_simple.decode(UserToken, getSecret());
})

app.get('/jwtJsonwebtoken', (req, res) => {
    const UserToken = req.headers.authorization;

    // BAD: no signature verification
    jwtJsonwebtoken.decode(UserToken)
    jwtJsonwebtoken.verify(UserToken, false, { algorithms: ["HS256", "none"] })
})

app.get('/jwtJsonwebtoken2', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: with signature verification
    jwtJsonwebtoken.verify(UserToken, getSecret())
})

app.get('/jwtJsonwebtoken3', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: first decode without signature verification and then verify the signature later
    jwtJsonwebtoken.decode(UserToken)
    jwtJsonwebtoken.verify(UserToken, getSecret())
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
