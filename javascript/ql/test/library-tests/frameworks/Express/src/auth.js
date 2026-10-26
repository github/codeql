const app = require('express')();
const basicAuth = require('express-basic-auth');

app.use(basicAuth({ users: { 'admin': 'passw0rd' }}));
