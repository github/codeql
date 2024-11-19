package p;

public final class InnerHolder {

  private class Context {
    private String value;

    Context(String value) {
      this.value = value;
    }

    public String getValue() {
      return value;
    }
  }

  private Context context = null;

  private StringBuilder sb = new StringBuilder();

  // summary=p;InnerHolder;false;setContext;(String);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;InnerHolder;false;setContext;(String);;Argument[0];Argument[this].SyntheticField[p.InnerHolder.context].SyntheticField[p.InnerHolder$Context.value];value;dfc-generated
  public void setContext(String value) {
    context = new Context(value);
  }

  // summary=p;InnerHolder;false;explicitSetContext;(String);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;InnerHolder;false;explicitSetContext;(String);;Argument[0];Argument[this].SyntheticField[p.InnerHolder.context].SyntheticField[p.InnerHolder$Context.value];value;dfc-generated
  public void explicitSetContext(String value) {
    this.context = new Context(value);
  }

  // summary=p;InnerHolder;false;append;(String);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;InnerHolder;false;append;(String);;Argument[0];Argument[this].SyntheticField[p.InnerHolder.sb];taint;dfc-generated
  public void append(String value) {
    sb.append(value);
  }

  // summary=p;InnerHolder;false;getValue;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;InnerHolder;false;getValue;();;Argument[this].SyntheticField[p.InnerHolder.sb];ReturnValue;taint;dfc-generated
  public String getValue() {
    return sb.toString();
  }

  // summary=p;InnerHolder;false;getContextValue;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;InnerHolder;false;getContextValue;();;Argument[this].SyntheticField[p.InnerHolder.context].SyntheticField[p.InnerHolder$Context.value];ReturnValue;value;dfc-generated
  public String getContextValue() {
    return context.getValue();
  }
}
