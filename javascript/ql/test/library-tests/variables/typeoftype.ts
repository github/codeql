function f() {
  var x: number
  function g() {
    var y: typeof x // should not capture x
  }
}
