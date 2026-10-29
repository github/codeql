internal class TokenCacheThreadUnsafeICryptoTransformDemoFixed
{
    // We are replacing the static SHA256 field with an instance one
    //
    //private static SHA256 _sha = SHA256.Create();
    private SHA256 _sha = SHA256.Create();

    public string ComputeHash(string data)
    {
        byte[] passwordBytes = UTF8Encoding.UTF8.GetBytes(data);
        return Convert.ToBase64String(_sha.ComputeHash(passwordBytes));
    }
}

class Program
{
    static void Main(string[] args)
    {
        int max = 1000;
        Task[] tasks = new Task[max];

        Action<object> action = (object obj) =>
        {
            var safeObj = new TokenCacheThreadUnsafeICryptoTransformDemoFixed();
            if (safeObj.ComputeHash((string)obj) != "ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0=")
            {
                Console.WriteLine("**** We got incorrect Results!!! ****");
            }
        };

        for (int i = 0; i < max; i++)
        {
            // hash calculated on all threads should be the same:
            // ungWv48Bz+pBQUDeXa4iI7ADYaOWF3qctBD/YfIAFa0= (base64)
            // 
            tasks[i] = Task.Factory.StartNew(action, "abc");
        }

        Task.WaitAll(tasks);
    }
}
