import cpp

/**
 * Determines if an element should be filtered (ignored)
 * from any result set.
 *
 * The current strategy is to determine if the element
 * resides in a path that appears to be a library (in particular openssl).
 *
 * It is therefore important that the element being examined represents
 * a use or configuration of cryptography in the user code.
 * E.g., if a global variable were defined in an OpenSSL library
 * representing a bad/vuln algorithm, and this global were assessed
 * it would appear to be ignorable, as it exists in a a filtered library.
 * The use of that global must be examined with this filter.
 *
 * ASSUMPTION/CAVEAT: note if an openssl library wraps a dangerous crypo use
 *    this filter approach will ignore the wrapper call, unless it is also flagged
 *    as dangerous. e.g., SomeWraper(){ ... <md5 use> ...}
 *    The wrapper if defined in openssl would result in ignoring
 *    the use of MD5 internally, since it's use is entirely in openssl.
 *
 *    TODO: these caveats need to be reassessed in the future.
 */
predicate isUseFiltered(Element e) {
  e.getFile().getAbsolutePath().toLowerCase().matches("%openssl%")
}

/**
 * Filtered only if both src and sink are considered filtered.
 *
 * This approach is meant to partially address some of the implications of
 * `isUseFiltered`. Specifically, if an algorithm is specified by a user
 * and some how passes to a user inside openssl, then this filter
 * would not ignore that the user was specifying the use of something dangerous.
 *
 * e.g., if a wrapper in openssl existed of the form SomeWrapper(string alg, ...){ ... <operation using alg> ...}
 * and the user did something like SomeWrapper("MD5", ...), this would not be ignored.
 *
 * The source in the above example would the algorithm, and the sink is the configuration sink
 * of the algorithm.
 */
predicate isSrcSinkFiltered(Element src, Element sink) {
  isUseFiltered(src) and isUseFiltered(sink)
}
