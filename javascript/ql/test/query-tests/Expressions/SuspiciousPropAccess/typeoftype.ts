function f() {
  var y: typeof N.x // OK
  var z = N.x // NOT OK (currently missed due to const enum workaround)
  namespace N {
    export var x = 45
  }
}
