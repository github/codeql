import ruby
import codeql.ruby.security.OpenSSL

query predicate weakOpenSSLCipherAlgorithms(OpenSSLCipher c) { c.isWeak() }

query predicate strongOpenSSLCipherAlgorithms(OpenSSLCipher c) { not c.isWeak() }

query predicate missingOpenSSLCipherAlgorithms(string name) {
  Ciphers::isOpenSSLCipher(name) and
  not exists(OpenSSLCipher c | c.getName() = name)
}
