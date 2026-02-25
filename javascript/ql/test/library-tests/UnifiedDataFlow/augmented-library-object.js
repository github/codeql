import * as express from 'express';

function createApp() {
    const app = express();
    app.helper = function() {
        return source('t1.1');
    }
    return app;
}

function t1() {
    const app = createApp();
    sink(app.helper()); // $ hasValueFlow=t1.1

    function helper(appArg) {
        sink(appArg.helper()); // $ hasValueFlow=t1.1
    }
    helper(app);
}
