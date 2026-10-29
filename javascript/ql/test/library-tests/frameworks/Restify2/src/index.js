var restify = require('restify');
const restifyPlugins = require('restify-plugins');
var clients = require('restify-clients');

const opts = {
  formatters: {
    'text/plain': function(req, res, body) { // test: formatter
      if (body instanceof Error) {
        return '<html><body>' + body.message + '</body></html>'; // test: stackTraceExposureSink
      } else {
        return '<html><body>' + body + req.params.name + '</body></html>'; // test: source, stackTraceExposureSink, !xssSink, !xss
      }
    }
  }
}
const _server = restify.createServer(opts)

const server = restify.createServer({
  formatters: {
    'text/html': function(req, res, body) { // test: formatter
      if (body instanceof Error) {
        return '<html><body>' + body.message + '</body></html>'; // test: stackTraceExposureSink, xssSink
      } else {
        return '<html><body>' + body + req.params.name + '</body></html>'; // test: source, stackTraceExposureSink, xssSink, xss
      }
    }
  }
});

// The pre handler chain is executed before routing. That means these handlers will execute for an incoming request even if it’s for a route that you did not register.
server.pre(restify.plugins.pre.dedupeSlashes());
server.pre(function(req, res, next) { // test: handler
  return next();
});

// The use handler chains is executed after a route has been chosen to service the request. 
server.use(restifyPlugins.jsonBodyParser({ mapParams: true })); // TODO: prototype pollution?
server.use(restifyPlugins.acceptParser(server.acceptable));
server.use(restifyPlugins.queryParser({ mapParams: true })); // TODO: prototype pollution?
server.use(restifyPlugins.fullResponse());
server.use(function(req, res, next) { // test: handler
  return next();
});
function filter(req, res, next) { // test: handler
  return next();
}
function filter1(req, res, next) { // test: handler
  return next();
}
function filter2(req, res, next) { // test: handler
  return next();
}
function filter3(req, res, next) { // test: handler
  return next();
}
function filter4(req, res, next) { // test: handler
  return next();
}
function filter5(req, res, next) { // test: handler
  return next();
}
function filter6(req, res, next) { // test: handler
  return next();
}
const handlers = [filter5, filter6];
server.use(filter); // test: setup
server.use(filter1, filter2); // test: setup
server.use([filter3, filter4]); // test: setup
server.use(handlers); // setup

function respond(req, res, next) { // test: handler
  res.send('hello ' + req.params.name); // test: source, stackTraceExposureSink 
  res.send('hello ' + req.params["name"]); // test: source, stackTraceExposureSink
  res.send('hello ' + req.query.name); // test: source, stackTraceExposureSink
  res.send('hello ' + req.params[0]); // test: source, stackTraceExposureSink

  res.redirect({
    hostname: req.params.name, // test: source, redirectSink
    pathname: '/bar',
    port: 80,
    secure: true,
    permanent: true,
    query: {
      a: 1
    }
  }, next);
  res.redirect(301, req.params.name, next); // test: source, redirectSink
  res.redirect(req.params.name, next); // test: source, redirectSink
  next();
}
server.get('/hello/:name', respond); // test: setup
server.head('/hello/:name', respond); // test: setup
server.get('/', function(req, res, next) { // test: setup, handler
  res.send('home')
  return next();
});

server.get('/foo', // test: setup
  function(req, res, next) { // test: handler
    req.someData = req.params.name; // test: source
    return next();
  },
  function(req, res, next) { // test: handler
    res.header("Content-Type", "text/html"); // test: headerDefinition
    res.send(req.someData); // test: stackTraceExposureSink, xssSink, xss
    return next();
  }
);

server.get('/foo2', // test: setup
  [function(req, res, next) { // test: handler
    req.someData = 'foo';
    return next();
  },
  function(req, res, next) { // test: handler
    res.send(req.someData); // test: stackTraceExposureSink
    return next();
  }]
);

function xss(req, res, next) { // test: handler
  res.header("Content-Type", "text/html"); // test: headerDefinition
  res.send('hello ' + req.query.name); // test: source, stackTraceExposureSink, xssSink, xss
  next();
}

function xss2(req, res, next) { // test: candidateHandler
  next()
}

function xss3(req, res, next) { // test: handler
  res.header("Content-Type", "text/html"); // test: headerDefinition
  res.send('hello ' + req.header("foo")); // test: source, stackTraceExposureSink, xssSink, !xss
  next();
}

function xss4(req, res, next) { // test: handler
  var body = req.params.name; // test: source
  res.writeHead(200, {
    'Content-Length': Buffer.byteLength(body),
    'Content-Type': 'text/html'
  });
  res.write(body); // test: stackTraceExposureSink, xssSink, xss
  res.end();
  next();
}

server["get"]('/xss', xss); // test: setup
["get", "head"].forEach(method => {
  server[method]('/xss2', xss2);
});
server["get"]('/xss3', xss3); // test: setup
server["get"]('/xss4', xss4); // test: setup


server.get('/testv2', function(req, res, next) { // test: handler
  res.set({
    "Content-Type": "text/html",
    "access-control-allow-origin": "*", // test: corsMiconfigurationSink
    "access-control-allow-headers": "Content-Type, Authorization, Content-Length, X-Requested-With",
    "access-control-allow-methods": "GET, POST, PUT, DELETE, OPTIONS",
    "access-control-allow-credentials": "true"
  })
  res.send('hello ' + req.params.name); // test: source, stackTraceExposureSink, xssSink, xss
  clients.createJsonClient({
    url: req.params.uri, // test: source, ssrfSink
  });
  clients.createJsonClient(req.params.uri); // test: source, ssrfSink

  next();
})

server.get('/hello2/:name', restify.plugins.conditionalHandler([ // test: setup
  { version: ['2.0.0', '2.1.0', '2.2.0'], handler: sendV2 }
]));

server.get('/version/test', restify.plugins.conditionalHandler([ //test: setup
  {
    version: ['2.0.0', '2.1.0', '2.2.0'],
    handler: function(req, res, next) {  // test: candidateHandler
      res.send(200, {
        requestedVersion: req.version(),
        matchedVersion: req.matchedVersion()
      });
      return next();
    }
  }
]));

server.on('InternalServer', function(req, res, err, callback) { // test: setup, handler
  return callback();
});

server.on('restifyError', function(req, res, err, callback) { // test: setup, handler
  return callback();
});
server.on('after', function(req, res, route, error) { // test: setup, handler
});
server.on('pre', function(req, res) { // test: setup, handler
});
server.on('routed', function(req, res, route) { // test: setup, handler
  res.header("Content-Type", "text/plain")
  res.send(req.params.foo) // test: source, !xssSink, !xss
});
server.on('uncaughtException', function(req, res, route, err) { // test: setup, handler
  res.header("Content-Type", "text/html")
  res.send(req.params.foo) // test: source, xssSink, xss
});


server.listen(8080, function() {
  console.log('%s listening at %s', server.name, server.url);
});

