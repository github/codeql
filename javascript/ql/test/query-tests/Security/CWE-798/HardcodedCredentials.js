(function() {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser',  // $ Alert
        host: 'database.server.com',
        database: 'mydb',
        password: 'hgfedcba',  // $ Alert
        port: 3211,
    });
    client.connect();
})();

(function() {
    require("http").request({auth: "user:hgfedcba"});   // $ MISSING: Alert
    require("https").request({auth: "user:hgfedcba"});  // $ MISSING: Alert
    function getCredentials() {
        return "user:hgfedcba";
    }
    require("http").request({auth: getCredentials()}); // $ MISSING: Alert
    require("http").request({auth: getUnknownCredentials()});
})();

(function() {
    var basicAuth = require('express-basic-auth');

    basicAuth({users: { 'admin': 'hgfedcba' }});  // $ Alert
    var users = {};
    users['unknown-admin-name'] = 'hgfedcba'; // $ Alert
    basicAuth({users: users});
})();

(function() {
    var basicAuth = require('basic-auth-connect');
    basicAuth('username', 'hgfedcba'); // $ Alert
    basicAuth(function(){});
})();

(function() {
    var AWS = require('aws-sdk');
    AWS.config.update({ accessKeyId: 'username', secretAccessKey: 'hgfedcba'}); // $ Alert
    new AWS.Config({ accessKeyId: 'username', secretAccessKey: 'hgfedcba'}); // $ Alert
    var config = new AWS.Config();
    config.update({ accessKeyId: 'username', secretAccessKey: 'hgfedcba'}); // $ Alert
    var o = {};
    o.secretAccessKey = 'hgfedcba'; // $ Alert
    config.update(o);
})();

(function() {
    var request = require('request');

    request.get(url).auth('username', 'hgfedcba'); // $ Alert
    request.get(url, {
        'auth': {
            'user': 'username', // $ Alert
            'pass': 'hgfedcba' // $ Alert
        }
    });

    request.get(url).auth(null, null, _, 'bearerToken'); // $ Alert

    request.get(url, {
        'auth': {
            'bearer': 'bearerToken' // $ Alert
        }
    });

    request.post(url).auth('username', 'hgfedcba'); // $ Alert
    request.head(url).auth('username', 'hgfedcba'); // $ Alert

    request(url).auth('username', 'hgfedcba'); // $ Alert
    request(url, {
        'auth': {
            'user': 'username', // $ Alert
            'pass': 'hgfedcba' // $ Alert
        }
    });
})();

(function() {
    const MsRest = require('ms-rest-azure');

    MsRest.loginWithUsernamePassword('username', 'hgfedcba', function(){}); // $ Alert
    MsRest.loginWithUsernamePassword(process.env.AZURE_USER, process.env.AZURE_PASS, function(){});
    MsRest.loginWithServicePrincipalSecret('username', 'hgfedcba', function(){}); // $ Alert
})();

(function() {
    var digitalocean = require('digitalocean');
    digitalocean.client('TOKEN'); // $ Alert
    digitalocean.client(process.env.DIGITAL_OCEAN_TOKEN);
})();

(function() {
    var pkgcloud = require('pkgcloud');
    pkgcloud.compute.createClient({
        account: 'x1', // $ Alert
        keyId: 'x2',// $ Alert
        storageAccount: 'x3', // $ Alert
        username: 'x4', // $ Alert
        key: 'hgfedcba', // $ Alert
        apiKey: 'hgfedcba', // $ Alert
        storageAccessKey: 'hgfedcba', // $ Alert
        password: 'hgfedcba', // $ Alert
        token: 'hgfedcba' // $ Alert
    });
    pkgcloud.compute.createClient({
        INNOCENT_DATA: '42'
    });
    pkgcloud.providers.SOME_PROVIDER.compute.createClient({
        username: 'x5', // $ Alert
        password: 'hgfedcba' // $ Alert
    });
    pkgcloud.UNKNOWN_SERVICE.createClient({
        username: 'x6',
        password: 'hgfedcba'
    });
    pkgcloud.providers.SOME_PROVIDER.UNKNOWN_SERVICE.createClient({
        username: 'x7',
        password: 'hgfedcba'
    });
    pkgcloud.compute.createClient({
        username: process.env.USERNAME,
        password: process.env.PASSWORD
    });
})();

(function(){
    require('crypto').createHmac('sha256', 'hgfedcba'); // $ Alert
    require("crypto-js/aes").encrypt('my message', 'hgfedcba'); // $ Alert
})()

(function(){
    require("cookie-session")({ secret: "hgfedcba" }); // $ Alert
})()

(function(){
    var request = require('request');
    request.get(url, {
        'auth': {
            'user': '',
            'pass': process.env.PASSWORD
        }
    });
})();

