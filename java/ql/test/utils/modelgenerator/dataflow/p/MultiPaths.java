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
}
