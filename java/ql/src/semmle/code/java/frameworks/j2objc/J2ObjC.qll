/**
 * Provides classes and predicates for working with OCNI (Objective-C Native Interface).
 */

import java

/**
 * An Objective-C Native Interface (OCNI) comment.
 */
class OCNIComment extends Javadoc {
  OCNIComment() {
    // The comment must start with `-[` ...
    getChild(0).getText().matches("-[%") and
    // ... and it must end with `]-`.
    getChild(getNumChild() - 1).getText().matches("%]-")
  }
}

/** Auxiliary predicate: `ocni` is an OCNI comment associated with method `m`. */
private predicate ocniComment(OCNIComment ocni, Method m) {
  // The associated callable must be marked as `native` ...
  m.isNative() and
  // ... and the comment has to be contained in `m`.
  ocni.getFile() = m.getFile() and
  ocni.getLocation().getStartLine() in [m.getLocation().getStartLine() .. m
          .getLocation()
          .getEndLine()]
}

/**
 * An Objective-C Native Interface (OCNI) comment that contains Objective-C code
 * implementing a native method.
 */
class OCNIMethodComment extends OCNIComment {
  OCNIMethodComment() { ocniComment(this, _) }

  /** Gets the method implemented by this comment. */
  Method getImplementedMethod() { ocniComment(this, result) }
}

/**
 * An Objective-C Native Interface (OCNI) native import comment.
 */
class OCNIImport extends OCNIComment {
  OCNIImport() {
    getAChild().getText().regexpMatch(".*#(import|include).*") and
    not exists(RefType rt | rt.getFile() = this.getFile() |
      rt.getLocation().getStartLine() < getLocation().getStartLine()
    )
  }
}
