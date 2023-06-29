import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking

/**
 * with using flask-session package, there is no jwt exists in cookies in user side
 * ```python
 *import os
 *from flask import Flask, session
 *app = Flask(__name__)
 * ```
 */
module FlaskConstantSecretKeyConfig {
  /**
   * `flask.Flask()`
   */
  API::Node flaskInstance() {
    result = API::moduleImport("flask").getMember("Flask").getASubclass*()
  }

  /**
   * Sources are Constants that without any Tainting reach the Sinks.
   * Also Sources can be the default value of getenv or similar methods
   * in a case that no value is assigned to Desired SECRET_KEY environment variable
   */
  predicate isSource(DataFlow::Node source) {
    (
      source.asExpr().isConstant()
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
        source = cn.asSource()
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
        source.asExpr() = cn.asExpr()
      )
      or
      source.asExpr() =
        API::moduleImport("os").getMember("environ").getASubscript().asSource().asExpr()
    ) and
    exists(source.getScope().getLocation().getFile().getRelativePath()) and
    not source.getScope().getLocation().getFile().inStdlib()
  }

  /**
   * Sinks are one of the following kinds, some of them are directly connected to a flask Instance like
   * ```python
   *    app.config['SECRET_KEY'] = 'CHANGEME1'
   *    app.secret_key = 'CHANGEME2'
   *    app.config.update(SECRET_KEY="CHANGEME3")
   *    app.config.from_mapping(SECRET_KEY="CHANGEME4")
   * ```
   * other Sinks are SECRET_KEY Constants Variables that are defined in seperate files or a class in those files like:
   * ```python
   *    app.config.from_pyfile("config.py")
   *    app.config.from_object('config.Config')
   *```
   * we find these files with `FromObjectFileName` DataFlow Configuration
   * note that "JWT_SECRET_KEY" is same as "SECRET_KEY" but it is belong to popular flask-jwt-extended library
   */
  predicate isSink(DataFlow::Node sink) {
    (
      exists(API::Node n | n = flaskInstance().getReturn() |
        sink =
          [
            n.getMember("config").getSubscript(["SECRET_KEY", "JWT_SECRET_KEY"]).asSink(),
            n.getMember("config")
                .getMember(["update", "from_mapping"])
                .getACall()
                .getArgByName(["SECRET_KEY", "JWT_SECRET_KEY"])
          ]
      )
      or
      exists(API::Node n, DataFlow::AttrWrite attr | n = flaskInstance() |
        attr.getObject().getALocalSource() = n.getACall() and
        attr.getAttributeName() = ["secret_key", "jwt_secret_key"] and
        sink = attr.getValue()
      )
      or
      exists(SecretKeyAssignStmt e |
        sink.asExpr() = e.getValue()
        //  | sameAsHardCodedConstantSanitizer(e.getTarget(0))
      )
    ) and
    exists(sink.getScope().getLocation().getFile().getRelativePath()) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }

  // for case check whether SECRECT_KEY is empty or not or whether it is == to a hardcoded constant value
  // i don't know why I can't reach from an expression to an If subExpression node
  predicate sameAsHardCodedConstantSanitizer(
    DataFlow::Node source, DataFlow::Node sink, SecretKeyAssignStmt e, If i
  ) {
    source.asExpr() = e.getTarget(0).getAChildNode() and
    // source.getLocation().toString().matches("%config3.py%")and
    DataFlow::localFlow(source, sink) and
    sink.asExpr() = i.getASubExpression().getAChildNode*().(Compare)
  }

  /**
   * Assignments like `SECRET_KEY = ConstantValue`
   * and `SECRET_KEY` file must be the Location that is specified in argument of `from_object` or `from_pyfile` methods
   */
  class SecretKeyAssignStmt extends AssignStmt {
    SecretKeyAssignStmt() {
      exists(string configFileName, string fileNamehelper, DataFlow::Node n1 |
        fileNamehelper = flaskConfiFileName(n1) and
        // because of `from_object` we want first part of `Config.AClassName` which `Config` is a python file name
        configFileName = fileNamehelper.splitAt(".") and
        // after spliting, don't look at %py% pattern
        configFileName != "py"
      |
        (
          if configFileName = "__name__"
          then
            this.getLocation().getFile().getShortName() =
              flaskInstance().asSource().getLocation().getFile().getShortName()
          else this.getLocation().getFile().getShortName().matches("%" + configFileName + "%")
        ) and
        this.getTarget(0).toString() = ["SECRET_KEY", "JWT_SECRET_KEY"]
      ) and
      exists(this.getScope().getLocation().getFile().getRelativePath()) and
      not this.getScope().getLocation().getFile().inStdlib()
    }
  }

  /**
   * A helper predicate that specify where the Flask `SECRET_KEY` variable location is defined.
   * In Flask we have config files that specify the location of `SECRET_KEY` variable initialization
   * and the name of these files are determined by
   * `app.config.from_pyfile("configFileName.py")`
   * or
   * `app.config.from_object("configFileName.ClassName")`
   */
  string flaskConfiFileName(API::CallNode cn) {
    exists(API::Node app |
      app = flaskInstance().getACall().getReturn() and
      cn = app.getMember("config").getMember(["from_object", "from_pyfile"]).getACall() and
      result =
        [
          cn.getParameter(0).getAValueReachingSink().asExpr().(StrConst).getText(),
          cn.getParameter(0).asSink().asExpr().(Name).getId()
        ]
    )
  }
}
