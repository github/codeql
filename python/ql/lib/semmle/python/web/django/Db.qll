import python
import semmle.python.security.injection.Sql

/**
 * A taint kind representing a django cursor object.
 */
deprecated class DjangoDbCursor extends DbCursor {
  DjangoDbCursor() { this = "django.db.connection.cursor" }
}

deprecated private Value theDjangoConnectionObject() {
  result = Value::named("django.db.connection")
}

/**
 * A kind of taint source representing sources of django cursor objects.
 */
deprecated class DjangoDbCursorSource extends DbConnectionSource {
  DjangoDbCursorSource() {
    exists(AttrNode cursor |
      this.(CallNode).getFunction() = cursor and
      cursor.getObject("cursor").pointsTo(theDjangoConnectionObject())
    )
  }

  override string toString() { result = "django.db.connection.cursor" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoDbCursor }
}

deprecated ClassValue theDjangoRawSqlClass() {
  result = Value::named("django.db.models.expressions.RawSQL")
}

/**
 * A sink of taint on calls to `django.db.models.expressions.RawSQL`. This
 * allows arbitrary SQL statements to be executed, which is a security risk.
 */
deprecated class DjangoRawSqlSink extends SqlInjectionSink {
  DjangoRawSqlSink() {
    exists(CallNode call |
      call = theDjangoRawSqlClass().getACall() and
      this = call.getArg(0)
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "django.db.models.expressions.RawSQL(sink,...)" }
}
