import go
import semmle.go.security.SensitiveActions

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

from string password, boolean isDummy
where
  password = getASamplePassword() and
  if PasswordHeuristics::isDummyPassword(password) then isDummy = true else isDummy = false
select password, isDummy
