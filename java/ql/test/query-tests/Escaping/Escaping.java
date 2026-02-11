@ThreadSafe
public class Escaping {
  int x;  //$ Alert
  public int y = 0;  //$ Alert
  private int z = 3;
  final int w = 0;
  public final int u = 4;
  private final long a = 5;
  protected long b = 0;  //$ Alert
  protected final long c = 0L;
  volatile long d = 3;
  protected volatile long e = 3L;

  public void methodLocal() {
    int i;
  }
}