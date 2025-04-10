private import javascript

/**
 * Signature for modules to pass to `PathResolver`.
 */
signature module PathResolverSig {
  /**
   * Holds if `path` should be resolved to a file or folder, relative to `base`.
   */
  predicate shouldResolve(Container base, string path);

  /**
   * Gets an additional file or folder to consider a child of `base`.
   */
  default Container getAnAdditionalChild(Container base, string name) { none() }

  /**
   * Holds if `component` may be treated as `.` if it does not match a child.
   */
  default predicate isOptionalPathComponent(string component) { none() }

  /**
   * Holds if globs should be interpreted in the paths being resolved.
   *
   * The following types of globs are supported:
   * - `*` (matches any child)
   * - `**` (matches any child recursively)
   * - Complex patterns like `foo-*.txt` are also supported
   */
  default predicate allowGlobs() { none() }
}

/**
 * Provides a mechanism for resolving file paths relative to a given directory.
 */
module PathResolver<PathResolverSig Config> {
  private import Config

  private string getPathSegment(string path, int n) {
    shouldResolve(_, path) and
    result = path.replaceAll("\\", "/").splitAt("/", n)
  }

  pragma[nomagic]
  private string getPathSegmentAsGlobRegexp(string segment) {
    allowGlobs() and
    segment = getPathSegment(_, _) and
    segment.matches("%*%") and
    not segment = ["*", "**"] and // these are special-cased
    result = segment.regexpReplaceAll("[^a-zA-Z0-9*]", "\\\\$0").replaceAll("*", ".*")
  }

  private int getNumPathSegment(string path) {
    result = strictcount(int n | exists(getPathSegment(path, n)))
  }

  private Container getChild(Container base, string name) {
    result = base.(Folder).getChildContainer(name)
    or
    result = getAnAdditionalChild(base, name)
  }

  private Container resolve(Container base, string path, int n) {
    shouldResolve(base, path) and n = 0 and result = base
    or
    exists(Container current, string segment |
      current = resolve(base, path, n - 1) and
      segment = getPathSegment(path, n - 1)
    |
      result = getChild(current, segment)
      or
      segment = [".", ""] and
      result = current
      or
      segment = ".." and
      result = current.getParentContainer()
      or
      isOptionalPathComponent(segment) and
      not exists(getChild(current, segment)) and
      result = current
      or
      allowGlobs() and
      (
        segment = "*" and
        result = getChild(current, _)
        or
        segment = "**" and // allow empty match
        result = current
        or
        exists(string name |
          result = getChild(current, name) and
          name.regexpMatch(getPathSegmentAsGlobRegexp(segment))
        )
      )
    )
    or
    exists(Container current, string segment |
      current = resolve(base, path, n) and
      segment = getPathSegment(path, n)
    |
      // Follow child without advancing 'n'
      allowGlobs() and
      segment = "**" and
      result = getChild(current, _)
    )
  }

  /**
   * Gets the file or folder that `path` resolves to when resolved from `base`.
   *
   * Only has results for the `(base, path)` pairs provided by `shouldResolve`
   * in the instantiation of this module.
   */
  Container resolve(Container base, string path) {
    result = resolve(base, path, getNumPathSegment(path))
  }
}
