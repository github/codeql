/**
 * @name Query Sinks
 * @description List all query sinks found in the database. Query sinks are
 *              potential results depending on what data flows to them and
 *              other context.
 * @kind problem
 * @problem.severity info
 * @id swift/summary/query-sinks
 * @tags summary
 */

/*
 * Most queries compute data flow to one of the following sinks:
 *  - custom per-query sinks (listed by this query, `swift/summary/query-sinks`).
 *  - regular expression evaluation (see `swift/summary/regex-evals`).
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.PathInjectionQuery
import codeql.swift.security.UnsafeWebViewFetchQuery
import codeql.swift.security.SqlInjectionQuery
import codeql.swift.security.UnsafeJsEvalQuery
import codeql.swift.security.UncontrolledFormatStringQuery
import codeql.swift.security.StringLengthConflationQuery
import codeql.swift.security.ConstantPasswordQuery
import codeql.swift.security.CleartextStorageDatabaseQuery
import codeql.swift.security.CleartextTransmissionQuery
import codeql.swift.security.CleartextLoggingQuery
import codeql.swift.security.CleartextStoragePreferencesQuery
import codeql.swift.security.HardcodedEncryptionKeyQuery
import codeql.swift.security.ECBEncryptionQuery
import codeql.swift.security.WeakSensitiveDataHashingQuery as WeakSensitiveDataHashingQuery
import codeql.swift.security.WeakPasswordHashingQuery as WeakPasswordHashingQuery
import codeql.swift.security.XXEQuery
import codeql.swift.security.InsecureTLSQuery
import codeql.swift.security.ConstantSaltQuery
import codeql.swift.security.InsufficientHashIterationsQuery
import codeql.swift.security.PredicateInjectionQuery
import codeql.swift.security.StaticInitializationVectorQuery

string queryForSink(DataFlow::Node sink) {
  PathInjectionConfig::isSink(sink) and result = "swift/path-injection"
  or
  UnsafeWebViewFetchConfig::isSink(sink) and result = "swift/unsafe-webview-fetch"
  or
  SqlInjectionConfig::isSink(sink) and result = "swift/sql-injection"
  or
  UnsafeJsEvalConfig::isSink(sink) and result = "swift/unsafe-js-eval"
  or
  TaintedFormatConfig::isSink(sink) and result = "swift/uncontrolled-format-string"
  or
  StringLengthConflationConfig::isSink(sink) and result = "swift/string-length-conflation"
  or
  ConstantPasswordConfig::isSink(sink) and result = "swift/constant-password"
  or
  CleartextStorageDatabaseConfig::isSink(sink) and result = "swift/cleartext-storage-database"
  or
  CleartextTransmissionConfig::isSink(sink) and result = "swift/cleartext-transmission"
  or
  CleartextLoggingConfig::isSink(sink) and result = "swift/cleartext-logging"
  or
  CleartextStoragePreferencesConfig::isSink(sink) and result = "swift/cleartext-storage-preferences"
  or
  HardcodedKeyConfig::isSink(sink) and result = "swift/hardcoded-key"
  or
  EcbEncryptionConfig::isSink(sink) and result = "swift/ecb-encryption"
  or
  WeakSensitiveDataHashingQuery::WeakSensitiveDataHashingConfig::isSink(sink) and
  result = "swift/weak-sensitive-data-hashing"
  or
  WeakPasswordHashingQuery::WeakPasswordHashingConfig::isSink(sink) and
  result = "swift/weak-password-hashing"
  or
  XxeConfig::isSink(sink) and result = "swift/xxe"
  or
  InsecureTlsConfig::isSink(sink) and result = "swift/insecure-tls"
  or
  ConstantSaltConfig::isSink(sink) and result = "swift/constant-salt"
  or
  InsufficientHashIterationsConfig::isSink(sink) and result = "swift/insufficient-hash-iterations"
  or
  PredicateInjectionConfig::isSink(sink) and result = "swift/predicate-injection"
  or
  StaticInitializationVectorConfig::isSink(sink) and result = "swift/static-initialization-vector"
}

from DataFlow::Node n
select n, "Sink for " + queryForSink(n)
