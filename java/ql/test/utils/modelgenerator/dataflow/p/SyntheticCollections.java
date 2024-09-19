package p;

public class SyntheticCollections {
  private String[] array;

  // summary=p;SyntheticCollections;true;SyntheticCollections;(String[]);;Argument[0].ArrayElement;Argument[this];taint;df-generated
  public SyntheticCollections(String[] array) {
    this.array = array;
  }

  // summary=p;SyntheticCollections;true;getElement;(Integer);;Argument[this];ReturnValue;taint;df-generated
  public String getElement(Integer index) {
    return array[index];
  }
}
