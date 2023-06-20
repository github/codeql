/**
 * @name Initializing SECRET_KEY of Flask application with Constant value
 * @description Initializing SECRET_KEY of Flask application with Constant value
 * files can lead to Authentication bypass
 * @kind path-problem
 * @id py/ConstantSecretKey
 * @problem.severity error
 * @security-severity 8.5
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-287
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking

/**
 * `flask.Flask()`
 */
API::Node flaskInstance() { result = API::moduleImport("flask").getMember("Flask").getASubclass*() }

/**
 * with using flask-session package, there is no jwt exists in cookies in user side
 * ```python
 *import os
 *from flask import Flask, session
 *app = Flask(__name__)
 * ```
 */
module FlaskConstantSecretKeyConfig implements DataFlow::ConfigSig {
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
      exists(DataFlow::LocalSourceNode lsn |
        lsn = API::moduleImport("os").getMember("environ").getASubscript().asSource() and
        source.asExpr() = lsn.asExpr()
      )
    ) and
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
      exists(API::Node n |
        n = flaskInstance() and
        flask_sessionSanitizer(n.getReturn().asSource())
      |
        sink =
          [
            n.getReturn().getAMember().getSubscript(["SECRET_KEY", "JWT_SECRET_KEY"]).asSink(),
            n.getReturn().getMember(["SECRET_KEY", "JWT_SECRET_KEY"]).asSink(),
            n.getReturn()
                .getMember("config")
                .getMember(["update", "from_mapping"])
                .getACall()
                .getArgByName(["SECRET_KEY", "JWT_SECRET_KEY"])
          ]
      )
      or
      // this query checks for Django SecretKey too
      if exists(API::moduleImport("django"))
      then
        exists(AssignStmt e | e.getTarget(0).toString() = "SECRET_KEY" |
          sink.asExpr() = e.getValue()
          // and sanitizer(e.getTarget(0))
        )
      else
        exists(SecretKeyAssignStmt e |
          sink.asExpr() = e.getValue()
          // | sanitizer(e.getTarget(0))
        )
    ) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }
}

// using flask_session library is safe
predicate flask_sessionSanitizer(DataFlow::Node source) {
  not DataFlow::localFlow(source,
    API::moduleImport("flask_session").getMember("Session").getACall().getArg(0))
}

// *it seems that sanitizer have a lot of performance issues*
// for case check whether SECRECT_KEY is empty or not
predicate sanitizer(Expr sourceExpr) {
  exists(DataFlow::Node source, DataFlow::Node sink, If i |
    source.asExpr() = sourceExpr and
    DataFlow::localFlow(source, sink)
  |
    not i.getASubExpression().getAChildNode*().(Compare) = sink.asExpr() and
    not sink.getScope().getLocation().getFile().inStdlib() and
    not source.getScope().getLocation().getFile().inStdlib() and
    not i.getScope().getLocation().getFile().inStdlib()
  )
}

/**
 * Assignments like `SECRET_KEY = ConstantValue`
 * which ConstantValue will be found by another DataFlow Configuration
 * and `SECRET_KEY` location must be a argument of `from_object` or `from_pyfile` methods
 * the argument/location value will be found by another Taint Tracking Configuration.
 */
class SecretKeyAssignStmt extends AssignStmt {
  SecretKeyAssignStmt() {
    exists(
      string configFileName, string fileNamehelper, DataFlow::Node n1, FromObjectFileName config
    |
      config.hasFlow(n1, _) and
      n1.asExpr().isConstant() and
      fileNamehelper = n1.asExpr().(StrConst).getS() and
      // because of `from_object` we want first part of `Config.AClassName` which `Config` is a python file name
      configFileName = fileNamehelper.splitAt(".") and
      // after spliting, don't look at %py% pattern
      configFileName != "py"
    |
      this.getLocation().getFile().getShortName().matches("%" + configFileName + "%") and
      this.getTarget(0).toString() = ["SECRET_KEY", "JWT_SECRET_KEY"]
    ) and
    not this.getScope().getLocation().getFile().inStdlib()
  }
}

/**
 * we have some file name that telling us the SECRET_KEY location
 * which have determined by these two methods
 * `app.config.from_pyfile("configFileName.py")` or `app.config.from_object("configFileName.ClassName")`
 * this is a helper configuration that help us skip the SECRET_KEY variables that are not related to Flask.
 */
class FromObjectFileName extends TaintTracking::Configuration {
  FromObjectFileName() { this = "FromObjectFileName" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().isConstant() and
    not source.getScope().getLocation().getFile().inStdlib()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(API::Node n |
      n = flaskInstance() and
      flask_sessionSanitizer(n.getReturn().asSource())
    |
      sink =
        n.getReturn()
            .getMember("config")
            .getMember(["from_object", "from_pyfile"])
            .getACall()
            .getArg(0)
    ) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }
}

module FlaskConstantSecretKey = TaintTracking::Global<FlaskConstantSecretKeyConfig>;

import FlaskConstantSecretKey::PathGraph

from FlaskConstantSecretKey::PathNode source, FlaskConstantSecretKey::PathNode sink
where FlaskConstantSecretKey::flowPath(source, sink)
select sink, source, sink, "The SECRET_KEY config variable has assigned by $@.", source,
  " this constant String"
