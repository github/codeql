var express = require("express");
var app = express();

// registration of route handlers in bulk
let routes0 = {
  a: (req, res) => console.log(req),
  b: (req, res) => console.log(req)
};
for (const p in routes0) {
  app.get(p, routes0[p]);
}

// registration of route handlers in bulk
let routes1 = {
  a: (req, res) => console.log(req),
  b: (req, res) => console.log(req)
};
for (const handler of routes1) {
  app.use(handler);
}

// registration of route handlers in bulk, with indirection
let routes2 = {
  a: (req, res) => console.log(req),
  b: (req, res) => console.log(req)
};
for (const p of Object.keys(routes2)) {
  app.get(p, routes2[p]);
}

// registration of route handlers in bulk, with indirection
let routes3 = {
  a: (req, res) => console.log(req),
  b: (req, res) => console.log(req)
};
for (const h of Object.values(routes3)) {
  app.use(h);
}

// custom router indirection for all requests
let myRouter1 = {
  handlers: {},
  add: function(n, h) {
    this.handlers[n] = h;
  },
  handle: function(req, res, target) {
    this.handlers[target](req, res);
  }
};
myRouter1.add("whatever", (req, res) => console.log(req));
app.use((req, res) => myRouter1.handle(req, res, "whatever"));

// simpler custom router indirection for all requests
let mySimpleRouter = {
  handler: undefined,
  add: function(h) {
    this.handler = h;
  },
  handle: function(req, res) {
    this.handler(req, res);
  }
};
mySimpleRouter.add((req, res) => console.log(req));
app.use((req, res) => mySimpleRouter.handle(req, res));

// simplest custom router indirection for all requests
let mySimplestRouter = {
  handler: (req, res) => console.log(req),
  handle: function(req, res) {
    this.handler(req, res);
  }
};
app.use((req, res) => mySimplestRouter.handle(req, res));

// a combination of bulk registration and indirection through a custom router
let myRouter3 = {
  handlers: {},
  add: function(n, h) {
    this.handlers[n] = h;
  },
  handle: function(req, res, target) {
    this.handlers[target](req, res);
  }
};
let routes3 = {
  a: (req, res) => console.log(req),
  b: (req, res) => console.log(req)
};
for (const p of Object.keys(routes3)) {
  myRouter3.add(p, routes3[p]);
}
app.use((req, res) => myRouter3.handle(req, res, "whatever"));

// a combination of bulk registration and indirection through a custom router. Using a map instead of an object.
let myRouter4 = {
  handlers: new Map(),
  add: function(n, h) {
    this.handlers.set(n, h);
  },
  handle: function(req, res, target) {
    this.handlers.get(target)(req, res);
  }
};
let routes4 = {
  a: (req, res) => console.log(req),
  b: (req, res) => console.log(req)
};
for (const p of Object.keys(routes4)) {
  myRouter4.add(p, routes4[p]);
}
app.use((req, res) => myRouter4.handle(req, res, "whatever"));

// registration of imported route handlers in bulk
let importedRoutes = require("./route-collection").routes;
for (const p in importedRoutes) {
  app.get(p, importedRoutes[p]);
}
app.get("a", importedRoutes.a);
app.get("b", importedRoutes.b);

// registration of imported route handlers in a map
let routesMap = new Map();
routesMap.set("a", (req, res) => console.log(req));
routesMap.set("b", (req, res) => console.log(req));
routesMap.forEach((v, k) => app.get(k, v));
app.get("a", routesMap.get("a"));
app.get("b", routesMap.get("b"));

let method = "GET";
app[method.toLowerCase()](path, (req, res) => undefined);

let names = ["handler-in-dynamic-require"];
names.forEach(name => {
	let dynamicRequire = require("./controllers/" + name);
	app.get(dynamicRequire.path, dynamicRequire.handler);
});

let bulkRequire = require("./controllers");
app.get(bulkRequire.bulky.path, bulkRequire.bulky.handler);

let options = { app: app };
let args = [];
args.push((req, res) => undefined);
app.use.apply(options.app, args);

let handlers = { handlerA: (req, res) => undefined};
app.use(handlers.handlerA.bind(data));

for ([k, v] of routesMap) {
	app.get(k, v) // not supported - requires one too many heap steps
}

app.get("b", routesMap.get("NOT_A_KEY!")); // unknown route handler

let routesMap2 = new Map();
routesMap2.set("c", (req, res) => console.log(req));
routesMap2.set(unknown(), (req, res) => console.log(req));
routesMap2.set("e", (req, res) => console.log(req));

app.get("c", routesMap2.get("c"));
app.get("d", routesMap2.get(unknown()));
app.get("e", unknown());
app.get("d", routesMap2.get("f"));
