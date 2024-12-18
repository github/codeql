/**
 * Provides classes and predicates for working with OCNI (Objective-C Native Interface).
 */

import java

/**
 * An Objective-C Native Interface (OCNI) comment.
 */
class OcniComment extends Javadoc {
  OcniComment() {
    // The comment must start with `-[` ...
    this.getChild(0).getText().matches("-[%") and
    // ... and it must end with `]-`.
    this.getChild(this.getNumChild() - 1).getText().matches("%]-")
  }
}

/** Auxiliary predicate: `ocni` is an OCNI comment associated with method `m`. */
private predicate ocniComment(OcniComment ocni, Method m) {
  // The associated callable must be marked as `native` ...
  m.isNative() and
  // ... and the comment has to be contained in `m`.
  ocni.getFile() = m.getFile() and
  ocni.getLocation().getStartLine() in [m.getLocation().getStartLine() .. m.getLocation()
          .getEndLine()]
}

/**
 * An Objective-C Native Interface (OCNI) comment that contains Objective-C code
 * implementing a native method.
 */
class OcniMethodComment extends OcniComment {
  OcniMethodComment() { ocniComment(this, _) }

  /** Gets the method implemented by this comment. */
  Method getImplementedMethod() { ocniComment(this, result) }
}

/**
 * An Objective-C Native Interface (OCNI) native import comment.
 */
class OcniImport extends OcniComment {
  OcniImport() {
    this.getAChild().getText().regexpMatch(".*#(import|include).*") and
    not exists(RefType rt | rt.getFile() = this.getFile() |
      rt.getLocation().getStartLine() < this.getLocation().getStartLine()
    )
  }
}
