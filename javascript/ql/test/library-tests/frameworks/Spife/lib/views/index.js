'use strict'

const reply = require('@npm/spife/reply')
const validate = require('@npm/spife/decorators/validate')
const joi = require('@npm/spife/joi')
const concat = require('concat-stream')

const createPackageSchema = joi.object().keys({
  contents: joi.string().max(200).required(),
  destination: joi.any().valid([
    joi.object({
      name: joi.string().max(200).required(),
      address: joi.string().max(200).required()
    }),
    joi.string().min(1)
  ])
})

module.exports = { homepage, parseBody, raw1, raw2, test1, test2, test3, test4, test5, test6, redirect, createPackage: validate.body(createPackageSchema, createPackage), }

function sink(obj) { console.log(obj) }

function createPackage(req, context) { // test: handler
  const tainted = req.validatedBody.get('destination') // test: source
  sink(taitned)
}

function homepage(req, context) { // test: handler
  sink(req.cookie("test")) // test: source
  sink(req.cookies().test) // test: source
  sink(req.headers.test) // test: source
  sink(req.rawHeaders[0]) // test: source
  sink(req.raw.headers) // test: source
  sink(req.url) // test: source
  sink(req.urlObject.pathname) // test: source
  sink(context.get('package')) // test: source
  sink(context)
  return reply.template('home', { target: req.query.name }) // test: source, templateInstantiation, stackTraceExposureSink, responseBody
}

function raw1(req, context) { // test: handler
  sink(req.query.name) // test: source
  return reply(req.query.name, 200, { // test: source, xssSink, stackTraceExposureSink, xss
    "content-type": "text/html", // test: headerDefinition
    "access-control-allow-origin": "*", // test: corsMiconfigurationSink, headerDefinition
    "access-control-allow-headers": "Content-Type, Authorization, Content-Length, X-Requested-With", // test: headerDefinition
    "access-control-allow-methods": "GET, POST, PUT, DELETE, OPTIONS", // test: headerDefinition
    "access-control-allow-credentials": "true" //test: headerDefinition

  })
}

function redirect(req, context) { // test: handler
  return reply.redirect(context.get('redirect_url')) // test: redirectSink, source
}
function raw2(req, context) { // test: handler
  return reply.cookie({ "test": req.query.name }, "test", req.query.name, { "httpOnly": false, "secure": false }) // test: source, cleartextStorageSink, stackTraceExposureSink, cookieDefinition
}

function test1(req, context) { // test: handler
  switch (req.accept.type(['json', 'html', 'plain'])) {
    case 'json':
      return { "some": req.query.name } // test: source, stackTraceExposureSink
    case 'html':
      return reply.header('<p>' + req.query.name + '</p>', 'content-type', 'text/html') // test: source, xssSink, stackTraceExposureSink, xss, headerDefinition
    case 'plain':
      return reply.header('<p>' + req.query.name + '</p>', { 'content-type': 'text/plain' }) // test: source, stackTraceExposureSink, !xssSink, !xss, headerDefinition, headerDefinition
  }
  return 'well, I guess you just want plaintext.'
}

function test2(req, context) { // test: handler
  switch (req.accept.type(['json', 'html'])) {
    case 'json':
      return { "some": req.query.name } // test: source, stackTraceExposureSink
    case 'html':
      return reply.header('<p>' + req.query.name + '</p>', { 'content-type': 'text/plain' }) // test: source, stackTraceExposureSink, !xssSink, !xss, headerDefinition
  }
  return 'well, I guess you just want plaintext.'
}

function test3(req, context) { // test: candidateHandler
  return reply('<p>' + req.query.name + '</p>')
}

function test4(req, context) { // test: handler
  const body = req.body // test: source
  const newPackument = body['package-json']
  const message = `INFO: User invited to package ${newPackument._id} successfully.`
  return reply(message, 200, { 'npm-notice': message }) // test: stackTraceExposureSink, !xssSink, !xss, headerDefinition
}

function test5(req, context) { // test: handler
  const body = req.body // test: source
  const newPackument = body['package-json']
  const message = `INFO: User invited to package ${newPackument._id} successfully.`
  return reply(message, 200) // test: stackTraceExposureSink, !xssSink, !xss
}

function test6(req, context) { // test: handler
  const body = req.body // test: source
  const newPackument = body['package-json']
  const message = `INFO: User invited to package ${newPackument._id} successfully.`
  if (message.contains('foo')) {
    return reply(message, 200, { 'npm-notice': message }) // test: stackTraceExposureSink, !xssSink, !xss, headerDefinition
  } else {
    return reply(message, 200, { 'npm-notice': message, 'content-type': 'text/html' }) // test: stackTraceExposureSink, xssSink, xss, headerDefinition
  }
}

function parseBody(req, context) {
  return req.body.then(data => { // test: source, stackTraceExposureSink
    sink(data.name)
  })
}
