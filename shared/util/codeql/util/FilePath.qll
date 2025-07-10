/** Provides a utility for normalizing filepaths. */

/**
 * A filepath that should be normalized.
 *
 * Extend to provide additional strings that should be normalized as filepaths.
 */
abstract class NormalizableFilepath extends string {
  bindingset[this]
  NormalizableFilepath() { any() }

  /** Gets the `i`th path component of this string. */
  private string getComponent(int i) { result = this.splitAt("/", i) }

  /** Gets the number of path components of thi string. */
  private int getNumComponents() { result = strictcount(int i | exists(this.getComponent(i))) }

  /** In the normalized path starting from component `i`, counts the number of `..` segments that path starts with. */
  private int dotdotCountFrom(int i) {
    result = 0 and i = this.getNumComponents()
    or
    exists(string c | c = this.getComponent(i) |
      if c = ""
      then result = this.dotdotCountFrom(i + 1)
      else
        if c = "."
        then result = this.dotdotCountFrom(i + 1)
        else
          if c = ".."
          then result = this.dotdotCountFrom(i + 1) + 1
          else result = (this.dotdotCountFrom(i + 1) - 1).maximum(0)
    )
  }

  /** In the normalized path up to (excluding) component `i`, counts the number of non-`..` segments that path ends with. */
  private int segmentCountUntil(int i) {
    result = 0 and i = 0
    or
    exists(string c | c = this.getComponent(i - 1) |
      if c = ""
      then result = this.segmentCountUntil(i - 1)
      else
        if c = "."
        then result = this.segmentCountUntil(i - 1)
        else
          if c = ".."
          then result = (this.segmentCountUntil(i - 1) - 1).maximum(0)
          else result = this.segmentCountUntil(i - 1) + 1
    )
  }

  /** Gets the `i`th component if that component should be included in the normalized path. */
  private string part(int i) {
    result = this.getComponent(i) and
    result != "." and
    if result = ""
    then i = 0
    else (
      result != ".." and
      0 = this.dotdotCountFrom(i + 1)
      or
      result = ".." and
      0 = this.segmentCountUntil(i)
    )
  }

  /**
   * Gets the normalized filepath for this string.
   *
   * Normalizes `..` paths, `.` paths, and multiple `/`s as much as possible, but does not normalize case, resolve symlinks, or make relative paths absolute.
   *
   * The normalized path will be absolute (begin with `/`) if and only if the original path is.
   *
   * The normalized path will not have a trailing `/`.
   *
   * Only `/` is treated as a path separator.
   */
  string getNormalizedPath() {
    exists(string norm | norm = concat(string s, int i | s = this.part(i) | s, "/" order by i) |
      if norm != ""
      then result = norm
      else
        if this.matches("/%")
        then result = "/"
        else result = "."
    )
  }
}
