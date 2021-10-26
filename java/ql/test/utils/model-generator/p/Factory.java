package p;

public final class Factory {

    private String value;

    private int intValue;

    public static Factory create(String value, int foo) {
        return new Factory(value, foo);
    }

    public static Factory create(String value) {
        return new Factory(value, 0);
    }

    private Factory(String value, int intValue) {
        this.value = value;
        this.intValue = intValue;
    }

    public String getValue() {
        return value;
    }

    public int getIntValue() {
        return intValue;
    }

}