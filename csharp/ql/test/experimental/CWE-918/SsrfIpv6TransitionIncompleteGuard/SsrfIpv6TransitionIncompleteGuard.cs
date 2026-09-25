using System;

namespace SsrfIpv6TransitionTest
{
    public class HostGuards
    {
        // BAD: a hand-written RFC 1918 / loopback / metadata denylist matched against the
        // textual host. The embedded IPv4 inside `::ffff:10.0.0.1` is never seen.
        public static bool ValidateTargetHost(string host) // NOT OK
        {
            if (host == "127.0.0.1"
                || host == "169.254.169.254"
                || host.StartsWith("10.")
                || host.StartsWith("192.168")
                || host.StartsWith("172.16"))
            {
                throw new Exception("blocked internal host");
            }
            return true;
        }

        // BAD: an `IsPrivateHost`-named guard that only does the partial `::ffff:` unwrap via
        // `IsIPv4MappedToIPv6` / `MapToIPv4`, leaving NAT64 and 6to4 forms live.
        public static bool IsPrivateHostAddress(FakeIPAddress addr) // NOT OK
        {
            if (addr.IsIPv4MappedToIPv6)
            {
                addr = addr.MapToIPv4();
            }
            return addr.ToString().StartsWith("10.")
                || addr.ToString() == "127.0.0.1";
        }

        // OK: this guard uses a hand-rolled denylist, but it first unwraps every
        // IPv6-transition family via explicit prefix literals before the check.
        public static bool CheckHostUnwrapped(string host) // OK
        {
            string h = host;
            if (h.StartsWith("64:ff9b:"))
            {
                h = ExtractNat64(h);
            }
            else if (h.StartsWith("2002:"))
            {
                h = ExtractSixToFour(h);
            }
            else if (h.StartsWith("::ffff:"))
            {
                h = h.Substring("::ffff:".Length);
            }
            return h.StartsWith("10.") || h == "127.0.0.1" || h == "169.254.169.254";
        }

        // OK: a transition-extract helper (named `Nat64`) is used, so the guard is complete.
        public static bool ValidateHostViaHelper(string host) // OK
        {
            string embedded = ExtractNat64FromTransition(host);
            return embedded.StartsWith("10.") || embedded == "127.0.0.1";
        }

        // OK: not an SSRF host/url/ip validator by name, so it is not in scope even though it
        // matches an RFC 1918 literal.
        public static bool FormatBanner(string s) // OK
        {
            return s == "10.0.0.1";
        }

        private static string ExtractNat64(string h) => h;

        private static string ExtractSixToFour(string h) => h;

        private static string ExtractNat64FromTransition(string h) => h;
    }

    // Minimal local stand-in so the test compiles without the System.Net stub; the query
    // matches on the member *names* `IsIPv4MappedToIPv6` / `MapToIPv4`.
    public class FakeIPAddress
    {
        public bool IsIPv4MappedToIPv6 { get; set; }

        public FakeIPAddress MapToIPv4() => this;
    }
}
