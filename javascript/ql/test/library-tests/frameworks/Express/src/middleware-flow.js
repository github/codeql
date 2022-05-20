const express = require('express');
const app = express();
const DB = require('@example/db');

function installDb(req, res, next) {
    req.db = new DB();
    req.deep.db = new DB();
    req.deep.access.db = new DB();
    next();
}

function addMiddlewares(router) {
    router.use(installDb);
}

function addRoutes(router) {
    router.get('/foo', (req, res) => {
        req.db;
        req.deep.db;
        req.deep.access.db;
    });
    let routers = {
        '/bar': (req, res) => { req.db; },
        '/baz': (req, res) => { req.db; },
    };
    for (let p in routers) {
        router.get(p, routers[p]);
    }
}

addMiddlewares(app);
addRoutes(app);

app.listen();


const unrelatedApp = express();

unrelatedApp.get('/', (req, res) => {
    req.db;
    req.deep.db;
    req.deep.access.db;
});
