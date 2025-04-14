package p;

class MultipleImpl2 {

  // Multiple implementations of the same interface.
  // This is used to test that we only generate a summary model and
  // not neutral summary model for `IInterface.m`.
  public interface IInterface {
    Object m(Object value);
  }

  public class Impl1 implements IInterface {
    public Object m(Object value) {
      return null;
    }
  }

  public class Impl2 implements IInterface {
    // summary=p;MultipleImpl2$IInterface;true;m;(Object);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;MultipleImpl2$IInterface;true;m;(Object);;Argument[0];ReturnValue;value;dfc-generated
    public Object m(Object value) {
      return value;
    }
  }
}
