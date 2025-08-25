function f() {
  var y: typeof N.x
  var z = N.x // $ MISSING: Alert - missed due to const enum workaround
  namespace N {
    export var x = 45
  }
}
