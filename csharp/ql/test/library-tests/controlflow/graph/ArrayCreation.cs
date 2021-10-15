class ArrayCreation
{
    int[] M1() => new int[0];

    int[,] M2() => new int[0, 1];

    int[] M3() => new int[] { 0, 1 };

    int[,] M4() => new int[,] { { 0, 1 }, { 2, 3 } };
}
