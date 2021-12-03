using System.Threading.Tasks;

class Test
{
    private void Sink(string s)
    {
    }

    public void TestNonAwait(string input)
    {
        Sink(Return(input));
    }

    private string Return(string x)
    {
        return x;
    }

    public async Task TestAwait1(string input)
    {
        Sink(await ReturnAwait(input));
    }

    public async Task TestAwait2(string input)
    {
        var x = await ReturnAwait(input);
        Sink(x);
    }

    public void TestAwait3(string input)
    {
        Sink(ReturnAwait2(input).Result);
    }

    private async Task<string> ReturnAwait(string x)
    {
        await Task.Delay(1);
        return x;
    }

    public void TestTask(string input)
    {
        Sink(ReturnTask(input).Result);
    }

    private Task<string> ReturnTask(string x)
    {
        return Task.FromResult(x);
    }

    private async Task<string> ReturnAwait2(string x) => x;
}