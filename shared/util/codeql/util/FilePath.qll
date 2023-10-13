/** Provides a utility for normalizing filepaths. */

/**
 * A filepath that should be normalized.
 * Extend to provide additional strings that should be normalized as filepaths.
 */
abstract class NormalizableFilepath extends string {
  bindingset[this]
  NormalizableFilepath() { any() }

  private string getComponent(int i) { result = this.splitAt("/", i) }

  private int getNumComponents() { result = strictcount(int i | exists(this.getComponent(i))) }

  /** count .. segments in prefix in normalization from index i */
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

  /** count non-.. segments in postfix in normalization from index 0 to i-1 */
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

  /** Gets the normalized filepath for this string; traversing `/../` paths. */
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
