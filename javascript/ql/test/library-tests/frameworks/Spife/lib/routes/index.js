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


const a = routes`GET /packages/package/${p} viewPackage`(require('../views')) // test:routeSetup

const b = routes`GET / list`({ ...require('../views'), ...require('../views/orgs') }) // test: routeSetup

const c = routes`POST  /message  handleMessage`({ handleMessage: console.log }) // test: routeSetup

const d = routes`GET /version versionHandler`({ versionHandler: (req, context) => { console.log(req) } }) // test: routeSetup

const e = routes`GET / handler`({ handler: async (req, context) => { console.log(req) } }) // test: routeSetup
