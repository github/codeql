(function () {
    var getF = function(){}
    var f = getF();
    (function () {
        f();
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
