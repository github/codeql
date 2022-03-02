import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
import semmle.python.security.injection.Sql

/** A django model class */
deprecated class DjangoModel extends ClassValue {
  DjangoModel() { Value::named("django.db.models.Model") = this.getASuperType() }
}

/** A "taint" for django database tables */
deprecated class DjangoDbTableObjects extends TaintKind {
  DjangoDbTableObjects() { this = "django.db.models.Model.objects" }

  override TaintKind getTaintOfMethodResult(string name) {
    result = this and
    name in [
        "filter", "exclude", "none", "all", "union", "intersection", "difference", "select_related",
        "prefetch_related", "extra", "defer", "only", "annotate", "using", "select_for_update",
        "raw", "order_by", "reverse", "distinct", "values", "values_list", "dates", "datetimes"
      ]
  }
}

/** Django model objects, which are sources of django database table "taint" */
deprecated class DjangoModelObjects extends TaintSource {
  DjangoModelObjects() {
    this.(AttrNode).isLoad() and this.(AttrNode).getObject("objects").pointsTo(any(DjangoModel m))
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoDbTableObjects }

  override string toString() { result = "django.db.models.Model.objects" }
}

/**
 * A call to the `raw` method on a django model. This allows a raw SQL query
 * to be sent to the database, which is a security risk.
 */
deprecated class DjangoModelRawCall extends SqlInjectionSink {
  DjangoModelRawCall() {
    exists(CallNode raw_call, ControlFlowNode queryset | this = raw_call.getArg(0) |
      raw_call.getFunction().(AttrNode).getObject("raw") = queryset and
      any(DjangoDbTableObjects objs).taints(queryset)
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "django.models.QuerySet.raw(sink,...)" }
}

/**
 * A call to the `extra` method on a django model. This allows a raw SQL query
 * to be sent to the database, which is a security risk.
 */
deprecated class DjangoModelExtraCall extends SqlInjectionSink {
  DjangoModelExtraCall() {
    exists(CallNode extra_call, ControlFlowNode queryset | this = extra_call.getArg(0) |
      extra_call.getFunction().(AttrNode).getObject("extra") = queryset and
      any(DjangoDbTableObjects objs).taints(queryset)
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "django.models.QuerySet.extra(sink,...)" }
}
