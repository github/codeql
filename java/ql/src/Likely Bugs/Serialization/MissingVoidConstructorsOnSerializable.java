class WrongItem {
    private String name;

    // BAD: This class does not have a no-argument constructor, and throws an
    // 'InvalidClassException' at runtime.

    public WrongItem(String name) {
        this.name = name;
    }
}

class WrongSubItem extends WrongItem implements Serializable {
    public WrongSubItem() {
        super(null);
    }

    public WrongSubItem(String name) {
        super(name);
    }
}

class Item {
    private String name;

    // GOOD: This class declares a no-argument constructor, which allows serializable 
    // subclasses to be deserialized without error.
    public Item() {}

    public Item(String name) {
        this.name = name;
    }
}

class SubItem extends Item implements Serializable {
    public SubItem() { 
        super(null); 
    }

    public SubItem(String name) {
        super(name);
    }
}