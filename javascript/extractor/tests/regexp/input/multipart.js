var reg = new RegExp("foo" + "bar");

var reg2 = new RegExp("foo"
    + "bar");

var reg3 = new RegExp(
    "foo" + "bar");

var reg4 = new RegExp(
    "foo" + 
    "bar" + 
    "baz" + 
    "qux"
);

var bad95 = new RegExp(
    "(a" + 
    "|" + 
    "aa)*" + 
    "b$"
);

var bad96 = new RegExp("(" + 
    "(c|cc)*|" + 
    "(d|dd)*|" +
    "(e|ee)*" +
")f$");

var bad97 = new RegExp(
    "(g|gg" + 
    ")*h$");
