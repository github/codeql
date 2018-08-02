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
