const express = require('express')
const cookieParser = require('cookie-parser')
const csrf = require('csurf')

const app = express()
app.use(cookieParser()) // $ Alert

app.post('/unsafe', (req, res) => { // $ RelatedLocation
  req.cookies.x;
});

function middlewares() {
  return express.Router()
    .use(csrf({ cookie: true}))
    .use('/', express.bodyParser());
}

app.use(middlewares());

app.post('/safe', (req, res) => {
  req.cookies.x;
});
