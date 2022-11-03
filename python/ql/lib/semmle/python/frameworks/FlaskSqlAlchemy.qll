/**
 * Provides classes modeling security-relevant aspects of the `Flask-SQLAlchemy` PyPI package
 * (imported by `flask_sqlalchemy`).
 * See
 *  - https://pypi.org/project/Flask-SQLAlchemy/
 *  - https://flask-sqlalchemy.palletsprojects.com/en/2.x/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.ApiGraphs
private import semmle.python.Concepts
private import semmle.python.frameworks.SqlAlchemy

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `Flask-SQLAlchemy` PyPI package (imported by `flask_sqlalchemy`).
 * See
 *  - https://pypi.org/project/Flask-SQLAlchemy/
 *  - https://flask-sqlalchemy.palletsprojects.com/en/2.x/
 */
private module FlaskSqlAlchemy {
  /** Gets an instance of `flask_sqlalchemy.SQLAlchemy` */
  private API::Node dbInstance() {
    result = API::moduleImport("flask_sqlalchemy").getMember("SQLAlchemy").getReturn()
  }

  /** A call to the `text` method on a DB. */
  private class DbTextCall extends SqlAlchemy::TextClause::TextClauseConstruction {
    DbTextCall() { this = dbInstance().getMember("text").getACall() }
  }

  /** Access on a DB resulting in an Engine */
  private class DbEngine extends SqlAlchemy::Engine::InstanceSource {
    DbEngine() {
      this = dbInstance().getMember("engine").getAUse()
      or
      this = dbInstance().getMember("get_engine").getACall()
    }
  }

  /** Access on a DB resulting in a Session */
  private class DbSession extends SqlAlchemy::Session::InstanceSource {
    DbSession() {
      this = dbInstance().getMember("session").getAUse()
      or
      this = dbInstance().getMember("create_session").getReturn().getACall()
      or
      this = dbInstance().getMember("create_session").getReturn().getMember("begin").getACall()
      or
      this = dbInstance().getMember("create_scoped_session").getACall()
    }
  }
}
