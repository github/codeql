import java
import semmle.code.java.dataflow.FlowSources

/** Any expresion or call which returns a new URI.*/
abstract class UriCreation extends Top {
  /**
   * Returns the host of the newly created URI.
   *  In the case where the host is specified separately, this returns only the host.
   *  In the case where the uri is parsed from an input string,
   *  such as in `URI(`http://foo.com/mypath')`,
   *  this returns the entire argument passed i.e. `http://foo.com/mypath'.
   */

  abstract Expr hostArg();
}

/** An URI constructor expression */
class UriConstructor extends ClassInstanceExpr, UriCreation {
  UriConstructor() { this.getConstructor().getDeclaringType().getQualifiedName() = "java.net.URI" }

  override Expr hostArg() {
    // URI​(String str)
    result = this.getArgument(0) and this.getNumArgument() = 1
    or
    // URI(String scheme, String ssp, String fragment)
    // URI​(String scheme, String host, String path, String fragment)
    // URI​(String scheme, String authority, String path, String query, String fragment)
    result = this.getArgument(1) and this.getNumArgument() = [3, 4, 5]
    or
    // URI​(String scheme, String userInfo, String host, int port, String path, String query,
    //    String fragment)
    result = this.getArgument(2) and this.getNumArgument() = 7
  }
}

class UriCreate extends Call, UriCreation {
  UriCreate() {
    this.getCallee().getName() = "create" and
    this.getCallee().getDeclaringType() instanceof TypeUri
  }

  override Expr hostArg() { result = this.getArgument(0) }
}
