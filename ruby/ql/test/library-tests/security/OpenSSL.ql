import ruby
import codeql.ruby.security.OpenSSL

query predicate weakOpenSSLCipherAlgorithms(OpenSSLCipher c) { c.isWeak() }

query predicate strongOpenSSLCipherAlgorithms(OpenSSLCipher c) { not c.isWeak() }
