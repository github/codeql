## Overview

Record types were introduced in Java 16 as a mechanism to provide simpler data handling as an alternative to regular classes. However, record classes behave slightly differently during serialization. Namely any `writeObject`, `readObject`, `readObjectNoData`, `writeExternal`, and `readExternal` methods and `serialPersistentFields` fields declared in these classes cannot be used to affect the serialization process of any `Record` data type.

## Recommendation

Some level of serialization customization is offered by the Java 16 Record feature. The `writeReplace` and `readResolve` methods in a record that implements `java.io.Serializable` can be used to replace the object to be serialized. Otherwise, no further customization of serialization of records is possible, and it is better to consider using a regular class implementing `java.io.Serializable` or `java.io.Externalizable` when customization is needed.

## Example

```java
record T1() implements Serializable {

    @Serial
    private static final ObjectStreamField[] serialPersistentFields = new ObjectStreamField[0]; // NON_COMPLIANT

    @Serial
    private void writeObject(ObjectOutputStream out) throws IOException {} // NON_COMPLIANT

    @Serial
    private void readObject(ObjectOutputStream out) throws IOException {}// NON_COMPLIANT

    @Serial
    private void readObjectNoData(ObjectOutputStream out) throws IOException { // NON_COMPLIANT
    }
}

record T2() implements Externalizable {

    @Override
    public void writeExternal(ObjectOutput out) throws IOException { // NON_COMPLIANT
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException { // NON_COMPLIANT
    }
}

record T3() implements Serializable {

    public Object writeReplace(ObjectOutput out) throws ObjectStreamException { // COMPLIANT
        return new Object();
    }

    public Object readResolve(ObjectInput in) throws ObjectStreamException { // COMPLIANT
        return new Object();
    }
}
```

## References

- Oracle Serialization Documentation: [Serialization of Records](https://docs.oracle.com/en/java/javase/16/docs/specs/serialization/serial-arch.html#serialization-of-records)
- Java Record: [Feature Specification](https://openjdk.org/jeps/395)
