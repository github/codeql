const lib = require('testlib');

function foo() {
    return lib.foo(); // name: raw-await-source
}

async function test() {
  const x = await foo();
  const y = await x;
  const z = await y;
  z; // track: raw-await-source
}

async function exceptionThrower() {
    throw {}; // name: raw-await-err
}

async function exceptionReThrower() {
    const x = await exceptionThrower();
    const y = x.catch(err => {
        err; // track: none
    });
    return y;
}

async function exceptionCatcher() {
    try {
        await exceptionThrower();
    } catch (err) {
        err; // track: raw-await-err
    }
}
