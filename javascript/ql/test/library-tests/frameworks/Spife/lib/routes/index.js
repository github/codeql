'use strict'

const routes = require('@npm/spife/routing')

module.exports = routes`
  GET / homepage
  GET /test1 test1
  GET /test1 test2
  GET /test4 test4
  GET /test5 test5
  GET /test6 test6
  GET /raw1 raw1
  GET /raw2 raw2
  POST /body parseBody
  GET /redirect/:redirect_url redirect
  POST /packages/new createPackage
`(require('../views'))
