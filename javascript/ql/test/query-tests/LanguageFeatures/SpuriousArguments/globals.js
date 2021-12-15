function global() {return;}

(function(window) {
  window.global = function (x) {return;};
})(this);

global(x); // OK: might refer to function on line 4

function otherglobal() {return;}

var o = {
  otherglobal: function (x) {return;}
};

otherglobal(x); // NOT OK: can never refer to function on line 12
otherglobal.call(null, x); // NOT OK
otherglobal.call(null, x, y); // NOT OK
