// use NS from another file, that doesn't truly assign to it
(function(ns) {
  ns.foo.bar; // 'NS.foo.bar'
})(NS = NS || {});

Conflict = {}; // assigned in multiple files
