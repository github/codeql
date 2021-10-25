import org.junit.jupiter.api.Test;

public class E {
  public void f(Object obj) {
    obj.hashCode();
  }

  @Test
  public void fTest() {
    f(null);
  }

  public interface I {
    void run();
  }

  public void runI(I i) {
    i.run();
  }

  @Test
  public void fTest2() {
    runI(() -> f(null));
  }
}
