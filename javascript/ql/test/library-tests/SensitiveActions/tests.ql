import javascript
import semmle.javascript.security.SensitiveActions

query predicate cleartextPasswordExpr(CleartextPasswordExpr e) { any() }

string getASamplePassword() {
  result =
    [
      "hgfedcba", "abcdefgh", "sOKY6ccizpmvF*32so%Q", "XXXXXXXX", "example_password", "change_me",
      "", "insert-auth-from-gui", "admin", "root"
    ]
}

query predicate dummyPasswords(string password, boolean isDummy) {
  password = getASamplePassword() and
  if PasswordHeuristics::isDummyPassword(password) then isDummy = true else isDummy = false
}

query predicate processTermination(NodeJSLib::ProcessTermination term) { any() }

query predicate sensitiveAction(SensitiveAction ac) { any() }

query predicate sensitiveExpr(SensitiveExpr e) { any() }
