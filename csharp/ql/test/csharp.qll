/**
 * The default C# QL library.
 */

import semmle.code.csharp.internal.csharp

private class FileAdjusted extends File {
  override predicate fromSource() {
    super.fromSource() and
    not this.getAbsolutePath().matches("%resources/stubs/%")
  }
}
