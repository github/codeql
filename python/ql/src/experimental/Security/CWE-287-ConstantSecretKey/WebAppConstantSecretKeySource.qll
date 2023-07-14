import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

/** A bad source for secret key in web app configurations. */
class WebAppConstantSecretKeySource extends DataFlow::Node {
  WebAppConstantSecretKeySource() {
    (
      // because Env return an Exeption if there isan't any value (instead of none) we should check whether
      // there is a default value of there is a config file which mostly these config files have a default value
      exists(API::Node env | env = API::moduleImport("environ").getMember("Env") |
        (
          // has default value
          exists(env.getKeywordParameter("SECRET_KEY").asSource())
          or
          // get value from a config file which is not best security practice
          exists(env.getReturn().getMember("read_env"))
        ) and
        this = env.getReturn().getReturn().asSource()
      )
      or
      this.asExpr().isConstant()
      or
      exists(API::Node cn |
        cn =
          [
            API::moduleImport("configparser")
                .getMember(["ConfigParser", "RawConfigParser"])
                .getReturn(),
            // legacy API https://docs.python.org/3/library/configparser.html#legacy-api-examples
            API::moduleImport("configparser")
                .getMember(["ConfigParser", "RawConfigParser"])
                .getReturn()
                .getMember("get")
                .getReturn()
          ] and
        this = cn.asSource()
      )
      or
      exists(API::CallNode cn |
        cn =
          [
            API::moduleImport("os").getMember("getenv").getACall(),
            API::moduleImport("os").getMember("environ").getMember("get").getACall()
          ] and
        (
          // this can be ideal if we assume that best security practice is that
          // we don't get SECRET_KEY from env and we always assign a secure generated random string to it
          cn.getNumArgument() = 1
          or
          cn.getNumArgument() = 2 and
          DataFlow::localFlow(any(DataFlow::Node n | n.asExpr().isConstant()), cn.getArg(1))
        ) and
        this.asExpr() = cn.asExpr()
      )
      or
      this = API::moduleImport("os").getMember("environ").getASubscript().asSource()
    ) and
    // followings will sanitize the get_random_secret_key of django.core.management.utils and similar random generators which we have their source code and some of them can be tracking by taint tracking because they are initilized by a constant!
    exists(this.getScope().getLocation().getFile().getRelativePath()) and
    not this.getScope().getLocation().getFile().inStdlib() and
    // special sanitize case for get_random_secret_key and django-environ
    not this.getScope().getLocation().getFile().getBaseName() = ["environ.py", "crypto.py"]
  }
}
