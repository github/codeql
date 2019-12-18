public class A {

  public interface Cond {
    boolean cond();
  }

  void test1(int x, Cond c) {
    int i;

    // --- do loops ---

    do {
      if (c.cond())
        continue; // BAD
      if (c.cond())
        break;
    } while (false);

    do {
      if (c.cond())
        continue;
      if (c.cond())
        break;
    } while (true);

    do {
      if (c.cond())
        continue;
      if (c.cond())
        break;
    } while (c.cond());

    // --- while, for loops ---

    while (false) {
      if (c.cond())
        continue; // GOOD [never reached, if the condition changed so it was then the result would no longer apply]
      if (c.cond())
        break;
    }

    for (i = 0; false; i++) {
      if (c.cond())
        continue; // GOOD [never reached, if the condition changed so it was then the result would no longer apply]
      if (c.cond())
        break;
    }

    // --- nested loops ---

    do {
      do {
        if (c.cond())
          continue; // BAD
        if (c.cond())
          break;
      } while (false);
      if (c.cond())
        break;
    } while (true);

    do {
      do {
        if (c.cond())
          continue; // GOOD
        if (c.cond())
          break;
      } while (true);
    } while (false);

    do {
      switch (x) {
      case 1:
        // do [1]
        break; // break out of the switch
      default:
        // do [2]
        // break out of the loop entirely, skipping [3]
        continue; // BAD; labelled break is better
      };
      // do [3]
    } while (false);
  }
}
