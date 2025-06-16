import cpp

predicate isPossibleOpenSslFunction(Function f) {
  isPossibleOpenSslLocation(f.getADeclarationLocation())
}

predicate isPossibleOpenSslLocation(Location l) { l.toString().toLowerCase().matches("%openssl%") }
