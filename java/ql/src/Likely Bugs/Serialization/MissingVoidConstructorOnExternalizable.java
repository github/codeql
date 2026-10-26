class WrongMemo implements Externalizable {
    private String memo;

    // BAD: No public no-argument constructor is defined. Deserializing this object
    // causes an 'InvalidClassException'.

    public WrongMemo(String memo) {
        this.memo = memo;
    }

    public void writeExternal(ObjectOutput arg0) throws IOException {
        //...
    }
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        //...
    }
}

class Memo implements Externalizable {
    private String memo;

    // GOOD: Declare a public no-argument constructor, which is used by the
    // serialization framework when the object is deserialized.
    public Memo() {
    }

    public Memo(String memo) {
        this.memo = memo;
    }

    public void writeExternal(ObjectOutput out) throws IOException {
        //...
    }
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        //...
    }
}
