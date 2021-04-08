/** Gets an http verb */
string httpVerb() {
  result = "GET" or
  result = "POST" or
  result = "PUT" or
  result = "PATCH" or
  result = "DELETE" or
  result = "OPTIONS" or
  result = "HEAD"
}

/** Gets an http verb, in lower case */
string httpVerbLower() { result = httpVerb().toLowerCase() }
