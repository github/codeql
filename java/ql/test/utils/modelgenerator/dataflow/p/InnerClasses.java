package p;

public class InnerClasses {

  class IgnoreMe {
    public String no(String input) {
      return input;
    }
  }

  public class CaptureMe {
    // summary=p;InnerClasses$CaptureMe;true;yesCm;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;InnerClasses$CaptureMe;true;yesCm;(String);;Argument[0];ReturnValue;value;dfc-generated
    public String yesCm(String input) {
      return input;
    }
  }

  // summary=p;InnerClasses;true;yes;(String);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;InnerClasses;true;yes;(String);;Argument[0];ReturnValue;value;dfc-generated
  public String yes(String input) {
    return input;
  }
}
