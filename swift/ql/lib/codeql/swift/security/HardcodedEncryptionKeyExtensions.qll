/**
 * Provides classes and predicates for reasoning about hard-coded encryption
 * key vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for hard-coded encryption key vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as a key.
 */
abstract class HardcodedEncryptionKeySink extends DataFlow::Node { }

/**
 * A barrier for hard-coded encryption key vulnerabilities.
 */
abstract class HardcodedEncryptionKeyBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class HardcodedEncryptionKeyAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to hard-coded encryption key vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink for the CryptoSwift library.
 */
private class CryptoSwiftEncryptionKeySink extends HardcodedEncryptionKeySink {
  CryptoSwiftEncryptionKeySink() {
    // `key` arg in `init` is a sink
    exists(NominalTypeDecl c, Initializer f, CallExpr call |
      c.getName() = ["AES", "HMAC", "ChaCha20", "CBCMAC", "CMAC", "Poly1305", "Blowfish", "Rabbit"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("key").getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink for the RNCryptor library.
 */
private class RnCryptorEncryptionKeySink extends HardcodedEncryptionKeySink {
  RnCryptorEncryptionKeySink() {
    exists(NominalTypeDecl c, Method f, CallExpr call |
      c.getFullName() =
        [
          "RNCryptor", "RNEncryptor", "RNDecryptor", "RNCryptor.EncryptorV3",
          "RNCryptor.DecryptorV3"
        ] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["encryptionKey", "withEncryptionKey", "hmacKey"]).getExpr() =
        this.asExpr()
    )
  }
}

private class EncryptionKeySinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Realm database library.
        ";Realm.Configuration;true;init(fileURL:inMemoryIdentifier:syncConfiguration:encryptionKey:readOnly:schemaVersion:migrationBlock:deleteRealmIfMigrationNeeded:shouldCompactOnLaunch:objectTypes:);;;Argument[3];encryption-key",
        ";Realm.Configuration;true;init(fileURL:inMemoryIdentifier:syncConfiguration:encryptionKey:readOnly:schemaVersion:migrationBlock:deleteRealmIfMigrationNeeded:shouldCompactOnLaunch:objectTypes:seedFilePath:);;;Argument[3];encryption-key",
        ";Realm.Configuration;true;encryptionKey;;;PostUpdate;encryption-key",
        // sqlite3 C API (Encryption Extension)
        ";;false;sqlite3_key(_:_:_:);;;Argument[1];encryption-key",
        ";;false;sqlite3_rekey(_:_:_:);;;Argument[1];encryption-key",
        ";;false;sqlite3_key_v2(_:_:_:_:);;;Argument[2];encryption-key",
        ";;false;sqlite3_rekey_v2(_:_:_:_:);;;Argument[2];encryption-key",
        // SQLite.swift
        ";Connection;true;key(_:db:);;;Argument[0];encryption-key",
        ";Connection;true;keyAndMigrate(_:db:);;;Argument[0];encryption-key",
        ";Connection;true;rekey(_:db:);;;Argument[0];encryption-key",
        ";Connection;true;sqlcipher_export(_:key:);;;Argument[1];encryption-key",
        // GRDB
        ";Database;true;usePassphrase(_:);;;Argument[0];encryption-key",
        ";Database;true;changePassphrase(_:);;;Argument[0];encryption-key",
      ]
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultEncryptionKeySink extends HardcodedEncryptionKeySink {
  DefaultEncryptionKeySink() { sinkNode(this, "encryption-key") }
}
