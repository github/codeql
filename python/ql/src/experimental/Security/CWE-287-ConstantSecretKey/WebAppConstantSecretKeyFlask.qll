import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import WebAppConstantSecretKeySource

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
  predicate isSource(DataFlow::Node source) { source instanceof WebAppConstantSecretKeySource }

  /**
   * Sinks are one of the following kinds, some of them are directly connected to a flask Instance like
   * ```python
   *    app.config['SECRET_KEY'] = 'CHANGEME1'
   *    app.secret_key = 'CHANGEME2'
   *    app.config.update(SECRET_KEY="CHANGEME3")
   *    app.config.from_mapping(SECRET_KEY="CHANGEME4")
   * ```
   * other Sinks are SECRET_KEY Constants Variables that are defined in separate files or a class in those files like:
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
      exists(DataFlow::AttrWrite attr |
        attr.getObject().getALocalSource() = flaskInstance().getACall() and
        attr.getAttributeName() = ["secret_key", "jwt_secret_key"] and
        sink = attr.getValue()
      )
      or
      exists(SecretKeyAssignStmt e | sink.asExpr() = e.getValue())
    ) and
    exists(sink.getScope().getLocation().getFile().getRelativePath()) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }

  /**
   * An Assignments like `SECRET_KEY = ConstantValue`
   * and `SECRET_KEY` file must be the Location that is specified in argument of `from_object` or `from_pyfile` methods
   */
  class SecretKeyAssignStmt extends AssignStmt {
    SecretKeyAssignStmt() {
      exists(string configFileName, string fileNamehelper, DataFlow::Node n1, File file |
        fileNamehelper = [flaskConfiFileName(n1), flaskConfiFileName2(n1)] and
        // because of `from_object` we want first part of `Config.AClassName` which `Config` is a python file name
        configFileName = fileNamehelper.splitAt(".") and
        file = this.getLocation().getFile()
      |
        (
          if fileNamehelper = "__name__"
          then
            file.getShortName() = flaskInstance().asSource().getLocation().getFile().getShortName()
          else (
            fileNamehelper.matches("%.py") and
            file.getShortName().matches("%" + configFileName + "%") and
            // after spliting, don't look at %py% pattern
            configFileName != ".py"
            or
            // in case of referencing to a directory which then we must look for __init__.py file
            not fileNamehelper.matches("%.py") and
            file.getRelativePath()
                .matches("%" + fileNamehelper.replaceAll(".", "/") + "/__init__.py")
          )
        ) and
        this.getTarget(0).(Name).getId() = ["SECRET_KEY", "JWT_SECRET_KEY"]
      ) and
      exists(this.getScope().getLocation().getFile().getRelativePath()) and
      not this.getScope().getLocation().getFile().inStdlib()
    }
  }

  /**
   * Holds if there is a helper predicate that specify where the Flask `SECRET_KEY` variable location is defined.
   * In Flask we have config files that specify the location of `SECRET_KEY` variable initialization
   * and the name of these files are determined by
   * `app.config.from_pyfile("configFileName.py")`
   * or
   * `app.config.from_object("configFileName.ClassName")`
   */
  string flaskConfiFileName(API::CallNode cn) {
    cn =
      flaskInstance()
          .getReturn()
          .getMember("config")
          .getMember(["from_object", "from_pyfile"])
          .getACall() and
    result =
      [
        cn.getParameter(0).getAValueReachingSink().asExpr().(StringLiteral).getText(),
        cn.getParameter(0).asSink().asExpr().(Name).getId()
      ]
  }

  string flaskConfiFileName2(API::CallNode cn) {
    cn =
      API::moduleImport("flask")
          .getMember("Flask")
          .getASubclass*()
          .getASuccessor*()
          .getMember("from_object")
          .getACall() and
    result = cn.getParameter(0).asSink().asExpr().(StringLiteral).getText()
  }
}
