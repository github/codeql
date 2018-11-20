import python
private import semmle.python.pointsto.PointsTo

/** A bound method object, x.f where type(x) has a method f */
class BoundMethod extends Object {

    BoundMethod() {
        bound_method(this, _)
    }

    /* Gets the method 'f' in 'x.f' */
    FunctionObject getMethod() {
         bound_method(this, result)
    }

}

private predicate bound_method(AttrNode binding, FunctionObject method) {
    binding = method.getAMethodCall().getFunction()
}

private predicate decorator_call(Object method, ClassObject decorator, FunctionObject func) {
    exists(CallNode f |
        method = f and
        f.getFunction().refersTo(decorator) and
        PointsTo::points_to(f.getArg(0), _, func, _, _)
    )
}

/** A class method object. Either a decorated function or an explicit call to classmethod(f) */ 
class ClassMethodObject extends Object {

    ClassMethodObject() {
        PointsTo::class_method(this, _)
    }

    FunctionObject getFunction() {
        PointsTo::class_method(this, result)
    }

    CallNode getACall() {
        PointsTo::class_method_call(this, _, _, _, result)
    }

}

/** A static method object. Either a decorated function or an explicit call to staticmethod(f) */ 
class StaticMethodObject extends Object {

    StaticMethodObject() {
        decorator_call(this, theStaticMethodType(), _)
    }

    FunctionObject getFunction() {
        decorator_call(this, theStaticMethodType(), result)
    }

}

