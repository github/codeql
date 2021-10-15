const http = require('http');
const url = require('url');
const ldap = require('ldapjs');
const client = ldap.createClient({
    url: 'ldap://127.0.0.1:1389'
});

const server = http.createServer((req, res) => {
    let q = url.parse(req.url, true);

    let username = q.query.username;

    // GOOD (https://github.com/ldapjs/node-ldapjs/issues/181)
    let f = new OrFilter({
        filters: [
            new EqualityFilter({
                attribute: 'name',
                value: username
            }),
            new EqualityFilter({
                attribute: 'username',
                value: username
            })
        ]
    });

    client.search('o=example', { filter: f }, function (err, res) {
    });
});
