package p;

public final class ImmutablePojo {

    private final String value;

    private final long x;

    public ImmutablePojo(String value, int x) {
        this.value = value;
        this.x = x;
    }

    public String getValue() {
        return value;
    }

    public long getX() {
        return x;
    }

    public String or(String defaultValue) {
        return value != null ? value : defaultValue;
    }

}