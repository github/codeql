const express = require('express')
const app = express()
const jwtJsonwebtoken = require('jsonwebtoken');
const {getSecret} = require('./Config.js');
const jwt_decode = require('jwt-decode');
const jwt_simple = require('jwt-simple');
const jose = require('jose')
const port = 3000

async function startSymmetric(token) {
    const {payload, protectedHeader} = await jose.jwtVerify(token, new TextEncoder().encode(getSecret()))
    return {
        payload, protectedHeader
    }
}

app.get('/', (req, res) => {
    const UserToken = req.headers.authorization;
    // BAD: no verification
    jwtJsonwebtoken.decode(UserToken)
    // GOOD: use verify alone or use as a check,
    // sometimes it seems some coders use both for same token
    const UserToken2 = req.headers.authorization;
    jwtJsonwebtoken.decode(UserToken2)
    jwtJsonwebtoken.verify(UserToken2, getSecret())
    // jwt-decode
    // BAD: no verification
    jwt_decode(UserToken)
    // jose
    // BAD: no verification
    jose.decodeJwt(UserToken)
    // GOOD
    startSymmetric(UserToken).then(result => console.log(result))
    // jwt-simple
    // no verification
    jwt_simple.decode(UserToken, getSecret(), true);
    // GOOD
    jwt_simple.decode(UserToken, getSecret(), false);
    jwt_simple.decode(UserToken, getSecret());
    res.send('Hello World!')
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
