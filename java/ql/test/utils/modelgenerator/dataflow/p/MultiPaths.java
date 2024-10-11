package p;

public class MultiPaths {

  // summary=p;MultiPaths;true;cond;(String,String);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;MultiPaths;true;cond;(String,String);;Argument[0];ReturnValue;value;dfc-generated
  public String cond(String x, String other) {
    if (x == other) {
      return x.substring(0, 100);
    }
    return x;
  }

  // summary=p;MultiPaths;true;clone;();;Argument[this];ReturnValue;value;df-generated
  // contentbased-summary=p;MultiPaths;true;clone;();;Argument[this];ReturnValue;value;dfc-generated
  @Override
  public Object clone() {
    return this;
  }
}
