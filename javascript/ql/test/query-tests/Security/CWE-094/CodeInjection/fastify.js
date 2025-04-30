const fastify = require('fastify')({ logger: true });

fastify.addHook('onRequest', async (request, reply) => {
  const userInput = request.query.onRequest; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.addHook('onSend', async (request, reply, payload) => {
  const userInput = request.query.onSend; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
  return JSON.stringify({ ...JSON.parse(payload), onSend: request.evalResult });
});

fastify.addHook('preParsing', async (request, reply, payload) => {
  const userInput = request.query.preParsing; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
  return payload;
});

fastify.addHook('preValidation', async (request, reply) => {
  const userInput = request.query.preValidation; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.addHook('preHandler', async (request, reply) => {
  const userInput = request.query.preHandler; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.addHook('preSerialization', async (request, reply, payload) => {
  const userInput = request.query.preSerialization; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
  return payload;
});

fastify.addHook('onResponse', async (request, reply) => {
  const userInput = request.query.onResponse; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.addHook('onError', async (request, reply, error) => {
  const userInput = request.query.onError; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.addHook('onTimeout', async (request, reply) => {
  const userInput = request.query.onTimeout; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.addHook('onRequestAbort', (request, done) => {
    const userInput = request.query.onRequestAbort; // $ Source[js/code-injection]
    if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
});

fastify.get('/dangerous', async (request, reply) => {
  const userInput = request.query.input; // $ Source[js/code-injection]
  if (userInput) request.evalResult = eval(userInput); // $ Alert[js/code-injection]
  const result = eval(userInput); // $ Alert[js/code-injection]
  return { result };
});


// Store user input in request object
fastify.addHook('preHandler', async (request, reply) => {
  request.storedCode = request.query.storedCode; // $ Source[js/code-injection]
});
fastify.get('/flow-through-request', async (request, reply) => {
  // Use the stored code from previous hook
  if (request.storedCode) {
    const evaluatedResult = eval(request.storedCode); // $ Alert[js/code-injection]
    return { result: evaluatedResult };
  }
  return { result: null };
});

// Store user input in reply object
fastify.addHook('onRequest', async (request, reply) => {
  reply.userCode = request.query.replyCode; // $ Source[js/code-injection]
});
fastify.get('/flow-through-reply', async (request, reply) => {
  // Use the code stored in reply object
  if (reply.userCode) {
    const replyResult = eval(reply.userCode); // $ Alert[js/code-injection]
    return { result: replyResult };
  }
  return { result: null };
});


// Store user input in reply object
fastify.addHook('onRequest', async (request, reply) => {
  reply.locals = reply.locals || {};
  reply.locals.nestedCode = request.query.replyCode; // $ Source[js/code-injection]
});
fastify.get('/flow-through-reply', async (request, reply) => {
  // Use the code stored in reply object
  if (reply.locals && reply.locals.nestedCode) {
    const replyResult = eval(reply.locals.nestedCode); // $ Alert[js/code-injection]
    return { result: replyResult };
  }
  return { result: null };
});

fastify.all('/eval', async (request, reply) => {
  const userInput = request.query.code; // $ MISSING: Source[js/code-injection]
  const result = eval(userInput); // $ MISSING: Alert[js/code-injection]
  const replyResult = eval(reply.locals.nestedCode); // $ MISSING: Alert[js/code-injection]
  return { method: request.method, result };
});
