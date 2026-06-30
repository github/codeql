using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

public class BadFetcher
{
    // BAD: a hand-written RFC 1918 / loopback / metadata denylist matched against the
    // textual host. The embedded IPv4 inside `::ffff:169.254.169.254` is never seen, so a
    // transition-wrapped internal address is classified as public and the request reaches it.
    private static bool IsPrivateHost(string host)
    {
        return host == "127.0.0.1"
            || host == "169.254.169.254"
            || host.StartsWith("10.")
            || host.StartsWith("192.168")
            || host.StartsWith("172.16");
    }

    public static async Task<string> FetchAsync(string host)
    {
        if (IsPrivateHost(host))
        {
            throw new Exception("blocked internal host");
        }

        using var client = new HttpClient();
        return await client.GetStringAsync("http://" + host + "/");
    }
}
