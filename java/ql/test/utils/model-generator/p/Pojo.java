package p;

import java.util.List;

public final class Pojo {

    private class Holder {
        private String value;

        Holder(String value) {
            this.value = value;
        }

        int length() {
            return value.length();
        }
    }

    private String value;

    private int intValue = 2;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int doNotSetValue(String value) {
        Holder h = new Holder(value);
        return h.length();
    }

    public int getIntValue() {
        return intValue;
    }

    public void fillIn(List<String> target) {
        target.add(value);
    }

}