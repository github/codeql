package p;

import java.math.BigInteger;
import java.util.Collection;
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

    public Integer getBoxedValue() {
        return Integer.valueOf(intValue);
    }

    public int[] getPrimitiveArray() {
        return new int[] { intValue };
    }

    public char[] getCharArray() {
        return new char[] { (char) intValue };
    }

    public byte[] getByteArray() {
        return new byte[] { (byte) intValue };
    }
    
    public float[] getFloatArray() {
        return new float[] { (float) intValue };
    }

    public Integer[] getBoxedArray() {
        return new Integer[] { Integer.valueOf(intValue) };
    }
    
    public Collection<Integer> getBoxedCollection() {
        return List.of(Integer.valueOf(intValue));
    }

    public BigInteger getBigInt() {
        return BigInteger.valueOf(intValue);
    }

    public void fillIn(List<String> target) {
        target.add(value);
    }

}