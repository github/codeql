(function() {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser',
        host: 'database.server.com',
        database: 'mydb',
        password: 'abcdefgh',
        port: 3211,
    }); // NOT OK
    client.connect();
})();

(function() {
    require("http").request({auth: "user:abcdefgh"});  // NOT OK
    require("https").request({auth: "user:abcdefgh"}); // NOT OK
    function getCredentials() {
        return "user:abcdefgh";
    }
    require("http").request({auth: getCredentials()}); // NOT OK
    require("http").request({auth: getUnknownCredentials()}); // OK
})();

(function() {
    var basicAuth = require('express-basic-auth');

    basicAuth({users: { 'admin': 'abcdefgh' }});  // NOT OK
    var users = {};
    users['unknown-admin-name'] = 'abcdefgh';
    basicAuth({users: users})  // NOT OK
})();

(function() {
    var basicAuth = require('basic-auth-connect');
    basicAuth('username', 'abcdefgh'); // NOT OK
    basicAuth(function(){}); // OK
})();

(function() {
    var AWS = require('aws-sdk');
    AWS.config.update({ accessKeyId: 'username', secretAccessKey: 'abcdefgh'}); // NOT OK
    new AWS.Config({ accessKeyId: 'username', secretAccessKey: 'abcdefgh'}); // NOT OK
    var config = new AWS.Config();
    config.update({ accessKeyId: 'username', secretAccessKey: 'abcdefgh'}); // NOT OK
    var o = {};
    o.secretAccessKey = 'abcdefgh';
    config.update(o); // NOT OK
})();

(function() {
    var request = require('request');

    request.get(url).auth('username', 'abcdefgh'); // NOT OK
    request.get(url, { // NOT OK
        'auth': {
            'user': 'username',
            'pass': 'abcdefgh'
        }
    });

    request.get(url).auth(null, null, _, 'bearerToken'); // NOT OK

    request.get(url, { // NOT OK
        'auth': {
            'bearer': 'bearerToken'
        }
    });

    request.post(url).auth('username', 'abcdefgh'); // NOT OK
    request.head(url).auth('username', 'abcdefgh'); // NOT OK

    request(url).auth('username', 'abcdefgh'); // NOT OK
    request(url, { // NOT OK
        'auth': {
            'user': 'username',
            'pass': 'abcdefgh'
        }
    });
})();

(function() {
    const MsRest = require('ms-rest-azure');

    MsRest.loginWithUsernamePassword('username', 'abcdefgh', function(){}); // NOT OK
    MsRest.loginWithUsernamePassword(process.env.AZURE_USER, process.env.AZURE_PASS, function(){}); // OK
    MsRest.loginWithServicePrincipalSecret('username', 'abcdefgh', function(){}); // NOT OK
})();

(function() {
    var digitalocean = require('digitalocean');
    digitalocean.client('TOKEN'); // NOT OK
    digitalocean.client(process.env.DIGITAL_OCEAN_TOKEN); // OK
})();

(function() {
    var pkgcloud = require('pkgcloud');
    pkgcloud.compute.createClient({ // NOT OK
        account: 'x1',
        keyId: 'x2',
        storageAccount: 'x3',
        username: 'x4',
        key: 'abcdefgh',
        apiKey: 'abcdefgh',
        storageAccessKey: 'abcdefgh',
        password: 'abcdefgh',
        token: 'abcdefgh'
    });
    pkgcloud.compute.createClient({ // OK
        INNOCENT_DATA: '42'
    });
    pkgcloud.providers.SOME_PROVIDER.compute.createClient({  // NOT OK
        username: 'x5',
        password: 'abcdefgh'
    });
    pkgcloud.UNKNOWN_SERVICE.createClient({  // OK
        username: 'x6',
        password: 'abcdefgh'
    });
    pkgcloud.providers.SOME_PROVIDER.UNKNOWN_SERVICE.createClient({  // OK
        username: 'x7',
        password: 'abcdefgh'
    });
    pkgcloud.compute.createClient({ // OK
        username: process.env.USERNAME,
        password: process.env.PASSWORD
    });
})();

(function(){
    require('crypto').createHmac('sha256', 'abcdefgh');
    require("crypto-js/aes").encrypt('my message', 'abcdefgh');
})()

(function(){
    require("cookie-session")({ secret: "abcdefgh" });
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