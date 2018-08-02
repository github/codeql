function outer(b) {
    // OK
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
    // OK
    var message = event.data;
    eme.init().then(() => NativeInfo.processApp('install', message.id));
}

function g() {
    // NOT OK
    let x = 23;
    {
        x = 42;
    }
}
