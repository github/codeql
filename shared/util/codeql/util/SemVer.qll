/**
 * Provides logic for working SemVer (Semantic Versioning).
 */
overlay[local?]
module;

bindingset[str]
private string leftPad(string str) { result = ("0000" + str).suffix(str.length()) }

/**
 * Gets the major number of a SemVer string.
 */
bindingset[s]
string getMajor(string s) { result = s.regexpCapture("v?(\\d+).*", 1) }

/**
 * Gets the minor number of a SemVer string.
 */
bindingset[s]
string getMinor(string s) { result = s.regexpCapture("v?(\\d+)\\.(\\d+).*", 2) }

/**
 * Gets the patch number of a SemVer string.
 */
bindingset[s]
string getPatch(string s) { result = s.regexpCapture("v?(\\d+)\\.(\\d+)\\.(\\d+).*", 3) }

/**
 * Normalizes a SemVer string such that the lexicographical ordering
 * of two normalized strings is consistent with the SemVer ordering.
 *
 * Pre-release information and build metadata is not yet supported.
 */
bindingset[orig]
string padSemVer(string orig, string major, string minor, string patch) {
  major = getMajor(orig) and
  (
    minor = getMinor(orig)
    or
    not exists(getMinor(orig)) and minor = "0"
  ) and
  (
    patch = getPatch(orig)
    or
    not exists(getPatch(orig)) and patch = "0"
  ) and
  result = leftPad(major) + "." + leftPad(minor) + "." + leftPad(patch)
}

/**
 * Normalizes a SemVer string such that the lexicographical ordering
 * of two normalized strings is consistent with the SemVer ordering.
 *
 * Pre-release information and build metadata is not yet supported.
 */
bindingset[orig]
string padSemVer(string orig) { result = padSemVer(orig, _, _, _) }
