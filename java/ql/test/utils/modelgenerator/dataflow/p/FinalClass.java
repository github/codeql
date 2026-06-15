package p;

public final class FinalClass {

  private static final String C = "constant";

  // heuristic-summary=p;FinalClass;false;returnsInput;(String);;Argument[0];ReturnValue;value;df-generated
  // contentbased-summary=p;FinalClass;false;returnsInput;(String);;Argument[0];ReturnValue;value;dfc-generated
  public String returnsInput(String input) {
    return input;
  }

  // neutral=p;FinalClass;returnsConstant;();summary;df-generated
  public String returnsConstant() {
    return C;
  }
}
