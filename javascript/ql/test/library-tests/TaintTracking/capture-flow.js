import 'dummy';

function outerMost() {
    function outer() {
        var captured;
        function f(x) {
            captured = x;
        }
        f(source());

        return captured;
    }

    sink(outer()); // NOT OK

    return outer();
}

sink(outerMost()); // NOT OK

function confuse(x) {
    let captured;
    function f() {
        captured = x;
    }
    f();
    return captured;
}

sink(confuse('safe')); // OK
sink(confuse(source())); // NOT OK

function test3(param) {
    var x;
    function one() {
        x = param;
    }
    function two() {
        one();
        return x;
    }
    return two();
}

sink(test3(source())); // NOT OK
sink(test3("safe")); // OK

function test3a(param) {
    var x;
    function one() {
        x = param;
    }
    one();
    function two() {
        return x;
    }
    return two();
}

sink(test3a(source())); // NOT OK
sink(test3a("safe")); // OK

function test3b(param) {
    var x;
    function one() {
        x = param;
    }
    one();
    function two() {
        one();
        return x;
    }
    return two();
}

sink(test3b(source())); // NOT OK
sink(test3b("safe")); // OK

function test3c(param) {
    function one() {
        return param;
    }
    function two() {
        return one();
    }
    return two();
}

sink(test3c(source())); // NOT OK
sink(test3c("safe")); // OK

function test4() {
    var x = source();
    return () => x;
}
sink(test4()()); // NOT OK

function test5(x) {
    return () => x;
}
sink(test5(source())()); // NOT OK
sink(test5("safe")()); // OK

function testEscape(x) {
    function escapingFunction() {
        sink(x); // NOT OK
    }
    global.doEscape(escapingFunction);
}
testEscape(source());

function testEscapeViaReturn(x) {
    function escapingFunction() {
        sink(x); // NOT OK
    }
    return escapingFunction;
}
global.doEscape(testEscapeViaReturn(source()));

function ordering() {
    var orderingTaint;
    global.addEventListener('click', () => {
        sink(orderingTaint); // NOT OK [INCONSISTENCY]
    });
    global.addEventListener('load', () => {
        orderingTaint = source();
    });
    global.addEventListener('click', () => {
        sink(orderingTaint); // NOT OK
    });
}
ordering();

function makeSafe(x) {
    console.log(x);
    return "safe";
}
function flowSensitiveParamUpdate(x) {
    x = makeSafe(x);
    function captureX() {
        console.log(x);
    }
    captureX();
    sink(x); // OK
}
flowSensitiveParamUpdate(source());

function flowSensitiveLocalUpdate() {
    let x = source();
    x = makeSafe(x);
    function captureX() {
        console.log(x);
    }
    captureX();
    sink(x); // OK
}
flowSensitiveLocalUpdate();

function flowSensitiveLocalIncrement() {
    let x = source();
    ++x;
    function captureX() {
        console.log(x);
    }
    captureX();
    sink(x); // OK
}
flowSensitiveLocalIncrement();

function destructuredVarDecl(param) {
    let { x } = param;
    function inner() {
        sink(x); // NOT OK
    }
    inner();
}
destructuredVarDecl({ x: source() });

function destructuredLocalAssignment(param) {
    let x;
    ({ x } = param);
    function inner() {
        sink(x); // NOT OK
    }
    inner();
}
destructuredLocalAssignment({ x: source() });

function destructuredParam({ x }) {
    function inner() {
        sink(x); // NOT OK
    }
    inner();
}
destructuredParam({ x: source() });

function destructuredLoop(data) {
    for (let { x } of data) {
        function inner() {
            sink(x); // NOT OK
        }
        inner();
    }
}
destructuredLoop([{ x: source() }]);


function testPromise(arg) {
    function transform(x) {
        return { prop: x };
    }
    class Foo {
        updatePrVisibility(y) {
            const { prop: variable } = transform(y);
            this.exists(variable).then(() => {
                transform(variable);
            });
        }
        exists(fileOrDir) {
            return new Promise(resolve => fs.sink(fileOrDir, err => resolve(!err))); // NOT OK
        }
    }
    new Foo().updatePrVisibility(arg);
}
testPromise(source());

function sinkInner() {
    var x = "safe";
    console.log(x);
    x = source();
    console.log(x);
    function inner() {
        sink(x); // NOT OK
    }
    inner();
}
sinkInner();

function testObjectWithMethods(taint) {
    const objectWithMethods = {
        field: taint,
        arrowFunction: () => {
            sink(objectWithMethods.field); // NOT OK
            sink(this.field); // OK - refers to outer 'this'
        },
        regularFunction() {
            sink(objectWithMethods.field); // NOT OK
            sink(this.field); // NOT OK
        },
    };
    objectWithMethods.functionAddedLater = function() {
        sink(objectWithMethods.field); // NOT OK
        sink(this.field); // NOT OK
    };
    objectWithMethods.arrowFunction();
    objectWithMethods.regularFunction();
    objectWithMethods.functionAddedLater();
}
testObjectWithMethods(source());

function captureThis() {
    this.foo = source();
    window.addEventListener('click', () => {
        sink(this.foo); // NOT OK
    });
}

function CaptureThisWithoutJump(x) {
    [1].forEach(() => {
        this.foo = x;
    });
    sink(this.foo); // NOT OK
}
sink(new CaptureThisWithoutJump(source()).foo); // NOT OK
sink(new CaptureThisWithoutJump('safe').foo); // OK

function CaptureThisWithoutJump2(x) {
    this.foo = x;
    let y;
    [1].forEach(() => y = this.foo);
    return y;
}
sink(new CaptureThisWithoutJump2(source()).foo); // NOT OK
sink(new CaptureThisWithoutJump2('safe').foo); // OK
