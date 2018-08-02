function global() {}

(function(window) {
  window.global = function (x) {};
})(this);

global(x); // OK: might refer to function on line 4

function otherglobal() {}

var o = {
  otherglobal: function (x) {}
};

otherglobal(x); // NOT OK: can never refer to function on line 12