public class ArrayTest {
    public void one_dim_init_acc() 
    {
        int[] one_dim = {100, 101, 102};
        one_dim[0] = 1000;
        one_dim[1] = one_dim[0];
        one_dim[1] = 1003;

        int i = 0;
        one_dim[i] = 0;
    }

    public void twod_and_init_acc() 
    {
         int[,] a = { {100, 101}, {102, 103} };
         int[,] b = new int[5, 5];
         int[,] c = new int[2, 2] { {100, 101}, {102, 103} };
         int[,] d = new int[,] { {100, 101}, {102, 103} };
         int[,] e = a;
         e[1, 1] = -1;
    }
}

