const lib = require('something');

function f() {
    this.two(); /** use=moduleImport("something").getMember("exports").getMember("one").getMember("two").getReturn() */
}

f.call(lib.one);
