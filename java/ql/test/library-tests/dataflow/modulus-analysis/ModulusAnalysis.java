class ModulusAnalysis
{
    final int c1 = 42;
    final int c2 = 43;

    void m(int i, boolean cond, int x, int y, int[] arr) {
        int eq = i + 3;

        int mul = eq * c1 + 3; // congruent 3 mod 42

        int seven = 7;
        if (mul % c2 == seven) {
            System.out.println(mul); // congruent 3 mod 42, 7 mod 43
        }

        int j = cond
            ? i * 4 + 3
            : i * 8 + 7;
        System.out.println(j); // congruent 3 mod 4

        if (x % c1 == 3 && y % c1 == 7) {
            System.out.println(x + y); // congruent 10 mod 42
        }

        if (x % c1 == 3 && y % c1 == 7) {
            System.out.println(x - y); // congruent 38 mod 42
        }

        int l = arr.length * 4 - 11;
        System.out.println(l); // congruent 1 mod 4

        l = getArray().length * 4 - 11;
        System.out.println(l); // congruent 1 mod 4

        if (cond) {
            j = i * 4 + 3;
        }
        else {
            j = i * 8 + 7;
        }
        System.out.println(j); // congruent 3 mod 4

        if (cond) {
            System.out.println(j); // congruent 3 mod 4
        } else {
            System.out.println(j); // congruent 3 mod 4
        }

        if ((x & 15) == 3) {
            System.out.println(x); // congruent 3 mod 16
        }
    }

    int[] getArray(){ return new int[42]; }
}