(function() {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser',  // NOT OK
        host: 'database.server.com',
        database: 'mydb',
        password: 'hgfedcba',  // NOT OK
        port: 3211,
    });
    client.connect();
})();

(function() {
    require("http").request({auth: "user:hgfedcba"});  // NOT OK
    require("https").request({auth: "user:hgfedcba"}); // NOT OK
    function getCredentials() {
        return "user:hgfedcba";
    }
    require("http").request({auth: getCredentials()}); // NOT OK
    require("http").request({auth: getUnknownCredentials()}); // OK
})();

(function() {
    var basicAuth = require('express-basic-auth');

    basicAuth({users: { 'admin': 'hgfedcba' }});  // NOT OK
    var users = {};
    users['unknown-admin-name'] = 'hgfedcba'; // NOT OK
    basicAuth({users: users});
})();

(function() {
    var basicAuth = require('basic-auth-connect');
    basicAuth('username', 'hgfedcba'); // NOT OK
    basicAuth(function(){}); // OK
})();

(function() {
    var AWS = require('aws-sdk');
    AWS.config.update({ accessKeyId: 'username', secretAccessKey: 'hgfedcba'}); // NOT OK
    new AWS.Config({ accessKeyId: 'username', secretAccessKey: 'hgfedcba'}); // NOT OK
    var config = new AWS.Config();
    config.update({ accessKeyId: 'username', secretAccessKey: 'hgfedcba'}); // NOT OK
    var o = {};
    o.secretAccessKey = 'hgfedcba'; // NOT OK
    config.update(o);
})();

(function() {
    var request = require('request');

    request.get(url).auth('username', 'hgfedcba'); // NOT OK
    request.get(url, {
        'auth': {
            'user': 'username', // NOT OK
            'pass': 'hgfedcba' // NOT OK
        }
    });

    request.get(url).auth(null, null, _, 'bearerToken'); // NOT OK

    request.get(url, {
        'auth': {
            'bearer': 'bearerToken' // NOT OK
        }
    });

    request.post(url).auth('username', 'hgfedcba'); // NOT OK
    request.head(url).auth('username', 'hgfedcba'); // NOT OK

    request(url).auth('username', 'hgfedcba'); // NOT OK
    request(url, {
        'auth': {
            'user': 'username', // NOT OK
            'pass': 'hgfedcba' // NOT OK
        }
    });
})();

(function() {
    const MsRest = require('ms-rest-azure');

    MsRest.loginWithUsernamePassword('username', 'hgfedcba', function(){}); // NOT OK
    MsRest.loginWithUsernamePassword(process.env.AZURE_USER, process.env.AZURE_PASS, function(){}); // OK
    MsRest.loginWithServicePrincipalSecret('username', 'hgfedcba', function(){}); // NOT OK
})();

(function() {
    var digitalocean = require('digitalocean');
    digitalocean.client('TOKEN'); // NOT OK
    digitalocean.client(process.env.DIGITAL_OCEAN_TOKEN); // OK
})();

(function() {
    var pkgcloud = require('pkgcloud');
    pkgcloud.compute.createClient({
        account: 'x1', // NOT OK
        keyId: 'x2',// NOT OK
        storageAccount: 'x3', // NOT OK
        username: 'x4', // NOT OK
        key: 'hgfedcba', // NOT OK
        apiKey: 'hgfedcba', // NOT OK
        storageAccessKey: 'hgfedcba', // NOT OK
        password: 'hgfedcba', // NOT OK
        token: 'hgfedcba' // NOT OK
    });
    pkgcloud.compute.createClient({ // OK
        INNOCENT_DATA: '42'
    });
    pkgcloud.providers.SOME_PROVIDER.compute.createClient({
        username: 'x5', // NOT OK
        password: 'hgfedcba' // NOT OK
    });
    pkgcloud.UNKNOWN_SERVICE.createClient({  // OK
        username: 'x6',
        password: 'hgfedcba'
    });
    pkgcloud.providers.SOME_PROVIDER.UNKNOWN_SERVICE.createClient({
        username: 'x7', // OK
        password: 'hgfedcba' // OK
    });
    pkgcloud.compute.createClient({ // OK
        username: process.env.USERNAME,
        password: process.env.PASSWORD
    });
})();

