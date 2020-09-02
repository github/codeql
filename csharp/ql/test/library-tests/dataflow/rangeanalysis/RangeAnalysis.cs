using System;

class RangeAnalysis
{
  int f1(int x, int y)
  {
    if (x < 500)
    {
      if (x > 400) // x <= 499
      {
        return x;  // 401 <= x <= 499
      }

      if (y == x && y > 300) // x <= 400, y <= 400
      {
        return x + y; // x <= 400, 301 <= y <= 400, missing: 301 <= x
      }

      if (x > 500)  // x <= 400
      {
        return x;  // x <= 400, x >= 501, not possible
      }
    }

    return 0;
  }
}