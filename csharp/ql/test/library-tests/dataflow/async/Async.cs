using System.Threading.Tasks;

class Test
{
    private void Sink(string s)
    {
    }

    public void TestNonAwait(string input)
    {
        Sink(Return(input)); // True positive
    }

    private string Return(string x)
    {
        return x;
    }

    public async Task TestAwait1(string input)
    {
        Sink(await ReturnAwait(input)); // False negative
    }

    public async Task TestAwait2(string input)
    {
        var x = await ReturnAwait(input);
        Sink(x); // False negative
    }

    public void TestAwait3(string input)
    {
        Sink(ReturnAwait(input).Result); // False negative
    }

    private async Task<string> ReturnAwait(string x)
    {
        await Task.Delay(1);
        return x;
    }

    public void TestTask(string input)
    {
        Sink(ReturnTask(input).Result); // True positive
    }

    private Task<string> ReturnTask(string x)
    {
        return Task.FromResult(x);
    }
}