import java.io.ObjectStreamException;
import java.io.Serializable;

class NonSerialzable { 

  // Has no default constructor
  public NonSerialzable(int x) { }

}

// BAD: Serializable but its parent cannot be instantiated
class A extends NonSerialzable implements Serializable { 
  public A() { super(1); }
}

// GOOD: writeReplaces itself, so unlikely to be deserialized
// according to default rules.
class B extends NonSerialzable implements Serializable { 
  public B() { super(2); }

  public Object writeReplace() throws ObjectStreamException {
    return null;
  }
}