(function(){
    var request = require('request');
    let pass = getPassword() || '';
    request.get(url, {
        'auth': {
            'user': process.env.USER || '',
            'pass': pass,
        }
    });
})();

(function(){
	require("cookie-session")({ secret: "oiuneawrgiyubaegr" }); // $ Alert
	require('crypto').createHmac('sha256', 'oiuneawrgiyubaegr'); // $ Alert

	var basicAuth = require('express-basic-auth');
	basicAuth({users: { [adminName]: 'change_me' }});
})();

(async function () {
    const base64 = require('base-64');
    const fetch = require("node-fetch");

    const USER = 'sdsdag'; // $ Alert
    const PASS = 'sdsdag'; // $ Alert
    const AUTH = base64.encode(`${USER}:${PASS}`);

    const rsp = await fetch(ENDPOINT, {
        method: 'get',
        headers: new fetch.Headers({
            "Authorization": `Basic ${AUTH}`, // $ Sink
            "Content-Type": 'application/json'
        })
    });

    fetch(ENDPOINT, {
        method: 'post',
        body: JSON.stringify(body),
        headers: {
            "Content-Type": 'application/json',
            "Authorization": `Basic ${AUTH}` // $ Sink
        },
    })

    var headers = new fetch.Headers({
        "Content-Type": 'application/json'
    });
    headers.append("Authorization", `Basic ${AUTH}`) // $ Sink
    fetch(ENDPOINT, {
        method: 'get',
        headers: headers
    });

    var headers2 = new fetch.Headers({
        "Content-Type": 'application/json'
    });
    headers2.set("Authorization", `Basic ${AUTH}`) // $ Sink
    fetch(ENDPOINT, {
        method: 'get',
        headers: headers2
    });
});

(function () {
    const base64 = require('base-64');

    const USER = 'sdsdag'; // $ Alert
    const PASS = 'sdsdag'; // $ Alert
    const AUTH = base64.encode(`${USER}:${PASS}`);

    // browser API
    var headers = new Headers();
    headers.append("Content-Type", 'application/json');
    headers.append("Authorization", `Basic ${AUTH}`); // $ Sink
    fetch(ENDPOINT, {
        method: 'get',
        headers: headers
    });
});

(async function () {
    import fetch from 'node-fetch';

    const username = 'sdsdag'; // $ Alert
    const password = config.get('some_actually_secrect_password');
    const response = await fetch(ENDPOINT, {
      method: 'get',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Basic ' + Buffer.from(username + ':' + password).toString('base64'), // $ Sink
      },
    });
})

(function () {
    import jwt from "jsonwebtoken";

    var privateKey = "myHardCodedPrivateKey"; // $ Alert
    var token = jwt.sign({ foo: 'bar' }, privateKey, { algorithm: 'RS256'}); // $ Sink

    var publicKey = "myHardCodedPublicKey"; // $ Alert
    jwt.verify(token, publicKey, function(err, decoded) { // $ Sink
        console.log(decoded);
    });
})();

(async function () {
    const fetch = require("node-fetch");

    const rsp = await fetch(ENDPOINT, {
        method: 'get',
        headers: new fetch.Headers({
            "Authorization": `Basic foo`, // OK - dummy password
            "Content-Type": 'application/json'
        })
    });

    const rsp2 = await fetch(ENDPOINT, {
        method: 'get',
        headers: new fetch.Headers({
            "Authorization": `${foo ? 'Bearer' : 'OAuth'} ${accessToken}`, // OK - just a protocol selector
            "Content-Type": 'application/json'
        })
    });
});

(function() {
    require("http").request({auth: "user:{{ INSERT_HERE }}"});
    require("http").request({auth: "user:token {{ INSERT_HERE }}"});
    require("http").request({auth: "user:( INSERT_HERE )"});
    require("http").request({auth: "user:{{ env.access_token }}"});
    require("http").request({auth: "user:abcdefgh"});
    require("http").request({auth: "user:12345678"});
    require("http").request({auth: "user:foo"});
    require("http").request({auth: "user:mypassword"})
    require("http").request({auth: "user:mytoken"})
    require("http").request({auth: "user:fake token"})
    require("http").request({auth: "user:dcba"})
    require("http").request({auth: "user:custom string"})
});

(function () {
    // browser API
    var headers = new Headers();
    headers.append("Authorization", `Basic sdsdag:sdsdag`); // $ Alert
    headers.append("Authorization", `Basic sdsdag:xxxxxxxxxxxxxx`);
    headers.append("Authorization", `Basic sdsdag:aaaiuogrweuibgbbbbb`); // $ Alert
    headers.append("Authorization", `Basic sdsdag:000000000000001`);
});

