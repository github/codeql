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

  public byte[] byteArray = new byte[] {1, 2, 3};
  private float[] floatArray = new float[] {1, 2, 3};
  private List<Character> charList = Arrays.asList('a', 'b', 'c');
  private char[] charArray;
  private Byte[] byteObjectArray;
  private String stringValue1;
  private String stringValue2;

  // summary=p;Pojo;false;Pojo;(Byte[],char[]);;Argument[0];Argument[this];taint;df-generated
  // summary=p;Pojo;false;Pojo;(Byte[],char[]);;Argument[1];Argument[this];taint;df-generated
  // contentbased-summary=p;Pojo;false;Pojo;(Byte[],char[]);;Argument[0];Argument[this].SyntheticField[p.Pojo.byteObjectArray];value;dfc-generated
  // contentbased-summary=p;Pojo;false;Pojo;(Byte[],char[]);;Argument[1];Argument[this].SyntheticField[p.Pojo.charArray];value;dfc-generated
  public Pojo(Byte[] byteObjectArray, char[] charArray) {
    this.byteObjectArray = byteObjectArray;
    this.charArray = charArray;
  }

  // summary=p;Pojo;false;getValue;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;Pojo;false;getValue;();;Argument[this].SyntheticField[p.Pojo.value];ReturnValue;value;dfc-generated
  public String getValue() {
    return value;
  }

  // summary=p;Pojo;false;setValue;(String);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;Pojo;false;setValue;(String);;Argument[0];Argument[this].SyntheticField[p.Pojo.value];value;dfc-generated
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
  // contentbased-summary=p;Pojo;false;getCharArray;();;Argument[this].SyntheticField[p.Pojo.charArray];ReturnValue;value;dfc-generated
  public char[] getCharArray() {
    return charArray;
  }

  // summary=p;Pojo;false;getByteArray;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;Pojo;false;getByteArray;();;Argument[this].Field[p.Pojo.byteArray];ReturnValue;value;dfc-generated
  public byte[] getByteArray() {
    return byteArray;
  }

  // summary=p;Pojo;false;setByteArray;(byte[]);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;Pojo;false;setByteArray;(byte[]);;Argument[0];Argument[this].Field[p.Pojo.byteArray];value;dfc-generated
  public void setByteArray(byte[] value) {
    byteArray = value;
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
  // No content based summary as charList is a "dead" (synthetic)field.
  public List<Character> getBoxedChars() {
    return charList;
  }

  // summary=p;Pojo;false;getBoxedBytes;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;Pojo;false;getBoxedBytes;();;Argument[this].SyntheticField[p.Pojo.byteObjectArray];ReturnValue;value;dfc-generated
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
  // contentbased-summary=p;Pojo;false;fillIn;(List);;Argument[this].SyntheticField[p.Pojo.value];Argument[0].Element;value;dfc-generated
  public void fillIn(List<String> target) {
    target.add(value);
  }

  // summary=p;Pojo;false;setStringValue1;(String);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;Pojo;false;setStringValue1;(String);;Argument[0];Argument[this].SyntheticField[p.Pojo.stringValue1];value;dfc-generated
  public void setStringValue1(String value) {
    this.stringValue1 = value;
  }

  // neutral=p;Pojo;copyStringValue;();summary;df-generated
  // contentbased-summary=p;Pojo;false;copyStringValue;();;Argument[this].SyntheticField[p.Pojo.stringValue1];Argument[this].SyntheticField[p.Pojo.stringValue2];value;dfc-generated
  public void copyStringValue() {
    this.stringValue2 = this.stringValue1;
  }

  // summary=p;Pojo;false;getStringValue2;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;Pojo;false;getStringValue2;();;Argument[this].SyntheticField[p.Pojo.stringValue2];ReturnValue;value;dfc-generated
  public String getStringValue2() {
    return this.stringValue2;
  }

  public class InnerPojo {
    private String value;

    // summary=p;Pojo$InnerPojo;true;InnerPojo;(String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=p;Pojo$InnerPojo;true;InnerPojo;(String);;Argument[0];Argument[this].SyntheticField[p.Pojo$InnerPojo.value];value;dfc-generated
    public InnerPojo(String value) {
      this.value = value;
    }

    // summary=p;Pojo$InnerPojo;true;getValue;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=p;Pojo$InnerPojo;true;getValue;();;Argument[this].SyntheticField[p.Pojo$InnerPojo.value];ReturnValue;value;dfc-generated
    public String getValue() {
      return value;
    }
  }

  // summary=p;Pojo;false;makeInnerPojo;(String);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;Pojo;false;makeInnerPojo;(String);;Argument[0];ReturnValue.SyntheticField[p.Pojo$InnerPojo.value];value;dfc-generated
  public InnerPojo makeInnerPojo(String value) {
    return new InnerPojo(value);
  }
}
