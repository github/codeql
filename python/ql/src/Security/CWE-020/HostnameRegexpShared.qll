/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

// HostnameRegexp should be used directly from the shared regex pack, and not from this file.
deprecated private import semmle.python.security.regexp.HostnameRegex as Dep
import Dep
