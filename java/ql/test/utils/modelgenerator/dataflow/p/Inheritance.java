package p;

public class Inheritance {
  private abstract class BasePrivate {
    public abstract String id(String s);
  }

  public abstract class BasePublic {
    public abstract String id(String s);
  }

  public class AImplBasePrivateImpl extends BasePrivate {
    // summary=p;Inheritance$AImplBasePrivateImpl;true;id;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;Inheritance$AImplBasePrivateImpl;true;id;(String);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String id(String s) {
      return s;
    }
  }

  public class AImplBasePublic extends BasePublic {
    // summary=p;Inheritance$BasePublic;true;id;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;Inheritance$BasePublic;true;id;(String);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String id(String s) {
      return s;
    }
  }

  private interface IPrivate1 {
    String id(String s);
  }

  private interface IPrivate2 {
    String id(String s);
  }

  public interface IPublic1 {
    String id(String s);
  }

  public interface IPublic2 {
    String id(String s);
  }

  public abstract class B implements IPublic1 {
    public abstract String id(String s);
  }

  public abstract class C implements IPrivate1 {
    public abstract String id(String s);
  }

  private abstract class D implements IPublic2 {
    public abstract String id(String s);
  }

  private abstract class E implements IPrivate2 {
    public abstract String id(String s);
  }

  public class BImpl extends B {
    // summary=p;Inheritance$IPublic1;true;id;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;Inheritance$IPublic1;true;id;(String);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String id(String s) {
      return s;
    }
  }

  public class CImpl extends C {
    // summary=p;Inheritance$C;true;id;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;Inheritance$C;true;id;(String);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String id(String s) {
      return s;
    }
  }

  public class DImpl extends D {
    // summary=p;Inheritance$IPublic2;true;id;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;Inheritance$IPublic2;true;id;(String);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String id(String s) {
      return s;
    }
  }

  public class EImpl extends E {
    // summary=p;Inheritance$EImpl;true;id;(String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=p;Inheritance$EImpl;true;id;(String);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String id(String s) {
      return s;
    }
  }

  public interface INeutral {
    String id(String s);
  }

  public class F implements INeutral {
    // neutral=p;Inheritance$F;id;(String);summary;df-generated
    public String id(String s) {
      return "";
    }
  }

  public class G implements INeutral {
    // neutral=p;Inheritance$G;id;(String);summary;df-generated
    public String id(String s) {
      return "";
    }
  }

  private class H implements INeutral {
    public String id(String s) {
      return "";
    }
  }
}
