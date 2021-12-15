public static void RunThreadUnSafeICryptoTransformLambdaFixed()
{
    const int threadCount = 4;
    var b = new Barrier(threadCount);
    Action start = () => {
        b.SignalAndWait();
        // The hash object is no longer shared
        for (int i = 0; i < 1000; i++)
        {
            var sha1 = SHA1.Create();
            var pwd = Guid.NewGuid().ToString();
            var bytes = Encoding.UTF8.GetBytes(pwd);
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
