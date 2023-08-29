// jsonwebtoken
const jwtJsonwebtoken = require('jsonwebtoken');
const {getSecret} = require('./Config.js');
const payloads = {foo: 'bar'}
const token = jwtJsonwebtoken.sign(payloads, getSecret());
console.log(jwtJsonwebtoken.verify(token, getSecret()))

// jose
const jose = require('jose')

async function startSymmetric() {
    const {payload, protectedHeader} = await jose.jwtVerify(token, new TextEncoder().encode(getSecret()))
    return {
        payload, protectedHeader
    }
}

startSymmetric().then(result => console.log(result))

const alg = 'RS256'
const spki = `-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwhYOFK2Ocbbpb/zVypi9
SeKiNUqKQH0zTKN1+6fpCTu6ZalGI82s7XK3tan4dJt90ptUPKD2zvxqTzFNfx4H
HHsrYCf2+FMLn1VTJfQazA2BvJqAwcpW1bqRUEty8tS/Yv4hRvWfQPcc2Gc3+/fQ
OOW57zVy+rNoJc744kb30NjQxdGp03J2S3GLQu7oKtSDDPooQHD38PEMNnITf0pj
+KgDPjymkMGoJlO3aKppsjfbt/AH6GGdRghYRLOUwQU+h+ofWHR3lbYiKtXPn5dN
24kiHy61e3VAQ9/YAZlwXC/99GGtw/NpghFAuM4P1JDn0DppJldy3PGFC0GfBCZA
SwIDAQAB
-----END PUBLIC KEY-----`
const jwt2 =
    'eyJhbGciOiJSUzI1NiJ9.eyJ1cm46ZXhhbXBsZTpjbGFpbSI6dHJ1ZSwiaWF0IjoxNjY5MDU2NDg4LCJpc3MiOiJ1cm46ZXhhbXBsZTppc3N1ZXIiLCJhdWQiOiJ1cm46ZXhhbXBsZTphdWRpZW5jZSJ9.gXrPZ3yM_60dMXGE69dusbpzYASNA-XIOwsb5D5xYnSxyj6_D6OR_uR_1vqhUm4AxZxcrH1_-XJAve9HCw8az_QzHcN-nETt-v6stCsYrn6Bv1YOc-mSJRZ8ll57KVqLbCIbjKwerNX5r2_Qg2TwmJzQdRs-AQDhy-s_DlJd8ql6wR4n-kDZpar-pwIvz4fFIN0Fj57SXpAbLrV6Eo4Byzl0xFD8qEYEpBwjrMMfxCZXTlAVhAq6KCoGlDTwWuExps342-0UErEtyIqDnDGcrfNWiUsoo8j-29IpKd-w9-C388u-ChCxoHz--H8WmMSZzx3zTXsZ5lXLZ9IKfanDKg'

async function startRSA() {
    var publicKey = await jose.importSPKI(spki, alg)
    var {payload, protectedHeader} = await jose.jwtVerify(jwt2, publicKey, {
        issuer: 'urn:example:issuer',
        audience: 'urn:example:audience',
    })
    console.log(protectedHeader)
    console.log(payload)
}

startRSA()
// additional step
console.log("jose.base64url.decode()", Buffer.from(jose.base64url.decode(token), "base64").toString())

// jwt-simple
const jwt_simple = require('jwt-simple');
// var secret = Buffer.from('fe1a1915a379f3be5394b64d14794932', 'hex')
// decode
const decoded = jwt_simple.decode(token, getSecret() + "fj");
console.log("jwt_simple:", decoded); //=> { foo: 'bar' }
