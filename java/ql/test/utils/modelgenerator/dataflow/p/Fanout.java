package p;

public class Fanout {
  public interface I1 {
    String getValue();
  }

  public interface I2 extends I1 {}

  public class Impl1 implements I1 {
    public String v;

    // summary=p;Fanout$I1;true;getValue;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=p;Fanout$Impl1;true;getValue;();;Argument[this].Field[p.Fanout$Impl1.v];ReturnValue;value;dfc-generated
    public String getValue() {
      return v;
    }
  }

  public class Impl2 implements I2 {
    public String v;

    // summary=p;Fanout$I1;true;getValue;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=p;Fanout$Impl2;true;getValue;();;Argument[this].Field[p.Fanout$Impl2.v];ReturnValue;value;dfc-generated
    public String getValue() {
      return v;
    }
  }

  public class Impl3 implements I2 {
    public String v;

    // summary=p;Fanout$I1;true;getValue;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=p;Fanout$Impl3;true;getValue;();;Argument[this].Field[p.Fanout$Impl3.v];ReturnValue;value;dfc-generated
    public String getValue() {
      return v;
    }
  }

  public class Impl4 implements I2 {
    public String v;

    // summary=p;Fanout$I1;true;getValue;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=p;Fanout$Impl4;true;getValue;();;Argument[this].Field[p.Fanout$Impl4.v];ReturnValue;value;dfc-generated
    public String getValue() {
      return v;
    }
  }

  // summary=p;Fanout;true;concatGetValueOnI1;(String,Fanout$I1);;Argument[0];ReturnValue;taint;df-generated
  // summary=p;Fanout;true;concatGetValueOnI1;(String,Fanout$I1);;Argument[1];ReturnValue;taint;df-generated
  // No content based summaries are expected for this method on parameter `i`
  // as the fanout (number of content flows) exceeds the limit of 3.
  // contentbased-summary=p;Fanout;true;concatGetValueOnI1;(String,Fanout$I1);;Argument[0];ReturnValue;taint;dfc-generated
  public String concatGetValueOnI1(String other, I1 i) {
    return other + i.getValue();
  }

  // summary=p;Fanout;true;concatGetValueOnI2;(String,Fanout$I2);;Argument[0];ReturnValue;taint;df-generated
  // summary=p;Fanout;true;concatGetValueOnI2;(String,Fanout$I2);;Argument[1];ReturnValue;taint;df-generated
  // contentbased-summary=p;Fanout;true;concatGetValueOnI2;(String,Fanout$I2);;Argument[0];ReturnValue;taint;dfc-generated
  // contentbased-summary=p;Fanout;true;concatGetValueOnI2;(String,Fanout$I2);;Argument[1].Field[p.Fanout$Impl2.v];ReturnValue;taint;dfc-generated
  // contentbased-summary=p;Fanout;true;concatGetValueOnI2;(String,Fanout$I2);;Argument[1].Field[p.Fanout$Impl3.v];ReturnValue;taint;dfc-generated
  // contentbased-summary=p;Fanout;true;concatGetValueOnI2;(String,Fanout$I2);;Argument[1].Field[p.Fanout$Impl4.v];ReturnValue;taint;dfc-generated
  public String concatGetValueOnI2(String other, I2 i) {
    return other + i.getValue();
  }
}