(function(){
    require('crypto').createHmac('sha256', 'hgfedcba');
    require("crypto-js/aes").encrypt('my message', 'hgfedcba');
})()

(function(){
    require("cookie-session")({ secret: "hgfedcba" });
})()

(function(){
    var request = require('request');
    request.get(url, { // OK
        'auth': {
            'user': '',
            'pass': process.env.PASSWORD
        }
    });
})();

(function(){
    var request = require('request');
    let pass = getPassword() || '';
    request.get(url, { // OK
        'auth': {
            'user': process.env.USER || '',
            'pass': pass,
        }
    });
})();

(function(){
	require("cookie-session")({ secret: "change_me" }); // NOT OK
	require('crypto').createHmac('sha256', 'change_me'); // NOT OK

	var basicAuth = require('express-basic-auth');
	basicAuth({users: { [adminName]: 'change_me' }});  // OK
})();

(async function () {
    const base64 = require('base-64');
    const fetch = require("node-fetch");

    const USER = 'sdsdag';
    const PASS = 'sdsdag';
    const AUTH = base64.encode(`${USER}:${PASS}`);

    const rsp = await fetch(ENDPOINT, {
        method: 'get',
        headers: new fetch.Headers({
            "Authorization": `Basic ${AUTH}`,
            "Content-Type": 'application/json'
        })
    });

    fetch(ENDPOINT, {
        method: 'post',
        body: JSON.stringify(body),
        headers: {
            "Content-Type": 'application/json',
            "Authorization": `Basic ${AUTH}`
        },
    })

    var headers = new fetch.Headers({
        "Content-Type": 'application/json'
    });
    headers.append("Authorization", `Basic ${AUTH}`)
    fetch(ENDPOINT, {
        method: 'get',
        headers: headers
    });

    var headers2 = new fetch.Headers({
        "Content-Type": 'application/json'
    });
    headers2.set("Authorization", `Basic ${AUTH}`)
    fetch(ENDPOINT, {
        method: 'get',
        headers: headers2
    });
});

(function () {
    const base64 = require('base-64');

    const USER = 'sdsdag';
    const PASS = 'sdsdag';
    const AUTH = base64.encode(`${USER}:${PASS}`);

    // browser API
    var headers = new Headers();
    headers.append("Content-Type", 'application/json');
    headers.append("Authorization", `Basic ${AUTH}`);
    fetch(ENDPOINT, {
        method: 'get',
        headers: headers
    });
});

(async function () {
    import fetch from 'node-fetch';

    const username = 'sdsdag';
    const password = config.get('some_actually_secrect_password');
    const response = await fetch(ENDPOINT, {
      method: 'get',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Basic ' + Buffer.from(username + ':' + password).toString('base64'),
      },
    });
})

(function () {
    import jwt from "jsonwebtoken";

    var privateKey = "myHardCodedPrivateKey";
    var token = jwt.sign({ foo: 'bar' }, privateKey, { algorithm: 'RS256'});

    var publicKey = "myHardCodedPublicKey";
    jwt.verify(token, publicKey, function(err, decoded) {
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
    require("http").request({auth: "user:{{ INSERT_HERE }}"}); // OK
    require("http").request({auth: "user:token {{ INSERT_HERE }}"}); // OK
    require("http").request({auth: "user:( INSERT_HERE )"}); // OK
    require("http").request({auth: "user:{{ env.access_token }}"}); // OK
    require("http").request({auth: "user:abcdefgh"}); // OK
    require("http").request({auth: "user:12345678"}); // OK
    require("http").request({auth: "user:foo"}); // OK
    require("http").request({auth: "user:mypassword"}) // OK
    require("http").request({auth: "user:mytoken"}) // OK
    require("http").request({auth: "user:fake token"}) // OK
    require("http").request({auth: "user:dcba"}) // OK
    require("http").request({auth: "user:custom string"}) // OK
});

(function () {
    // browser API
    var headers = new Headers();
    headers.append("Authorization", `Basic sdsdag:sdsdag`); // NOT OK
    headers.append("Authorization", `Basic sdsdag:xxxxxxxxxxxxxx`); // OK
    headers.append("Authorization", `Basic sdsdag:aaaiuogrweuibgbbbbb`); // NOT OK
    headers.append("Authorization", `Basic sdsdag:000000000000001`); // OK
});
