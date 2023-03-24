import java.util.Collection;

public class Test {

  public Collection<? extends CharSequence> getCollection() {
    return null;
  }

  public void test() {
    this.getCollection().isEmpty();
  }

}
