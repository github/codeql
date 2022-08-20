using System;

public class Deconstruction
{
    public void M1()
    {
        // Declaration and Assignment
        (int x1, int y1) = (10, 11);

        // Assignment
        int x2 = 0;
        int y2 = 0;
        (x2, y2) = (20, 21);

        // Mixed
        int y3 = 0;
        (int x3, y3) = (30, 31);

        int x4 = 0;
        (x4, int y4) = (40, 41);

        // Nested, Mixed
        int x5 = 0;
        int y51 = 0;
        (x5, (int y50, y51)) = (50, (51, 52));
    }
}