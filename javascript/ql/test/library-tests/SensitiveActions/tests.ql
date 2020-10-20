import javascript
import semmle.javascript.security.SensitiveActions

query predicate cleartextPasswordExpr(CleartextPasswordExpr e) { any() }

string getASamplePassword() {
  result = "abcdefgh" or
  result = "sOKY6ccizpmvF*32so%Q" or
  result = "XXXXXXXX" or
  result = "example_password" or
  result = "change_me" or
  result = "" or
  result = "insert-auth-from-gui" or
  result = "admin" or
  result = "root"
}

query predicate dummyPasswords(string password, boolean isDummy) {
  password = getASamplePassword() and
  if PasswordHeuristics::isDummyPassword(password) then isDummy = true else isDummy = false
}

query predicate processTermination(NodeJSLib::ProcessTermination term) { any() }

query predicate sensitiveAction(SensitiveAction ac) { any() }

query predicate sensitiveExpr(SensitiveExpr e) { any() }
