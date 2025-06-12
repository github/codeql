function connectAndLog(id) {
    log.info(`Connecting to ${id}`)
    let connection = openConnection(id)
    if (!connection) {
      log.error('Could not connect to ${id}') // $ Alert
    }
}

function emitTemplate(name, date) {
    writer.emit("Name: ${name}, Date: ${date}",
        { name: name, date: date });
}

var globalVar = "global";

function foo() {
    log.error('globalVar = ${globalVar}'); // $ Alert
}
log.error('globalVar = ${globalVar}'); // $ Alert

function bar() {
    log.error('Something ${notInScope}');
}

function baz(x){
    log.error("${x}");
    log.error("${y}");
    log.error("${x} "); // $ Alert
    log.error("${y} ");
}


function foo1() {
    const aTemplateLitInScope = `Connecting to ${id}`;
    const name = 2;
    const date = 3;
    const foobar = 4;

    const data = {name: name, date: date};
    writer.emit("Name: ${name}, Date: ${date}.", data);

    writer.emit("Name: ${name}, Date: ${date}, ${foobar}", data); // $ Alert - `foobar` is not in `data`.
}

function a(actual, expected, description) {
    assert(false, "a", description, "expected (" +
        typeof expected + ") ${expected} but got (" + typeof actual + ") ${actual}", {
            expected: expected,
            actual: actual
        });
}

function replacer(str, name) {
    return str.replace("${name}", name);
}

function replacerAll(str, name) {
    return str.replaceAll("${name}", name);
}

function manualInterpolation(name) {
    let str = "Name: ${name}"; // $SPURIOUS:Alert
    let result1 = replacer(str, name);
    console.log(result1); 

    str = "Name: ${name} and again: ${name}"; // $SPURIOUS:Alert
    let result2 = replacerAll(str, name);
    console.log(result2);
}
