const fastify = require('fastify')

const app = fastify();

app.register(require('fastify-cookie')); // $ TODO-SPURIOUS: Alert
app.register(require('fastify-csrf'));

app.route({
  method: 'GET',
  path: '/getter',
  handler: async (req, reply) => {
    return 'hello';
  }
})

// unprotected route
app.route({
  method: 'POST',
  path: '/',
  handler: async (req, reply) => { // $ TODO-MISSING: Alert - lacks CSRF protection
    req.session.blah;
    return req.body
  }
})


app.route({
  method: 'POST',
  path: '/',
  onRequest: app.csrfProtection,
  handler: async (req, reply) => { // OK - has CSRF protection
    return req.body
  }
})
