import java.io.ObjectStreamException;
import java.io.Serializable;

class NonSerializable { 

  // Has no default constructor
  public NonSerializable(int x) { }

}

// BAD: Serializable but its parent cannot be instantiated
class A extends NonSerializable implements Serializable { 
  public A() { super(1); }
}

// GOOD: writeReplaces itself, so unlikely to be deserialized
// according to default rules.
class B extends NonSerializable implements Serializable { 
  public B() { super(2); }

  public Object writeReplace() throws ObjectStreamException {
    return null;
  }
}
