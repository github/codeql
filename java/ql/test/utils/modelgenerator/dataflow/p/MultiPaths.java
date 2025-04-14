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

  // No summary for the clone method as it is explicitly handled by the dataflow library.
  @Override
  public Object clone() {
    return this;
  }
}
