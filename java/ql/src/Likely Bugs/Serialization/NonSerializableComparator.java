// BAD: This is not serializable, and throws a 'java.io.NotSerializableException'
// when used in a serializable sorted collection.
class WrongComparator implements Comparator<String> {
    public int compare(String o1, String o2) {
        return o1.compareTo(o2);
    }
}

// GOOD: This is serializable, and can be used in collections that are meant to be serialized.
class StringComparator implements Comparator<String>, Serializable {
    private static final long serialVersionUID = -5972458403679726498L;

    public int compare(String arg0, String arg1) {
        return arg0.compareTo(arg1);
    }
}