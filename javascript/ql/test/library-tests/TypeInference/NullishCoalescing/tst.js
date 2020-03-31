(function() {
    var x = f()? undefined: f()? false: true;

    if (x || false) {
        v1 = x;
    } else {
        v2 = x;
    }

    if (x && false) {
        v3 = x;
    } else {
        v4 = x;
    }

    if (x ?? false) {
        v5 = x;
    } else {
        v6 = x;
    }

    v7 = x ?? {};
});
