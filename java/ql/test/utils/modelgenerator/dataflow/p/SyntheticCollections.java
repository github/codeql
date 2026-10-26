package p;

public class SyntheticCollections {
  private String[] array;

  // heuristic-summary=p;SyntheticCollections;true;SyntheticCollections;(String[]);;Argument[0].ArrayElement;Argument[this];taint;df-generated
  // contentbased-summary=p;SyntheticCollections;true;SyntheticCollections;(String[]);;Argument[0];Argument[this].SyntheticField[p.SyntheticCollections.array];value;dfc-generated
  public SyntheticCollections(String[] array) {
    this.array = array;
  }

  // heuristic-summary=p;SyntheticCollections;true;getElement;(Integer);;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;SyntheticCollections;true;getElement;(Integer);;Argument[this].SyntheticField[p.SyntheticCollections.array].ArrayElement;ReturnValue;value;dfc-generated
  public String getElement(Integer index) {
    return array[index];
  }
}
