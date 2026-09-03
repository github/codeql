/**
 * Provides logic for working SemVer (Semantic Versioning).
 */
overlay[local?]
module;

bindingset[str]
private string leftPad(string str) { result = ("0000" + str).suffix(str.length()) }

/**
 * Normalizes a SemVer string such that the lexicographical ordering
 * of two normalized strings is consistent with the SemVer ordering.
 *
 * Pre-release information and build metadata is not yet supported.
 */
bindingset[orig]
string normalizeSemVer(string orig) {
  exists(string pattern, string major, string minor, string patch |
    pattern = "v?(\\d+)\\.(\\d+)\\.(\\d+)(\\D.*)?" and
    major = orig.regexpCapture(pattern, 1) and
    minor = orig.regexpCapture(pattern, 2) and
    patch = orig.regexpCapture(pattern, 3)
  |
    result = leftPad(major) + "." + leftPad(minor) + "." + leftPad(patch)
  )
}
