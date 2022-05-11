import ruby
import codeql.ruby.security.CryptoAlgorithms

query predicate weakHashingAlgorithms(HashingAlgorithm ha) { ha.isWeak() }

query predicate strongHashingAlgorithms(HashingAlgorithm ha) { not ha.isWeak() }

query predicate weakEncryptionAlgorithms(EncryptionAlgorithm ea) { ea.isWeak() }

query predicate strongEncryptionAlgorithms(EncryptionAlgorithm ea) { not ea.isWeak() }

query predicate weakPasswordHashingAlgorithms(PasswordHashingAlgorithm pha) { pha.isWeak() }

query predicate strongPasswordHashingAlgorithms(PasswordHashingAlgorithm pha) { not pha.isWeak() }
