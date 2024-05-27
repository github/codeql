package p;

public final class ImmutablePojo {

  private final String value;

  private final long x;

  // summary=p;ImmutablePojo;false;ImmutablePojo;(String,int);;Argument[0];Argument[this];taint;df-generated
  public ImmutablePojo(String value, int x) {
    this.value = value;
    this.x = x;
  }

  // summary=p;ImmutablePojo;false;getValue;();;Argument[this];ReturnValue;taint;df-generated
  public String getValue() {
    return value;
  }

  // neutral=p;ImmutablePojo;getX;();summary;df-generated
  public long getX() {
    return x;
  }

  // summary=p;ImmutablePojo;false;or;(String);;Argument[0];ReturnValue;taint;df-generated
  // summary=p;ImmutablePojo;false;or;(String);;Argument[this];ReturnValue;taint;df-generated
  public String or(String defaultValue) {
    return value != null ? value : defaultValue;
  }
}
