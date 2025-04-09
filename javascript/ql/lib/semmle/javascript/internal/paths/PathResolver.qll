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

  private int getNumPathSegment(string path) {
    result = strictcount(int n | exists(getPathSegment(path, n)))
  }

  private Container resolve(Container base, string path, int n) {
    shouldResolve(base, path) and n = 0 and result = base
    or
    exists(Container cur, string segment |
      cur = resolve(base, path, n - 1) and
      segment = getPathSegment(path, n - 1)
    |
      result = cur.(Folder).getChildContainer(segment)
      or
      result = getAnAdditionalChild(cur, segment)
      or
      segment = [".", ""] and
      result = cur
      or
      segment = ".." and
      result = cur.getParentContainer()
      or
      isOptionalPathComponent(segment) and
      not exists(cur.(Folder).getChildContainer(segment)) and
      not exists(getAnAdditionalChild(cur, segment)) and
      result = cur
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
