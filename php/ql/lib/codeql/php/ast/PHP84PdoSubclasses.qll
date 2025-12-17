/**
 * @name PHP 8.4 PDO Driver Subclasses
 * @description Provides analysis for PHP 8.4 PDO driver subclasses
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A call to a PDO driver subclass constructor (PHP 8.4+).
 *
 * PHP 8.4 introduced object-oriented PDO driver subclasses:
 * - PDO\SQLite
 * - PDO\MySQL
 * - PDO\PostgreSQL
 */
class PdoDriverSubclassCall extends TS::PHP::ObjectCreationExpression {
  PdoDriverSubclassCall() {
    exists(string className | className = this.getChild(_).(TS::PHP::QualifiedName).toString() |
      className.matches("PDO\\%") or
      className.matches("\\PDO\\%") or
      className in ["SQLite", "MySQL", "PostgreSQL"]
    ) or
    exists(string className | className = this.getChild(_).(TS::PHP::Name).getValue() |
      className in ["SQLite", "MySQL", "PostgreSQL"]
    )
  }

  /** Gets the class name being instantiated */
  string getClassName() {
    result = this.getChild(_).(TS::PHP::QualifiedName).toString()
    or
    result = this.getChild(_).(TS::PHP::Name).getValue()
  }

  /** Checks if this uses the SQLite driver */
  predicate usesSqliteDriver() {
    exists(string name | name = this.getClassName() |
      name.matches("%SQLite%")
    )
  }

  /** Checks if this uses the MySQL driver */
  predicate usesMysqlDriver() {
    exists(string name | name = this.getClassName() |
      name.matches("%MySQL%")
    )
  }

  /** Checks if this uses the PostgreSQL driver */
  predicate usesPostgresqlDriver() {
    exists(string name | name = this.getClassName() |
      name.matches("%PostgreSQL%")
    )
  }

  /** Gets the driver type name */
  string getDriverType() {
    if this.usesSqliteDriver() then result = "SQLite"
    else if this.usesMysqlDriver() then result = "MySQL"
    else if this.usesPostgresqlDriver() then result = "PostgreSQL"
    else result = "Unknown"
  }
}

/**
 * Checks if a node is a PDO driver subclass usage.
 */
predicate isPdoDriverSubclassUsage(TS::PHP::ObjectCreationExpression expr) {
  expr instanceof PdoDriverSubclassCall
}

/**
 * A legacy PDO connection using DSN string.
 */
class LegacyPdoConnection extends TS::PHP::ObjectCreationExpression {
  LegacyPdoConnection() {
    exists(string className |
      className = this.getChild(_).(TS::PHP::Name).getValue() and
      className = "PDO"
    )
  }
}

/**
 * Checks if a PDO connection uses the legacy DSN string approach.
 */
predicate isLegacyPdoConnection(TS::PHP::ObjectCreationExpression expr) {
  expr instanceof LegacyPdoConnection
}
