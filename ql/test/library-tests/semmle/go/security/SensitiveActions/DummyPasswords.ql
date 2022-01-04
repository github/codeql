import go
import semmle.go.security.SensitiveActions

string getASamplePassword() {
  result =
    [
      "abcdefgh", "sOKY6ccizpmvF*32so%Q", "XXXXXXXX", "example_password", "change_me", "",
      "insert-auth-from-gui", "admin", "root"
    ]
}

from string password, boolean isDummy
where
  password = getASamplePassword() and
  if PasswordHeuristics::isDummyPassword(password) then isDummy = true else isDummy = false
select password, isDummy
