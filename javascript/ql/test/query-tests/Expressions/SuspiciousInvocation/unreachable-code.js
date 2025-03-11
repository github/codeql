(function () {
    var getF = function(){}
    var f = getF();
    (function () {
        f(); // $ Alert
    });
});

(function () {
    var getF = unknown
    if (false) {
        var f = getF();
        (function () {
            f();
        });
    }
});
