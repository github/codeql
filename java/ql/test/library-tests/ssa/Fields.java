class Fields {
  public int[] xs;
  public static int[] stat;

  public Fields() { upd(); }

  public void upd() {
    xs = new int[1];
    stat = new int[0];
  }

  public void f() {
    int[] x = xs;
    upd();
    x = xs;
    if (x[0] > 2)
      upd();
    x = this.xs;
    xs = new int[2];
    x = xs;
  }

  public void g() {
    Fields f = new Fields();
    int[] y = f.xs;
    int[] z = xs;
    int[] w = stat;
    this.f();
    y = f.xs;
    z = xs;
    w = stat;
    f.f();
    y = f.xs;
    z = xs;
    w = stat;
    xs = new int[3];
    y = f.xs;
    z = xs;
    f.xs = new int[4];
    y = f.xs;
    z = xs;
    if (z[0] > 2)
      f = new Fields();
    y = f.xs;
    new Fields();
    y = f.xs;
    z = xs;
    w = stat;
  }
}
