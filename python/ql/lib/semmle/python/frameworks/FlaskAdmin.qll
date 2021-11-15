/**
 * Provides classes modeling security-relevant aspects of the `Flask-Admin` PyPI package
 * (imported as `flask_admin`).
 *
 * See
 * - https://flask-admin.readthedocs.io/en/latest/
 * - https://pypi.org/project/Flask-Admin/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.frameworks.Flask
private import semmle.python.ApiGraphs

/**
 * Provides models for the `Flask-Admin` PyPI package (imported as `flask_admin`).
 *
 * See
 * - https://flask-admin.readthedocs.io/en/latest/
 * - https://pypi.org/project/Flask-Admin/
 */
private module FlaskAdmin {
  /**
   * A call to `flask_admin.expose`, which is used as a decorator to make the
   * function exposed in the admin interface (and make it a request handler)
   *
   * See https://flask-admin.readthedocs.io/en/latest/api/mod_base/#flask_admin.base.expose
   */
  private class FlaskAdminExposeCall extends Flask::FlaskRouteSetup, DataFlow::CallCfgNode {
    FlaskAdminExposeCall() {
      this = API::moduleImport("flask_admin").getMember("expose").getACall()
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("url")]
    }

    override Function getARequestHandler() { result.getADecorator().getAFlowNode() = node }
  }

  /**
   * A call to `flask_admin.expose_plugview`, which is used as a decorator to make the
   * class (which we expect to be a flask View class) exposed in the admin interface.
   *
   * See https://flask-admin.readthedocs.io/en/latest/api/mod_base/#flask_admin.base.expose_plugview
   */
  private class FlaskAdminExposePlugviewCall extends Flask::FlaskRouteSetup, DataFlow::CallCfgNode {
    FlaskAdminExposePlugviewCall() {
      this = API::moduleImport("flask_admin").getMember("expose_plugview").getACall()
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("url")]
    }

    override Parameter getARoutedParameter() {
      result = super.getARoutedParameter() and
      (
        exists(this.getUrlPattern())
        or
        // the first argument is `self`, and the second argument `cls` will receive the
        // containing flask_admin View class -- this is only relevant if the URL pattern
        // is not known
        not exists(this.getUrlPattern()) and
        not result = this.getARequestHandler().getArg([0, 1])
      )
    }

    override Function getARequestHandler() {
      exists(Flask::FlaskViewClass cls |
        cls.getADecorator().getAFlowNode() = node and
        result = cls.getARequestHandler()
      )
    }
  }
}