(function () {
    require('crypto').createHmac('sha256', 'mytoken');
    require('crypto').createHmac('sha256', 'SampleToken');
    require('crypto').createHmac('sha256', 'MyPassword');
    require('crypto').createHmac('sha256', 'iubfewiaaweiybgaeuybgera'); // $ Alert
})();

(function () {
    const jwt_simple = require("jwt-simple");

    var privateKey = "myHardCodedPrivateKey"; // $ Alert
    jwt_simple.decode(UserToken, privateKey); // $ Sink
})();


(async function () {
    const jose = require("jose");

    var privateKey = "myHardCodedPrivateKey"; // $ Alert
    jose.jwtVerify(token, new TextEncoder().encode(privateKey)) // $ Sink

    const spki = `-----BEGIN PUBLIC KEY-----
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwhYOFK2Ocbbpb/zVypi9...
    -----END PUBLIC KEY-----` // $ Alert
    let publicKey = await jose.importSPKI(spki, 'RS256')
    jose.jwtVerify(token, publicKey) // $ Sink

    const alg = 'RS256'
    const jwk = {
        kty: 'RSA',
        n: 'whYOFK2Ocbbpb_zVypi9SeKiNUqKQH0zTKN1-6f...', // $ Alert
        e: 'AQAB',
    }
    publicKey = await jose.importJWK(jwk, alg)
    const jwt =
        'eyJhbGciOiJSUzI1NiJ9.eyJ1cm46ZXhhbXBsZTpjbGFpbSI6dHJ1ZSwiaWF0IjoxNjY5MDU2NDg4LCJpc3MiOiJ1cm46ZXhhbXBsZTppc3N1ZXIiLCJhdWQiOiJ1cm46ZXhhbXBsZTphdWRpZW5jZSJ9.gXrPZ3yM_60dMXGE69dusbpzYASNA-XIOwsb5D5xYnSxyj6_D6OR_uR_1vqhUm4AxZxcrH1_-XJAve9HCw8az_QzHcN-nETt-v6stCsYrn6Bv1YOc-mSJRZ8ll57KVqLbCIbjKwerNX5r2_Qg2TwmJzQdRs-AQDhy-s_DlJd8ql6wR4n-kDZpar-pwIvz4fFIN0Fj57SXpAbLrV6Eo4Byzl0xFD8qEYEpBwjrMMfxCZXTlAVhAq6KCoGlDTwWuExps342-0UErEtyIqDnDGcrfNWiUsoo8j-29IpKd-w9-C388u-ChCxoHz--H8WmMSZzx3zTXsZ5lXLZ9IKfanDKg'

    await jose.jwtVerify(jwt, publicKey, { // $ Sink
        issuer: 'urn:example:issuer',
        audience: 'urn:example:audience',
    })
})();

(function () {
    const expressjwt = require("express-jwt");

    var secretKey = "myHardCodedPrivateKey"; // $ Alert

    app.get(
        "/protected",
        expressjwt.expressjwt({
            secret: secretKey, algorithms: ["HS256"] // $ Sink
        }),
        function (req, res) {
            if (!req.auth.admin) return res.sendStatus(401);
            res.sendStatus(200);
        }
    );

    app.get(
        "/protected",
        expressjwt.expressjwt({
            secret: Buffer.from(secretKey, "base64"), // $ Sink
            algorithms: ["RS256"],
        }),
        function (req, res) {
            if (!req.auth.admin) return res.sendStatus(401);
            res.sendStatus(200);
        }
    );

})();

(function () {
    const JwtStrategy = require('passport-jwt').Strategy;
    const passport = require('passport')

    var secretKey = "myHardCodedPrivateKey"; // $ Alert

    const opts = {}
    opts.secretOrKey = secretKey; // $ Sink
    passport.use(new JwtStrategy(opts, function (jwt_payload, done) {
        return done(null, false);
    }));

    passport.use(new JwtStrategy({
        secretOrKeyProvider: function (request, rawJwtToken, done) {
            return done(null, secretKey) // $ Sink
        }
    }, function (jwt_payload, done) {
        return done(null, false);
    }));
})();

(function () {
    import NextAuth from "next-auth"
    import AppleProvider from "next-auth/providers/apple"

    var secretKey = "myHardCodedPrivateKey"; // $ Alert

    NextAuth({
        secret: secretKey, // $ Sink
        providers: [
            AppleProvider({
                clientId: process.env.APPLE_ID,
                clientSecret: process.env.APPLE_SECRET,
            }),
        ],
    })
})();

(function () {
    const Koa = require('koa');
    const jwt = require('koa-jwt');
    const app = new Koa();

    var secretKey = "myHardCodedPrivateKey"; // $ Alert

    app.use(jwt({ secret: secretKey })); // $ Sink
})();
