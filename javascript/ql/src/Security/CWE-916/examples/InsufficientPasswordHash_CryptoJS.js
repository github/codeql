const crypto = require('crypto-js')
function hashPassword(email, password) {
  var algo = crypto.algo.SHA512.create()
  algo.update(password, 'utf-8') // BAD
  algo.update(email.toLowerCase(), 'utf-8')
  var hash = algo.finalize()
  return hash.toString(crypto.enc.Base64)
}