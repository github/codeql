@ThreadSafe
public class SafePublication {
    int x;
    int y = 0;
    int z = 3;   //$ Alert
    int w;       //$ Alert
    int u;       //$ Alert
    long a;
    long b = 0;
    long c = 0L;
    long d = 3;  //$ Alert
    long e = 3L; //$ Alert

    int[] arr = new int[3]; //$ Alert
    float f = 0.0f;
    double dd = 00.0d;
    char cc = 'a';  //$ Alert
    char ok = '\u0000';

 public SafePublication(int a) {
    x = 0;
    w = 3; // not ok
    u = a; // not ok
  }

  public void methodLocal() {
    int i;
  }
}