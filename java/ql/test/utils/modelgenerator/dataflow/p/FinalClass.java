package p;

public final class FinalClass {

  private static final String C = "constant";

  // MaD=p;FinalClass;false;returnsInput;(String);;Argument[0];ReturnValue;taint;df-generated
  public String returnsInput(String input) {
    return input;
  }

  public String returnsConstant() {
    return C;
  }
}
