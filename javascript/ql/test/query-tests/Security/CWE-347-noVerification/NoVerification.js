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
    jose.decodeJwt(UserToken)    // NOT OK: no signature verification

    startSymmetric(UserToken).then(result => console.log(result)) // OK: with signature verification


})


app.get('/jwtDecode', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-decode
    jwt_decode(UserToken) // NOT OK: no signature verification
})

app.get('/jwtSimple', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-simple
    // jwt.decode(token, key, noVerify, algorithm)
    jwt_simple.decode(UserToken, getSecret(), true); // NOT OK: no signature verification
})

app.get('/jwtSimple2', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-simple
    // jwt.decode(token, key, noVerify, algorithm)
    jwt_simple.decode(UserToken, getSecret(), false); // OK: with signature verification
    jwt_simple.decode(UserToken, getSecret()); // OK: with signature verification
})

app.get('/jwtSimple3', (req, res) => {
    const UserToken = req.headers.authorization;

    // jwt-simple
    // jwt.decode(token, key, noVerify, algorithm)
    jwt_simple.decode(UserToken, getSecret(), true); // OK: verify the signature of same token in next line
    jwt_simple.decode(UserToken, getSecret()); // OK
})

app.get('/jwtJsonwebtoken', (req, res) => {
    const UserToken = req.headers.authorization;

    jwtJsonwebtoken.decode(UserToken) // NOT OK: no signature verification 
    jwtJsonwebtoken.verify(UserToken, false, { algorithms: ["HS256", "none"] }) // NOT OK: no signature verification
})

app.get('/jwtJsonwebtoken2', (req, res) => {
    const UserToken = req.headers.authorization;

    jwtJsonwebtoken.verify(UserToken, getSecret()) // OK: with signature verification
})

app.get('/jwtJsonwebtoken3', (req, res) => {
    const UserToken = req.headers.authorization;

    jwtJsonwebtoken.decode(UserToken) // OK: verify the signature of same token in next line
    jwtJsonwebtoken.verify(UserToken, getSecret()) // OK
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
