import 'dummy';

function barrierIn() {
    var sourceVariable = 123;
    SINK(sourceVariable); // NOT OK

    flowWithSourceParam(sourceVariable);
}

function barrierInParameter(sourceVariable) {
    SINK(sourceVariable); // NOT OK, but only report the parameter as the source
}

function barrierOut() {
    let taint = SOURCE();
    taint = "<sink>" + taint + "</sink>"; // NOT OK
    taint = "<sink>" + taint + "</sink>"; // OK - only report first instance
}
