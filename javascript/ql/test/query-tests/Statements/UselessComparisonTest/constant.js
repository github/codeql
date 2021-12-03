function f() {
  if (1 > 2) {} else {} // NOT OK - always false
  if (1 > 0) {} else {} // NOT OK - always true
}
