const http = require('http');
const url = require('url');
const ldap = require('ldapjs');
const client = ldap.createClient({
    url: 'ldap://127.0.0.1:1389'
});

const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true);

    let username = q.query.username;

    // BAD
    client.search('o=example', { filter: `(|(name=${username})(username=${username}))` }, function (err, res) {
    });
});
