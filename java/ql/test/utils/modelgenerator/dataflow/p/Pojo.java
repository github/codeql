package p;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Arrays;
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

  private byte[] byteArray = new byte[] {1, 2, 3};
  private float[] floatArray = new float[] {1, 2, 3};
  private char[] charArray = new char[] {'a', 'b', 'c'};
  private List<Character> charList = Arrays.asList('a', 'b', 'c');
  private Byte[] byteObjectArray = new Byte[] {1, 2, 3};

  // summary=p;Pojo;false;getValue;();;Argument[this];ReturnValue;taint;df-generated
  public String getValue() {
    return value;
  }

  // summary=p;Pojo;false;setValue;(String);;Argument[0];Argument[this];taint;df-generated
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
    return new int[] {intValue};
  }

  // summary=p;Pojo;false;getCharArray;();;Argument[this];ReturnValue;taint;df-generated
  public char[] getCharArray() {
    return charArray;
  }

  // summary=p;Pojo;false;getByteArray;();;Argument[this];ReturnValue;taint;df-generated
  public byte[] getByteArray() {
    return byteArray;
  }

  public float[] getFloatArray() {
    return floatArray;
  }

  public Integer[] getBoxedArray() {
    return new Integer[] {Integer.valueOf(intValue)};
  }

  public Collection<Integer> getBoxedCollection() {
    return List.of(Integer.valueOf(intValue));
  }

  // summary=p;Pojo;false;getBoxedChars;();;Argument[this];ReturnValue;taint;df-generated
  public List<Character> getBoxedChars() {
    return charList;
  }

  // summary=p;Pojo;false;getBoxedBytes;();;Argument[this];ReturnValue;taint;df-generated
  public Byte[] getBoxedBytes() {
    return byteObjectArray;
  }

  public BigInteger getBigInt() {
    return BigInteger.valueOf(intValue);
  }

  public BigDecimal getBigDecimal() {
    return new BigDecimal(value);
  }

  // summary=p;Pojo;false;fillIn;(List);;Argument[this];Argument[0].Element;taint;df-generated
  public void fillIn(List<String> target) {
    target.add(value);
  }
}
