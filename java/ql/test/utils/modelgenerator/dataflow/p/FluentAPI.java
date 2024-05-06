package p;

public final class FluentAPI {

  // MaD=p;FluentAPI;false;returnsThis;(String);;Argument[this];ReturnValue;value;df-generated
  public FluentAPI returnsThis(String input) {
    return this;
  }

  public class Inner {
    public FluentAPI notThis(String input) {
      return FluentAPI.this;
    }
  }
}
