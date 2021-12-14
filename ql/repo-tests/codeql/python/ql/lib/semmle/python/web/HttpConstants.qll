/** Gets an HTTP verb, in upper case */
string httpVerb() { result in ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"] }

/** Gets an HTTP verb, in lower case */
string httpVerbLower() { result = httpVerb().toLowerCase() }
