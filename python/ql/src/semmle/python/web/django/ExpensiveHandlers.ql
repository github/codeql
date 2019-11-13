import python
import semmle.python.objects.Callables

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

class DjangoQuerySet extends ClassValue {
    
    DjangoQuerySet() {
        Module::named("django.db.models").attr("QuerySet") = this.getASuperType()
    }
    
}

class QuerySetCreateMethod extends CallableValue {
    QuerySetCreateMethod() {
        exists(DjangoQuerySet m | m.lookup("create") = this)
    }
}

class QuerySetCreateMethodCallNode extends CallNode {
    QuerySetCreateMethodCallNode() {
        exists(BoundMethodObjectInternal m | this.getFunction().pointsTo(m) and m.getFunction() instanceof QuerySetCreateMethod)
    }
}


from Attribute c, Value v
where c.getLocation().getFile().getBaseName() = "expensive_handlers.py"
and c.pointsTo(v)
select c, v

/*

from ClassValue cv
where cv.getName() = "MyModel"
select cv, cv.getABaseType()

*/