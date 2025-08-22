import fs = require('fs')
import http = require('http')

export var mockFs : typeof fs = {}
export var mockRequest : typeof http.ServerRequest = {}

export function f() {
  let x = 4
  let y = 5 // $ Alert
  var t : typeof x = 20
  return t
}

