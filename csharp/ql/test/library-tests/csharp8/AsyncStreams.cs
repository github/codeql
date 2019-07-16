// semmle-extractor-options: /r:System.Threading.Tasks.dll /r:System.Threading.Tasks.Extensions.dll /r:netstandard.dll /langversion:preview

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

class AsyncStreams
{
    async IAsyncEnumerable<int> Items() {
        yield return 1;
        yield return 2;
        await Task.Delay(1000);
        yield return 3;
    }

    async void F()
    {
        await foreach(var item in Items())
            Console.WriteLine(item);
    }
}

namespace System
{
    interface IAsyncDisposable
    {
        System.Threading.Tasks.ValueTask DisposeAsync();
    }
}

namespace System.Collections.Generic
{
    interface IAsyncEnumerable<out T>
    {
        public System.Collections.Generic.IAsyncEnumerator<T> GetAsyncEnumerator (System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
    }

    interface IAsyncEnumerator<out T> : IAsyncDisposable
    {
        T Current { get; }
        System.Threading.Tasks.ValueTask<bool> MoveNextAsync();
    }
}
