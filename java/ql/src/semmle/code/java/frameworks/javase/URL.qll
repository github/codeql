import java
import semmle.code.java.dataflow.FlowSources

/* Am URL constructor expression */
class UrlConstructor extends ClassInstanceExpr {
  UrlConstructor() { this.getConstructor().getDeclaringType().getQualifiedName() = "java.net.URL" }

  Expr hostArg() {
    // URL(String spec)
    this.getNumArgument() = 1 and result = this.getArgument(0)
    or
    // URL(String protocol, String host, int port, String file)
    // URL(String protocol, String host, int port, String file, URLStreamHandler handler)
    this.getNumArgument() = [4,5] and result = this.getArgument(1)
    or
    // URL(String protocol, String host, String file)
    // but not
    // URL(URL context, String spec, URLStreamHandler handler)
    (
      this.getNumArgument() = 3 and
      this.getConstructor().getParameter(2).getType() instanceof TypeString
    ) and
    result = this.getArgument(1)
  }

  Expr protocolArg() {
    // In all cases except where the first parameter is a URL, the argument
    // containing the protocol is the first one, otherwise it is the second.
    if this.getConstructor().getParameter(0).getType().getName() = "URL"
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }
}

class UrlOpenStreamMethod extends Method {
  UrlOpenStreamMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openStream"
  }
}

class UrlOpenConnectionMethod extends Method {
  UrlOpenConnectionMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}
