const express = require('express');
const bodyParser = require('body-parser');
const cp = require('child_process');

const app = express();
app.use(bodyParser.json());

function legacyEval(code) {
    cp.exec(code.code); // $ Alert
}

app.post('/eval', async (req, res) => {
    const { promisify } = require('util');
    const evalAsync = promisify(legacyEval);
    const code = req.body; // $ Source
    evalAsync(code);
});

app.post('/eval', async (req, res) => {
    const directPromisify = require('util.promisify');
    const code = req.body; // $ Source

    const promisifiedExec3 = directPromisify(cp.exec);
    promisifiedExec3(code); // $ Alert
});

app.post('/eval', async (req, res) => {
    const promisify2 = require('util.promisify-all');
    const promisifiedCp = promisify2(cp);
    const code = req.body; // $ Source
    promisifiedCp.exec(code); // $ Alert
});


app.post('/eval', async (req, res) => {
    var garPromisify = require("@gar/promisify");
    const code = req.body; // $ Source

    const promisifiedExec = garPromisify(cp.exec);
    promisifiedExec(code); // $ Alert

    const promisifiedCp = garPromisify(cp);
    promisifiedCp.exec(code); // $ Alert
});

app.post('/eval', async (req, res) => {
    require('util.promisify/shim')();
    const util = require('util');
    const code = req.body; // $ Source

    const promisifiedExec = util.promisify(cp.exec);
    promisifiedExec(code); // $ Alert

    const execAsync = util.promisify(cp.exec.bind(cp));
    execAsync(code); // $ Alert
});


app.post('/eval', async (req, res) => {
    const es6Promisify = require("es6-promisify");
    let cmd = req.body; // $ Source

    // Test basic promisification
    const promisifiedExec = es6Promisify(cp.exec);
    promisifiedExec(cmd); // $ Alert

    // Test with method binding
    const execBoundAsync = es6Promisify(cp.exec.bind(cp));
    execBoundAsync(cmd); // $ Alert

    const promisifiedExecMulti = es6Promisify(cp.exec, {
        multiArgs: true
    });
    promisifiedExecMulti(cmd); // $ Alert

    const promisifiedCp = es6Promisify.promisifyAll(cp);
    promisifiedCp.exec(cmd); // $ Alert
    promisifiedCp.execFile(cmd); // $ Alert
    promisifiedCp.spawn(cmd); // $ Alert

    const lambda = es6Promisify((code, callback) => {
        try {
            const result = cp.exec(code); // $ Alert
            callback(null, result);
        } catch (err) {
            callback(err);
        }
    });
    lambda(cmd);
});


app.post('/eval', async (req, res) => {
    var thenifyAll = require('thenify-all');
    var cpThenifyAll = thenifyAll(require('child_process'), {}, [
      'exec',
      'execSync',
    ]);
    const code = req.body; // $ Source
    cpThenifyAll.exec(code); // $ Alert
    cpThenifyAll.execSync(code); // $ Alert
    cpThenifyAll.execFile(code); // $ SPURIOUS: Alert - not promisified, as it is not listed in `thenifyAll`, but it should fine to flag it


    var cpThenifyAll1 = thenifyAll.withCallback(require('child_process'), {}, ['exec']);
    cpThenifyAll1.exec(code, function (err, string) {}); // $ Alert

    var cpThenifyAll2 = thenifyAll(require('child_process'));
    cpThenifyAll2.exec(code); // $ Alert
});

app.post('/eval', async (req, res) => {
    const maybe = require('call-me-maybe');
    const code = req.body; // $ Source
    
    function createExecPromise(cmd) {
        return new Promise((resolve) => {
            resolve(cmd);
        });
    }
    
    const cmdPromise = createExecPromise(code);
    maybe(null, cmdPromise).then(cmd => {
        cp.exec(cmd); // $ Alert
    });
});

app.post('/eval', async (req, res) => {
    const utilPromisify = require('util-promisify');
    const code = req.body; // $ Source

    const promisifiedExec = utilPromisify(cp.exec);
    promisifiedExec(code); // $ Alert

    const execAsync = utilPromisify(cp.exec.bind(cp));
    execAsync(code); // $ Alert
});

app.post('/eval', async (req, res) => {
    const {promisify, promisifyAll} = require('@google-cloud/promisify');
    const code = req.body; // $ Source

    const promisifiedExec = promisify(cp.exec);
    promisifiedExec(code); // $ Alert

    const execAsync = promisify(cp.exec.bind(cp));
    execAsync(code); // $ Alert

    const promisifiedCp = promisifyAll(cp);
    promisifiedCp.exec(code); // $ Alert
    promisifiedCp.execFile(code); // $ Alert
    promisifiedCp.spawn(code); // $ Alert
});
