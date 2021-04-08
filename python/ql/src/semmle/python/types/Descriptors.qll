import python
private import semmle.python.objects.ObjectInternal

/** A class method object. Either a decorated function or an explicit call to classmethod(f) */
class ClassMethodObject extends Object {
  ClassMethodObject() { any(ClassMethodObjectInternal cm).getOrigin() = this }

  FunctionObject getFunction() {
    exists(ClassMethodObjectInternal cm |
      cm.getOrigin() = this and
      result = cm.getFunction().getSource()
    )
  }

  CallNode getACall() { result = this.getFunction().getACall() }
}

/** A static method object. Either a decorated function or an explicit call to staticmethod(f) */
class StaticMethodObject extends Object {
  StaticMethodObject() { any(StaticMethodObjectInternal sm).getOrigin() = this }

  FunctionObject getFunction() {
    exists(StaticMethodObjectInternal sm |
      sm.getOrigin() = this and
      result = sm.getFunction().getSource()
    )
  }
}
