import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

/** A bad source for secret key in web app configurations. */
class WebAppConstantSecretKeySource extends DataFlow::Node {
  WebAppConstantSecretKeySource() {
    (
      // we should check whether there is a default value or not
      exists(API::Node env |
        env = API::moduleImport("environ").getMember("Env") and
        // has default value
        exists(API::Node param | param = env.getKeywordParameter("SECRET_KEY") |
          param.asSink().asExpr().getASubExpression*() instanceof StringLiteral
        ) and
        this = env.getReturn().getReturn().asSource()
      )
      or
      this.asExpr() instanceof StringLiteral
      or
      exists(API::CallNode cn |
        cn =
          [
            API::moduleImport("os").getMember("getenv").getACall(),
            API::moduleImport("os").getMember("environ").getMember("get").getACall()
          ] and
        cn.getNumArgument() = 2 and
        DataFlow::localFlow(any(DataFlow::Node n | n.asExpr() instanceof StringLiteral),
          cn.getArg(1)) and
        this.asExpr() = cn.asExpr()
      )
    ) and
    // followings will sanitize the get_random_secret_key of django.core.management.utils and similar random generators which we have their source code and some of them can be tracking by taint tracking because they are initilized by a constant!
    exists(this.getScope().getLocation().getFile().getRelativePath()) and
    not this.getScope().getLocation().getFile().inStdlib() and
    // special sanitize case for get_random_secret_key and django-environ
    not this.getScope().getLocation().getFile().getBaseName() = ["environ.py", "crypto.py"]
  }
}
