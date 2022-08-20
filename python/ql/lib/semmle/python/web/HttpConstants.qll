/** Gets an HTTP verb, in upper case */
deprecated string httpVerb() {
  result in ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"]
}

/** Gets an HTTP verb, in lower case */
deprecated string httpVerbLower() { result = httpVerb().toLowerCase() }
