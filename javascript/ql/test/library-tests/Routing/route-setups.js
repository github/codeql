const express = require('express');
const TestObj = require('@example/test');

function basicTaint() {
    const app = express();
    app.use((req, res, next) => {
        req.tainted = source();
        req.safe = 'safe';
        next();
    });
    app.get('/', (req, res) => {
        sink(req.tainted); // NOT OK
        sink(req.safe); // OK
    });
}

function basicApiGraph() {
    const app = express();
    app.use((req, res, next) => {
        req.obj = new TestObj();
        next();
    });
    app.get('/', (req, res) => {
        sink(req.obj.getSource()); // NOT OK
        req.obj.getSink(source()); // NOT OK
    });
}

function noTaint() {
    const app = express();
    function middleware(req, res, next) {
        req.tainted = source();
        req.safe = 'safe';
        next();
    }
    app.get('/unsafe', middleware, (req, res) => {
        sink(req.tainted); // NOT OK
        sink(req.safe); // OK
    });
    app.get('/safe', (req, res) => {
        sink(req.tainted); // OK - not preceded by middleware
        sink(req.safe); // OK
    });
}

function looseApiGraphStep() {
    const app = express();
    function middleware(req, res, next) {
        req.obj = new TestObj();
        next();
    }
    app.get('/unsafe', middleware, (req, res) => {
        sink(req.obj.getSource()); // NOT OK
    });
    app.get('/safe', (req, res) => {
        sink(req.obj.getSource()); // NOT OK - we allow API graph steps within the same app
    });
}

function chainMiddlewares() {
    const app = express();
    function step1(req, res, next) {
        req.taint = source();
        next();
    }
    function step2(req, res, next) {
        req.locals.alsoTaint = req.taint;
        next();
    }
    app.get('/', step1, step2, (req, res) => {
        sink(req.taint); // NOT OK
        sink(req.locals.alsoTaint); // NOT OK
    });
}

function routerEscapesIntoParameter() {
    const app = express();
    function setupMiddlewares(router) {
        router.use((req, res, next) => {
            req.taint = source();
            next();
        });
    }
    app.get('/before', (req, res) => {
        sink(req.taint); // OK
    });
    setupMiddlewares(app);
    app.get('/after', (req, res) => {
        sink(req.taint); // NOT OK
    });
}

function routerReturned() {
    const app = express();
    function makeMiddlewares() {
        let router = new express.Router();
        router.use((req, res, next) => {
            req.taint = source();
            next();
        });
        return router;
    }
    app.get('/before', (req, res) => {
        sink(req.taint); // OK
    });
    app.use(makeMiddlewares());
    app.get('/after', (req, res) => {
        sink(req.taint); // NOT OK
    });
}

function routerCaptured() {
    const app = express();
    function addMiddlewares() {
        app.use((req, res, next) => {
            req.taint = source();
            next();
        });
    }
    app.get('/before', (req, res) => {
        sink(req.taint); // OK
    });
    addMiddlewares();
    app.get('/after', (req, res) => {
        sink(req.taint); // NOT OK
    });
}

function withPath() {
    const app = express();
    app.use('/foo', (req, res, next) => {
        req.taint = source();
        next();
    });
    app.get('/foo', (req, res) => {
        sink(req.taint); // NOT OK
    });
    app.get('/bar', (req, res) => {
        sink(req.taint); // OK
    });
}


function withNestedPath() {
    const app = express();
    app.use('/foo/bar', (req, res, next) => {
        req.taint = source();
        next();
    });
    function makeRouter() {
        const router = express.Router();
        router.get('/bar', (req, res) => {
            sink(req.taint); // NOT OK
        })
        router.get('/baz', (req, res) => {
            sink(req.taint); // OK
        })
        return router;
    }
    app.get('/foo', makeRouter());
    app.get('/bar', (req, res) => {
        sink(req.taint); // OK
    });
}

function withHttpMethods() {
    const app = express();
    app.get('/foo', (req, res, next) => {
        req.taintGet = source();
        next();
    });
    app.post('/foo', (req, res, next) => {
        req.taintPost = source();
        next();
    });
    app.all('/foo', (req, res, next) => {
        req.taintAll = source();
        next();
    });
    app.get('/foo/a', (req, res) => {
        sink(req.taintGet); // NOT OK
        sink(req.taintPost); // OK - not tainted for GET requests
        sink(req.taintAll); // NOT OK
    });
    app.post('/foo/b', (req, res) => {
        sink(req.taintGet); // OK - not tainted for POST requests
        sink(req.taintPost); // NOT OK
        sink(req.taintAll); // NOT OK
    });
    app.all('/foo/c', (req, res) => {
        sink(req.taintGet); // NOT OK
        sink(req.taintPost); // NOT OK
        sink(req.taintAll); // NOT OK
    });
}

function withChaining() {
    const app = express();
    app.use('/', (req, res) => {
        sink(req.taint); // OK
    });
    function middleware() {
        return express.Router()
            .use((req, res, next) => {
                req.taint = source();
                next();
            })
            .use(blah());
    }
    app.use(middleware());
    app.use('/', (req, res) => {
        sink(req.taint); // NOT OK
    });
}

function withClass() {
    class App {
        constructor(router) {
            this.router = router;
            this.earlyRoutes();
            this.addMiddleware();
            this.lateRoutes();
        }
        earlyRoutes() {
            this.router.get('/', (req, res) => {
                sink(req.taint); // OK
            })
        }
        addMiddleware() {
            this.router.use((req, res, next) => {
                req.taint = source();
                next();
            })
        }
        lateRoutes() {
            this.router.get('/', (req, res) => {
                sink(req.taint); // NOT OK
            })
        }
    }
    let app = new App(express());
}

function withArray() {
    const app = express();
    app.get('/before', (req, res) => {
        sink(req.taint); // OK
    });
    app.use([
        (req, res, next) => {
            sink(req.taint); // OK
            next();
        },
        (req, res, next) => {
            req.taint = source();
            next();
        },
        (req, res, next) => {
            sink(req.taint); // NOT OK
            next();
        }
    ]);
    app.get('/after', (req, res) => {
        sink(req.taint); // NOT OK
    });
}

function withForLoop() {
    const app = express();
    let middlewares = [
        (req, res, next) => {
            sink(req.taint); // OK
            next();
        },
        (req, res, next) => {
            req.taint = source();
            next();
        },
        (req, res, next) => {
            sink(req.taint); // NOT OK
            next();
        }
    ];
    app.get('/before', (req, res) => {
        sink(req.taint); // OK
    });
    for (let route of middlewares) {
        app.use(route);
    }
    app.get('/after', (req, res) => {
        sink(req.taint); // NOT OK
    });
}

function routeHandlersInProps() {
    let routes = require('./routes');
    const app = express();
    app.use(routes.first);
    app.get('/', routes.second);
}
