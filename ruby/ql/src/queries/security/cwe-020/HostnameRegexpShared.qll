/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

// HostnameRegexp should be used directly from the shared regex pack, and not from this file.
deprecated import codeql.ruby.security.regexp.HostnameRegexp as Dep
import Dep
