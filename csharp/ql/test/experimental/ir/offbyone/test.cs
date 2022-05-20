class ContainerLengthOffByOne
{
    public int[] arr;
    public string str;

    public static void Fun(int elem)
    {
    }

    public void Test1() 
    {
        int len1 = this.arr.Length;
        int len2 = len1 + 1;
        // OK
        for(int i = 0; i < len2 - 1; i++) 
        {
            ContainerLengthOffByOne.Fun(this.arr[i]);
        }
    }

    public void Test2() 
    {
        int len1 = this.arr.Length;

        int len2;
        if (len1 % 2 == 0)
            len2 = len1 + 1;
        else
            len2 = len1;
        // Not OK, PHI node where the upper bound
        // exceeds the size of the array.
        for(int i = 0; i < len2; i++) 
        {
            ContainerLengthOffByOne.Fun(this.arr[i]);
        }
    }

    public void Test3() 
    {
        int len1 = this.arr.Length;
        int len2 = len1 - 1;

        int len3;
        if (len2 % 2 == 0)
            len3 = len2 + 1;
        else
            len3 = len2;
        // OK, PHI node has bounds that ensure
        // we don't get an off by one error.
        for(int i = 0; i < len3; i++) 
        {
            ContainerLengthOffByOne.Fun(this.arr[i]);
        }
    }   

    public void Test4() 
    {
        int len1 = this.arr.Length;

        int len2 = len1 + 1;
        int len3 = len2 - 1;
        int len4 = len3 + 2;
        int len5 = len4 - 1;
        // Not OK, len5 is off by one.
        for(int i = 0; i < len5; i++) 
        {
            ContainerLengthOffByOne.Fun(this.arr[i]);
        }
    }

    public void Test5()
    {
        int len = this.str.Length;
        // Not OK; test for indexers
        for (int i = 0; i <= len; i++)
        {
            char c = str[i];
        }
    }

    public void Test6()
    {
        int len = this.arr.Length - 2;
        int len1 = len + 3;
        int len2 = len1 - 1;
        // Not OK, off by one
        // The test shows that more complex expressions are treated correctly
        for (int i = 0; i < len2; i++)
        {
            ContainerLengthOffByOne.Fun(this.arr[i + 1]);
        }
    }

    public void Test7()
    {
        int[] arrInit = { 1, 2, 3 };
        int len = (arrInit.Length * 2 + 2) / 2 * 2;
        int len1 = len / 2 - 3 + 4;
        // Not OK, len1 == this.arrInit + 1
        // This test shows that array initializer's length
        // are used in bounds
        for (int i = 0; i < len1; i++) 
        {
            ContainerLengthOffByOne.Fun(arrInit[i]);    
        }
    }
}
