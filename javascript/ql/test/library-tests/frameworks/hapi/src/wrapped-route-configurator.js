const endpoints = [];

function apiEndpoint(method, path, handler) {
  endpoints.push({ method, path, handler });
}

function createRouteConfig(method, path, handler) {
  const hapiHandler = async function (request, h) {
    return handler(request.params, request.query, request.payload);
  };

  return {
    method,
    path,
    handler: hapiHandler,
  };
}

function registerEndpoints(server, serviceInstance) {
  for (const definition of endpoints) {
    const wrapped = async (params, query, payload) => {
      return definition.handler.call(serviceInstance, params, query, payload);
    };

    const config = createRouteConfig(definition.method, definition.path, wrapped);
    server.route(config);
  }
}

module.exports = { apiEndpoint, registerEndpoints };
