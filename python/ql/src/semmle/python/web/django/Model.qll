import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
import semmle.python.security.injection.Sql

/** A django model class */
class DjangoModel extends ClassValue {
    DjangoModel() { Value::named("django.db.models.Model") = this.getASuperType() }
}

/** A "taint" for django database tables */
class DjangoDbTableObjects extends TaintKind {
    DjangoDbTableObjects() { this = "django.db.models.Model.objects" }

    override TaintKind getTaintOfMethodResult(string name) {
        result = this and
        (
            name = "filter" or
            name = "exclude" or
            name = "annotate" or
            name = "order_by" or
            name = "reverse" or
            name = "distinct" or
            name = "values" or
            name = "values_list" or
            name = "dates" or
            name = "datetimes" or
            name = "none" or
            name = "all" or
            name = "union" or
            name = "intersection" or
            name = "difference" or
            name = "select_related" or
            name = "prefetch_related" or
            name = "extra" or
            name = "defer" or
            name = "only" or
            name = "using" or
            name = "select_for_update" or
            name = "raw"
        )
    }
}

/** Django model objects, which are sources of django database table "taint" */
class DjangoModelObjects extends TaintSource {
    DjangoModelObjects() {
        this.(AttrNode).isLoad() and this.(AttrNode).getObject("objects").pointsTo(any(DjangoModel m))
    }

    override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoDbTableObjects }

    override string toString() { result = "django.db.models.Model.objects" }
}

/** A write to a field of a django model, which is a vulnerable to external data. */
class DjangoModelFieldWrite extends SqlInjectionSink {
    DjangoModelFieldWrite() {
        exists(AttrNode attr, DjangoModel model |
            this = attr and attr.isStore() and attr.getObject(_).pointsTo(model)
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "django model field write" }
}

/** A direct reference to a django model object, which is vulnerable to external data. */
class DjangoModelDirectObjectReference extends TaintSink {
    DjangoModelDirectObjectReference() {
        exists(CallNode objects_get_call, ControlFlowNode objects | this = objects_get_call.getAnArg() |
            objects_get_call.getFunction().(AttrNode).getObject("get") = objects and
            any(DjangoDbTableObjects objs).taints(objects)
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "django model object reference" }
}

/**
 * A call to the `raw` method on a django model. This allows a raw SQL query
 * to be sent to the database, which is a security risk.
 */
class DjangoModelRawCall extends SqlInjectionSink {
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
class DjangoModelExtraCall extends SqlInjectionSink {
    DjangoModelExtraCall() {
        exists(CallNode extra_call, ControlFlowNode queryset | this = extra_call.getArg(0) |
            extra_call.getFunction().(AttrNode).getObject("extra") = queryset and
            any(DjangoDbTableObjects objs).taints(queryset)
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "django.models.QuerySet.extra(sink,...)" }
}
