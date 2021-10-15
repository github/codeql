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
  // pass the csrfToken to the view
  res.render('send', { csrfToken: req.csrfToken() })
})

app.post('/process', function (req, res) {
  res.send('csrf was required to get here')
})

function createApiRouter () {
  var router = new express.Router()

  router.post('/getProfile', function (req, res) {
    res.send('no csrf to get here')
  })

  return router
}

app.get('/form/subform', function (req, res) {});
app.post('/form/subform', function (req, res) {});
