(function() {
    var obj1 = { custom: false, trackProps: false };
    var obj2 = { custom: false, trackProps: true };
    var obj3 = { custom: true, trackProps: false };
    var obj4 = { custom: true, trackProps: true };

    var result;
    if (x1) {
        result = obj1;
    }
    if (x2) {
        result = obj2;
    }
    if (x3) {
        result = obj3;
    }
    if (x4) {
        result = obj4;
    }

    result;
})();
