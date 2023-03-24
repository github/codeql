import java.util.Map;

public class ExposesRep {
  private String[] strings;
  private Map<String, String> stringMap;

  public ExposesRep() {
    strings = new String[1];
  }

  public String[] getStrings() { return strings; }

  public Map<String, String> getStringMap() {
    return stringMap;
  }

  public void setStrings(String[] ss) {
    this.strings = ss;
  }

  public void setStringMap(Map<String, String> m) {
    this.stringMap = m;
  }
}

class GenericExposesRep<T> {
  private T[] array;

  public T[] getArray() { return array; }
}
