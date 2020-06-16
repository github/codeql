// Adapted from https://github.com/expressjs/csurf, which is
// licensed under the MIT license; see file LICENSE.

var cookieParser = require('cookie-parser')
var csrf = require('csurf')
var bodyParser = require('body-parser')
var express = require('express')

// create express app
var app = express()

// create api router
var api = createApiRouter()

// mount api before csrf is appended to the app stack
app.use('/api', api)

// now add csrf and other middlewares, after the "/api" was mounted
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(csrf({ cookie: true }))

app.get('/form', function (req, res) {
  let newEmail = req.cookies["newEmail"];
  // pass the csrfToken to the view
  res.render('send', { csrfToken: req.csrfToken() })
})

app.post('/process', function (req, res) { // OK
  let newEmail = req.cookies["newEmail"];
  res.send('csrf was required to get here')
})

function createApiRouter () {
  var router = new express.Router()

  router.post('/getProfile', function (req, res) { // OK - cookies are not parsed
    let newEmail = req.cookies["newEmail"];
    res.send('no csrf to get here')
  })

  router.post('/getProfile_unsafe', cookieParser(), function (req, res) { // NOT OK - may use cookies
    let newEmail = req.cookies["newEmail"];
    res.send('no csrf to get here')
  })

  return router
}
