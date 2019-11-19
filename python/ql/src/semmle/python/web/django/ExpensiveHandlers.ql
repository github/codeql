import python
import semmle.python.objects.Callables
import semmle.python.web.RateLimiters

class DjangoModel extends ClassValue {

    DjangoModel() {
        Module::named("django.db.models").attr("Model") = this.getASuperType()
    }

}

class ModelSaveMethod extends CallableValue {
    ModelSaveMethod() {
        exists(DjangoModel m | m.lookup("save") = this)
    }
}

class ModelSaveMethodCallNode extends CallNode {
    ModelSaveMethodCallNode() {
        exists(BoundMethodObjectInternal m | this.getFunction().pointsTo(m) and m.getFunction() instanceof ModelSaveMethod)
    }
}

class ModelDeleteMethod extends CallableValue {
    ModelDeleteMethod() {
        exists(DjangoModel m | m.lookup("delete") = this)
    }
}

class ModelDeleteMethodCallNode extends CallNode {
    ModelDeleteMethodCallNode() {
        exists(BoundMethodObjectInternal m | this.getFunction().pointsTo(m) and m.getFunction() instanceof ModelDeleteMethod)
    }
}

/*
 * This is an unfortunate hack. The way Django creates `Model.objects` is such
 * that it's difficult to analyze it with `pointsTo`, because it's all runtime
 * constructed. Consequently, we have to fake it by looking instead for accesses
 * to the `objects` field on sub*classes of `Model`. This will likely be broken
 * in many situations, but is probably the best we can do.
 */
class ModelObjectsQuerySetAttrNode extends AttrNode {
    ModelObjectsQuerySetAttrNode() {
        exists(DjangoModel m | this.getObject().pointsTo(m))
        and
        this.getName() = "objects"
    }
}

/*
 * As above, this doesn't precisely pick out the `create` method, but rather it
 * picks out accesses to the `create` field on instances of
 * `ModelObjectQuerySet`. This will naturally have limitations.
 */
class QuerySetCreateMethodAttrNode extends AttrNode {
    QuerySetCreateMethodAttrNode() {
        this.getObject() instanceof ModelObjectsQuerySetAttrNode
        and
        this.getName() = "create"
    }
}

class QuerySetCreateMethodAttrNodeCall extends CallNode {
    QuerySetCreateMethodAttrNodeCall() {
        this.getFunction() instanceof QuerySetCreateMethodAttrNode
    }
}

class ExpensiveDjangoMethodCall extends CallNode {
    ExpensiveDjangoMethodCall() {
        this instanceof ModelSaveMethodCallNode
        or
        this instanceof ModelDeleteMethodCallNode
        or
        this instanceof QuerySetCreateMethodAttrNodeCall
    }
}

predicate callsNode(Function f, AstNode n) {
    f.contains(n)
}

predicate callsNodePlus(Function f, AstNode n) {
    callsNode(f,n)
    or
    exists(Call c, CallableValue v |
      f.contains(c) and
      c.getFunc().pointsTo(v) and
      callsNodePlus(v.getScope(), n)
    )
}

class DjangoDBExpensiveRouteHandler extends ExpensiveRouteHandler {
    ExpensiveDjangoMethodCall expensiveCall;
    
    DjangoDBExpensiveRouteHandler() {
        callsNodePlus(this, expensiveCall.getNode())
    }
    
    override string getExplanation() {
        result = "Calls expensive Django DB function here: " + expensiveCall.toString() + " (" + expensiveCall.getLocation().toString() + ")"
    }
}


from DjangoDBExpensiveRouteHandler h
where h.getLocation().getFile().getBaseName() = "expensive_handlers.py"
select h, h.getExplanation()

/*

from ClassValue cv
where cv.getName() = "MyModel"
select cv, cv.getABaseType()

*/