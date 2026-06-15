function outer(b) {

    let addSubdomain = false;

    if (x) {
        addSubdomain = true;
    } else {
        addSubdomain = false;
    }

    return {
        inner: function () {
            return addSubdomain ? 23 : 42;
        }
    };
}

function f(event) {

    var message = event.data;
    eme.init().then(() => NativeInfo.processApp('install', message.id));
}

function g() {
    let x = 23; // $ Alert
    {
        x = 42; // $ Alert
    }
}
