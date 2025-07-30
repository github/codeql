import { ApolloServer } from 'apollo-server';
var https = require('https'),
    url = require('url');

var server = https.createServer(function () { });

server.on('request', function (req, res) {
    let user_origin = url.parse(req.url, true).query.origin;
    // BAD: CORS too permissive
    const server_1 = new ApolloServer({
        cors: { origin: true }
    });

    // GOOD: restrictive CORS 
    const server_2 = new ApolloServer({
        cors: false
    });

    // BAD: CORS too permissive 
    const server_3 = new ApolloServer({
        cors: { origin: null }
    });

    // BAD: CORS is controlled by user
    const server_4 = new ApolloServer({
        cors: { origin: user_origin }
    });
});