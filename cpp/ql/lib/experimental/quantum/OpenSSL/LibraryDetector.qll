import cpp

predicate isPossibleOpenSSLFunction(Function f) {
  isPossibleOpenSSLLocation(f.getADeclarationLocation())
}

predicate isPossibleOpenSSLLocation(Location l) { l.toString().toLowerCase().matches("%openssl%") }
