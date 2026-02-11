package p;

public class InnerClasses {

  class IgnoreMe {
    public String no(String input) {
      return input;
    }
  }

  public class CaptureMe {
    // heuristic-summary=p;InnerClasses$CaptureMe;true;yesCm;(String);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;InnerClasses$CaptureMe;true;yesCm;(String);;Argument[0];ReturnValue;value;dfc-generated
    public String yesCm(String input) {
      return input;
    }
  }

  // heuristic-summary=p;InnerClasses;true;yes;(String);;Argument[0];ReturnValue;value;df-generated
  // contentbased-summary=p;InnerClasses;true;yes;(String);;Argument[0];ReturnValue;value;dfc-generated
  public String yes(String input) {
    return input;
  }
}
