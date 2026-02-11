package p;

public final class FluentAPI {

  // heuristic-summary=p;FluentAPI;false;returnsThis;(String);;Argument[this];ReturnValue;value;df-generated
  // contentbased-summary=p;FluentAPI;false;returnsThis;(String);;Argument[this];ReturnValue;value;dfc-generated
  public FluentAPI returnsThis(String input) {
    return this;
  }

  public class Inner {
    // neutral=p;FluentAPI$Inner;notThis;(String);summary;df-generated
    public FluentAPI notThis(String input) {
      return FluentAPI.this;
    }
  }
}
