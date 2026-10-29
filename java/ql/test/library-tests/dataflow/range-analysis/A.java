public class A {
  int f1(int x, int y) {
    if (x < 500) {
      if (x > 400) {
        return x;
      }

      if (y - 2 == x && y > 300) {
        return x + y;
      }

      if (x != y + 1) {
        int sum = x + y; // x <= 400
      } else {
        if (y > 300) {
          int sum = x + y; // 302 <= x <= 400, y = x - 1, 301 <= y <= 399
        }
      }

      if (x > 500) {
        return x;
      }
    }

    return 0;
  }

  int f2(int x, int y, int z) {
    if (x < 500) {
      if (x > 400) {
        return x;
      }

      if (y == x - 1 && y > 300 && y + 2 == z && z == 350) {
        return x + y + z;
      }
    }

    return 0;
  }
}
