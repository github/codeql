function connectAndLog(id) {
    log.info(`Connecting to ${id}`)
    let connection = openConnection(id)
    if (!connection) {
      log.error('Could not connect to ${id}')
    }
}

function emitTemplate(name, date) {
    writer.emit("Name: ${name}, Date: ${date}",
        { name: name, date: date });
}

var globalVar = "global";

function foo() {
    log.error('globalVar = ${globalVar}');
}
log.error('globalVar = ${globalVar}');

function bar() {
    log.error('Something ${notInScope}');
}

function baz(x){
    log.error("${x}");
    log.error("${y}");
    log.error("${x} ");
    log.error("${y} ");
}


function foo1() {
    const aTemplateLitInScope = `Connecting to ${id}`;
    const name = 2;
    const date = 3;
    const foobar = 4;

    const data = {name: name, date: date};
    writer.emit("Name: ${name}, Date: ${date}.", data); // OK 

    writer.emit("Name: ${name}, Date: ${date}, ${foobar}", data); // NOT OK - `foobar` is not in `data`.     
}