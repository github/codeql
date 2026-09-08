const Hapi = require("hapi");

const endpoints = [];

function endpoint(handler) {
  endpoints.push({ handler });
}

function routeConfig(handler) {
  return {
    handler: async function (request, h) {
      return handler(request.query);
    },
  };
}

function createCached(fn) {
  return async function (...args) {
    return fn(...args);
  };
}

const cached = createCached(function (filter) {
  sink(filter);
});

class Routes {
  get(query) {
    return cached(query.filter);
  }
}

endpoint(Routes.prototype.get);

function register(server, instance) {
  for (const definition of endpoints) {
    const wrapped = async (query) => definition.handler.call(instance, query);
    server.route(routeConfig(wrapped));
  }
}

register(new Hapi.Server(), new Routes());