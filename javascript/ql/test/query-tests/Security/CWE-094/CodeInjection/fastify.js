const fastify = require('fastify')({ logger: true });

fastify.addHook('onRequest', async (request, reply) => {
  const userInput = request.query.onRequest; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.addHook('onSend', async (request, reply, payload) => {
  const userInput = request.query.onSend; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
  return JSON.stringify({ ...JSON.parse(payload), onSend: request.evalResult });
});

fastify.addHook('preParsing', async (request, reply, payload) => {
  const userInput = request.query.preParsing; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
  return payload;
});

fastify.addHook('preValidation', async (request, reply) => {
  const userInput = request.query.preValidation; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.addHook('preHandler', async (request, reply) => {
  const userInput = request.query.preHandler; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.addHook('preSerialization', async (request, reply, payload) => {
  const userInput = request.query.preSerialization; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
  return payload;
});

fastify.addHook('onResponse', async (request, reply) => {
  const userInput = request.query.onResponse; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.addHook('onError', async (request, reply, error) => {
  const userInput = request.query.onError; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.addHook('onTimeout', async (request, reply) => {
  const userInput = request.query.onTimeout; // $ MISSING: Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.addHook('onRequestAbort', (request, done) => {
    const userInput = request.query.onRequestAbort; // $ MISSING: Source[js/code-injection]
    if (userInput) request.evalResult = eval(userInput); // $ MISSING: Alert[js/code-injection]
});

fastify.get('/dangerous', async (request, reply) => {
  const userInput = request.query.input; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
  const result = eval(userInput); // $ Alert[js/code-injection]
  return { result };
});


// Store user input in request object
fastify.addHook('preHandler', async (request, reply) => {
  request.storedCode = request.query.storedCode;
});
fastify.get('/flow-through-request', async (request, reply) => {
  // Use the stored code from previous hook
  if (request.storedCode) {
    const evaluatedResult = eval(request.storedCode); // $ MISSING: Alert[js/code-injection]
    return { result: evaluatedResult };
  }
  return { result: null };
});

// Store user input in reply object
fastify.addHook('onRequest', async (request, reply) => {
  reply.userCode = request.query.replyCode;
});
fastify.get('/flow-through-reply', async (request, reply) => {
  // Use the code stored in reply object
  if (reply.userCode) {
    const replyResult = eval(reply.userCode); // $ MISSING: Alert[js/code-injection]
    return { result: replyResult };
  }
  return { result: null };
});


// Store user input in reply object
fastify.addHook('onRequest', async (request, reply) => {
  reply.locals = reply.locals || {};
  reply.locals.nestedCode = request.query.replyCode;
});
fastify.get('/flow-through-reply', async (request, reply) => {
  // Use the code stored in reply object
  if (reply.locals && reply.locals.nestedCode) {
    const replyResult = eval(reply.locals.nestedCode); // $ MISSING: Alert[js/code-injection]
    return { result: replyResult };
  }
  return { result: null };
});
