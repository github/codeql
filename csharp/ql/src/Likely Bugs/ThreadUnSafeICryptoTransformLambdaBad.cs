public static void RunThreadUnSafeICryptoTransformLambdaBad()
{
    const int threadCount = 4;
    // This local variable for a hash object is going to be shared across multiple threads
    var sha1 = SHA1.Create();
    var b = new Barrier(threadCount);
    Action start = () => {
        b.SignalAndWait();
        for (int i = 0; i < 1000; i++)
        {
            var pwd = Guid.NewGuid().ToString();
            var bytes = Encoding.UTF8.GetBytes(pwd);
            // This call may fail, or return incorrect results
            sha1.ComputeHash(bytes);
        }
    };
    var threads = Enumerable.Range(0, threadCount)
                            .Select(_ => new ThreadStart(start))
                            .Select(x => new Thread(x))
                            .ToList();
    foreach (var t in threads) t.Start();
    foreach (var t in threads) t.Join();
}
