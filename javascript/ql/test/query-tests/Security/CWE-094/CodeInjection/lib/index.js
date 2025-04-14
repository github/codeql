export function unsafeDeserialize(data) { // $ Source[js/unsafe-code-construction]
  return eval("(" + data + ")"); // $ Alert[js/unsafe-code-construction]
}

export function unsafeGetter(obj, name) { // $ Source[js/unsafe-code-construction]
    return eval("obj." + name); // $ Alert[js/unsafe-code-construction]
}

export function safeAssignment(obj, value) {
    eval("obj.foo = " + JSON.stringify(value));
}

global.unsafeDeserialize = function (data) { // $ Source[js/unsafe-code-construction]
  return eval("(" + data + ")"); // $ Alert[js/unsafe-code-construction]
}

const matter = require("gray-matter");

export function greySink(data) { // $ Source[js/unsafe-code-construction]
    const str = `
    ---js
    ${data /* $ Alert[js/unsafe-code-construction] */}
    ---
    `
    const res = matter(str);
    console.log(res);

    matter(str, {
        engines: {
            js: function (data) {
                console.log("NOPE");
            }
        }
    });
}

function codeIsAlive() {
  new Template().compile();
}

export function Template(text, opts) {
  opts = opts || {};
  var options = {};
  options.varName = opts.varName;
  this.opts = options;
}

Template.prototype = {
  compile: function () {
    var opts = this.opts;
    eval("  var " + opts.varName + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
  },
  // The below are justs tests that ensure the global-access-path computations terminate.
  pathsTerminate1: function (node, prev) {
    node.tree = {
      ancestor: node,
      number: rand ? prev.tree.number + 1 : 0,
    };
  },
  pathsTerminate2: function (A) {
    try {
      var B = A.p1;
      var C = B.p2;
      C.p5 = C;
    } catch (ex) {}
  },
  pathsTerminate3: function (A) {
    var x = foo();
    while (Math.random()) {
      x.r = x;
    }
  },
  pathsTerminate4: function () {
    var dest = foo();
    var range = foo();
    while (Math.random() < 0.5) {
      range.tabstop = dest;
      if (Math.random() < 0.5) {
        dest.firstNonLinked = range;
      }
    }
  },
};

export class AccessPathClass {
  constructor(taint) {
    this.taint = taint;

    var options1 = {taintedOption: taint};
    this.options1 = options1;

    var options2;
    options2 = {taintedOption: taint};
    this.options2 = options2;

    var options3;
    options3 = {};
    options3.taintedOption = taint;
    this.options3 = options3;
  }

  doesTaint() {
    eval("  var " + this.options1.taintedOption + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
    eval("  var " + this.options2.taintedOption + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
    eval("  var " + this.options3.taintedOption + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
    eval("  var " + this.taint + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
  }
}


export class AccessPathClassBB {
    constructor(taint) {
      this.taint = taint;
  
      var options1 = {taintedOption: taint};
      if (Math.random() < 0.5) { console.log("foo"); }
      this.options1 = options1;
  
      var options2;
      if (Math.random() < 0.5) { console.log("foo"); }
      options2 = {taintedOption: taint};
      if (Math.random() < 0.5) { console.log("foo"); }
      this.options2 = options2;
  
      var options3;
      if (Math.random() < 0.5) { console.log("foo"); }
      options3 = {};
      if (Math.random() < 0.5) { console.log("foo"); }
      options3.taintedOption = taint;
      if (Math.random() < 0.5) { console.log("foo"); }
      this.options3 = options3;
    }
  
    doesTaint() {
      eval("  var " + this.options1.taintedOption + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
      eval("  var " + this.options2.taintedOption + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
      eval("  var " + this.options3.taintedOption + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
      eval("  var " + this.taint + " = something();"); // $ MISSING: Alert - due to lack of localFieldStep
    }
  }
  