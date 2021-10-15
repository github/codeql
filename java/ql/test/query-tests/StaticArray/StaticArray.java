class StaticArray
{
    public static final int[] bad = new int[42]; //NOT OK

    protected static final int[] good_protected = new int[42]; //OK (protected arrays are ok)
    /* default */ static final int[] good_default = new int[42]; //OK (default access arrays are ok)
    private static final int[] good_private = new int[42]; //OK (private arrays are ok)

    public final /* static */ int[] good_nonstatic = new int[42]; //OK (non-static arrays are ok)

    public /* final */ static int[] good_nonfinal = new int[42]; //OK (non-final arrays are ok)

    public static final Object good_not_array = new int[42]; //OK (non-arrays are ok)
    public static final int[][][] bad_multidimensional = new int[42][42][42]; //NOT OK
    public static final int[][][] bad_multidimensional_partial_init = new int[42][][]; //NOT OK

    public static final int[] bad_separate_init; //NOT OK 

    static {
	bad_separate_init = new int[42];
    }

    public static final int[] good_empty = new int[0]; //OK (empty array creation)
    public static final int[] good_empty2 = {}; //OK (empty array literal)
    public static final int[][] good_empty_multidimensional = new int[0][42]; //OK (empty array)
    public static final int[][] bad_nonempty = { {} }; //NOT OK (first dimension is 1, so not empty)

}
