package p;

public final class Factory {

  public String value;

  private int intValue;

  // summary=p;Factory;false;create;(String,int);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;Factory;false;create;(String,int);;Argument[0];ReturnValue.Field[p.Factory.value];value;dfc-generated
  public static Factory create(String value, int foo) {
    return new Factory(value, foo);
  }

  // summary=p;Factory;false;create;(String);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;Factory;false;create;(String);;Argument[0];ReturnValue.Field[p.Factory.value];value;dfc-generated
  public static Factory create(String value) {
    return new Factory(value, 0);
  }

  private Factory(String value, int intValue) {
    this.value = value;
    this.intValue = intValue;
  }

  // summary=p;Factory;false;getValue;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;Factory;false;getValue;();;Argument[this].Field[p.Factory.value];ReturnValue;value;dfc-generated
  public String getValue() {
    return value;
  }

  // neutral=p;Factory;getIntValue;();summary;df-generated
  public int getIntValue() {
    return intValue;
  }
}
