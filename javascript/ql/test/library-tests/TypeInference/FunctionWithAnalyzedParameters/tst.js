(function(){})();
(function(x){x})();
(function(x){x})(false);
(function(x){x})(true);
(function(x, y){x; y})(true, false);

(function() {
    function f1(){}
    f1();
    function f2(x){x}
    f2();
    function f3(x){x}
    f3(false);
    function f4(x){x}
    f4(true);
    function f5(x, y){x; y}
    f5(true, false);
});

(function(x, ... y){x; y})(true, false);
(function(x){x;})(... [true]);
(function(x){x; arguments.callee})(true);
(function(x){"use strict"; x; arguments.callee})(true);

(function(){}).call(undefined);
(function(x){x}).call(undefined);
(function(x){x}).call(undefined, false);
(function(x){x}).call(undefined, true);
(function(x, y){x; y}).call(undefined, true, false);

(function() {
    function f1(){}
    f1.call(undefined);
    function f2(x){x}
    f2.call(undefined);
    function f3(x){x}
    f3.call(undefined, false);
    function f4(x){x}
    f4.call(undefined, true);
    function f5(x, y){x; y}
    f5.call(undefined, true, false);
});
