public class A {
  public void action() { }

  public void always_dom1() {
    action();
  }

  public void always_dom2(boolean b) {
    if (b) { } else { }
    action();
  }

  public void always_path(boolean b) {
    if (b) {
      action();
    } else {
      action();
    }
  }

  public void always_w_call(boolean b1, boolean b2) {
    if (b1) {
      action();
    } else if (b2) {
      always_dom2(b1);
    } else {
      always_path(b2);
    }
  }

  public void not_always_none() {
  }

  public void not_always_one(boolean b) {
    if (b) {
      action();
    }
  }

  public void not_always_two(boolean b1, boolean b2) {
    if (b1) {
      if (b2) {
        action();
      } else {
        action();
      }
    }
  }
}
