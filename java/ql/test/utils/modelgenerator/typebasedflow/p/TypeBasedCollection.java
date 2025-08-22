package p;

import java.util.ArrayList;
import java.util.List;

public class TypeBasedCollection<T> extends ArrayList<T> {

  // summary=p;TypeBasedCollection;true;addT;(Object);;Argument[0];Argument[this].Element;value;tb-generated
  public void addT(T x) {}

  // summary=p;TypeBasedCollection;true;addManyT;(List);;Argument[0].Element;Argument[this].Element;value;tb-generated
  public void addManyT(List<T> xs) {}

  // summary=p;TypeBasedCollection;true;firstT;();;Argument[this].Element;ReturnValue;value;tb-generated
  public T firstT() {
    return null;
  }

  // summary=p;TypeBasedCollection;true;getManyT;();;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public List<T> getManyT() {
    return null;
  }
}
