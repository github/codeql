import java.io.*;

public class Test {
    record T1() implements Serializable {

    @Serial
    private static final ObjectStreamField[] serialPersistentFields = new ObjectStreamField[0]; // $ Alert

    @Serial
    private void writeObject(ObjectOutputStream out) throws IOException {} // $ Alert

    @Serial
    private void readObject(ObjectOutputStream out) throws IOException {} // $ Alert

    @Serial
    private void readObjectNoData(ObjectOutputStream out) throws IOException { // $ Alert
    }

}

    record T2() implements Externalizable {

    @Override
    public void writeExternal(ObjectOutput out) throws IOException { // $ Alert
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException { // $ Alert
    }

    }

    record T3() implements Serializable {

    public Object writeReplace(ObjectOutput out) throws ObjectStreamException { // COMPLIANT
        return new Object();
    }

    public Object readResolve(ObjectInput in) throws ObjectStreamException { // COMPLIANT
        return new Object();
    }
}}
