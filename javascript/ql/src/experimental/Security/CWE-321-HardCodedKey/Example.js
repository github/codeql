const express = require('express')
const jwtJsonwebtoken = require("jsonwebtoken");
const jose = require("jose");
const jwt_simple = require("jwt-simple");
const app = express()
const port = 3000

function getSecret() {
    return "secret"
}

async function startSymmetric(token) {
    const {payload, protectedHeader} = await jose.jwtVerify(token, new TextEncoder().encode(getSecret()))
    return {
        payload, protectedHeader
    }
}

async function startRSA(token) {
    const spki = `-----BEGIN PUBLIC KEY-----
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwhYOFK2Ocbbpb/zVypi9
    SeKiNUqKQH0zTKN1+6fpCTu6ZalGI82s7XK3tan4dJt90ptUPKD2zvxqTzFNfx4H
    HHsrYCf2+FMLn1VTJfQazA2BvJqAwcpW1bqRUEty8tS/Yv4hRvWfQPcc2Gc3+/fQ
    OOW57zVy+rNoJc744kb30NjQxdGp03J2S3GLQu7oKtSDDPooQHD38PEMNnITf0pj
    +KgDPjymkMGoJlO3aKppsjfbt/AH6GGdRghYRLOUwQU+h+ofWHR3lbYiKtXPn5dN
    24kiHy61e3VAQ9/YAZlwXC/99GGtw/NpghFAuM4P1JDn0DppJldy3PGFC0GfBCZA
    SwIDAQAB
    -----END PUBLIC KEY-----`
    const publicKey = await jose.importSPKI(spki, 'RS256')
    const {payload, protectedHeader} = await jose.jwtVerify(token, publicKey, {
        issuer: 'urn:example:issuer',
        audience: 'urn:example:audience',
    })
    console.log(protectedHeader)
    console.log(payload)
}

app.get('/', (req, res) => {
    const UserToken = req.headers.authorization;
    startSymmetric(UserToken).then()
    startRSA(UserToken).then()
    jwt_simple.decode(UserToken, getSecret());
    jwtJsonwebtoken.verify(UserToken, getSecret())
    res.send('Hello World!')
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
