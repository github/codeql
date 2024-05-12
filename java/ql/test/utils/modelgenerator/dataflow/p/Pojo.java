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

  // neutral=p;Pojo;doNotSetValue;(String);summary;df-generated
  public int doNotSetValue(String value) {
    Holder h = new Holder(value);
    return h.length();
  }

  // neutral=p;Pojo;getIntValue;();summary;df-generated
  public int getIntValue() {
    return intValue;
  }

  // neutral=p;Pojo;getBoxedValue;();summary;df-generated
  public Integer getBoxedValue() {
    return Integer.valueOf(intValue);
  }

  // neutral=p;Pojo;getPrimitiveArray;();summary;df-generated
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

  // neutral=p;Pojo;getFloatArray;();summary;df-generated
  public float[] getFloatArray() {
    return floatArray;
  }

  // neutral=p;Pojo;getBoxedArray;();summary;df-generated
  public Integer[] getBoxedArray() {
    return new Integer[] {Integer.valueOf(intValue)};
  }

  // neutral=p;Pojo;getBoxedCollection;();summary;df-generated
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

  // neutral=p;Pojo;getBigInt;();summary;df-generated
  public BigInteger getBigInt() {
    return BigInteger.valueOf(intValue);
  }

  // neutral=p;Pojo;getBigDecimal;();summary;df-generated
  public BigDecimal getBigDecimal() {
    return new BigDecimal(value);
  }

  // summary=p;Pojo;false;fillIn;(List);;Argument[this];Argument[0].Element;taint;df-generated
  public void fillIn(List<String> target) {
    target.add(value);
  }
}
