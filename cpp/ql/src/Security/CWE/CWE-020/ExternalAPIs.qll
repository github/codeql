/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

private import cpp
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.models.interfaces.Taint
import ExternalAPIsSpecific

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { UntrustedDataToExternalApiFlow::flow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { UntrustedDataToExternalApiFlow::flow(result, this) }
}

/** An external API which is used with untrusted data. */
private newtype TExternalApi =
  /** An untrusted API method `m` where untrusted data is passed at `index`. */
  TExternalApiParameter(Function f, int index) {
    exists(UntrustedExternalApiDataNode n |
      f = n.getExternalFunction() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalApiUsedWithUntrustedData extends TExternalApi {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalApiDataNode getUntrustedDataNode() {
    this = TExternalApiParameter(result.getExternalFunction(), result.getIndex())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = strictcount(this.getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Function f, int index, string indexString |
      if index = -1 then indexString = "qualifier" else indexString = "param " + index
    |
      this = TExternalApiParameter(f, index) and
      result = f.toString() + " [" + indexString + "]"
    )
  }
}
