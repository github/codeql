package p;

import java.util.ArrayList;
import java.util.List;

public class TypeBasedCollection<T> extends ArrayList<T> {

  // heuristic-summary=p;TypeBasedCollection;true;addT;(Object);;Argument[0];Argument[this].Element;value;tb-generated
  public void addT(T x) {}

  // heuristic-summary=p;TypeBasedCollection;true;addManyT;(List);;Argument[0].Element;Argument[this].Element;value;tb-generated
  public void addManyT(List<T> xs) {}

  // heuristic-summary=p;TypeBasedCollection;true;firstT;();;Argument[this].Element;ReturnValue;value;tb-generated
  public T firstT() {
    return null;
  }

  // heuristic-summary=p;TypeBasedCollection;true;getManyT;();;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public List<T> getManyT() {
    return null;
  }
}
