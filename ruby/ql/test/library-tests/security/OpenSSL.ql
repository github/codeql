import codeql.ruby.AST
import codeql.ruby.security.OpenSSL

query predicate weakOpenSslCipherAlgorithms(OpenSslCipher c) { c.isWeak() }

query predicate strongOpenSslCipherAlgorithms(OpenSslCipher c) { not c.isWeak() }

query predicate missingOpenSslCipherAlgorithms(string name) {
  Ciphers::isOpenSslCipher(name) and
  not exists(OpenSslCipher c | c.getName() = name)
}
