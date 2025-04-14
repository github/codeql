const express = require('express')
const app = express()
const jwt_simple = require('jwt-simple');
const port = 3000

function getSecret() {
    return "A Safe generated random key"
}
app.get('/jwtSimple1', (req, res) => {
    const UserToken = req.headers.authorization;

    // no signature verification
    jwt_simple.decode(UserToken, getSecret(), true); // NOT OK
})

app.get('/jwtSimple2', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: all with with signature verification
    jwt_simple.decode(UserToken, getSecret(), false); // OK
    jwt_simple.decode(UserToken, getSecret()); // OK
})

app.get('/jwtSimple3', (req, res) => {
    const UserToken = req.headers.authorization;

    // GOOD: first without signature verification then with signature verification for same UserToken
    jwt_simple.decode(UserToken, getSecret(), true); // OK
    jwt_simple.decode(UserToken, getSecret()); // OK
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
