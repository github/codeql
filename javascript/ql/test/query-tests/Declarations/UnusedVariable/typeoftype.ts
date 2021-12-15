import fs = require('fs') // OK
import http = require('http') // OK

export var mockFs : typeof fs = {}
export var mockRequest : typeof http.ServerRequest = {}

export function f() {
  let x = 4 // OK
  let y = 5 // NOT OK
  var t : typeof x = 20
  return t
}

