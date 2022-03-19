// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.Dns` in `System.Net.NameResolution, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Dns
        {
            public static System.IAsyncResult BeginGetHostAddresses(string hostNameOrAddress, System.AsyncCallback requestCallback, object state) => throw null;
            public static System.IAsyncResult BeginGetHostByName(string hostName, System.AsyncCallback requestCallback, object stateObject) => throw null;
            public static System.IAsyncResult BeginGetHostEntry(System.Net.IPAddress address, System.AsyncCallback requestCallback, object stateObject) => throw null;
            public static System.IAsyncResult BeginGetHostEntry(string hostNameOrAddress, System.AsyncCallback requestCallback, object stateObject) => throw null;
            public static System.IAsyncResult BeginResolve(string hostName, System.AsyncCallback requestCallback, object stateObject) => throw null;
            public static System.Net.IPAddress[] EndGetHostAddresses(System.IAsyncResult asyncResult) => throw null;
            public static System.Net.IPHostEntry EndGetHostByName(System.IAsyncResult asyncResult) => throw null;
            public static System.Net.IPHostEntry EndGetHostEntry(System.IAsyncResult asyncResult) => throw null;
            public static System.Net.IPHostEntry EndResolve(System.IAsyncResult asyncResult) => throw null;
            public static System.Net.IPAddress[] GetHostAddresses(string hostNameOrAddress) => throw null;
            public static System.Threading.Tasks.Task<System.Net.IPAddress[]> GetHostAddressesAsync(string hostNameOrAddress) => throw null;
            public static System.Net.IPHostEntry GetHostByAddress(System.Net.IPAddress address) => throw null;
            public static System.Net.IPHostEntry GetHostByAddress(string address) => throw null;
            public static System.Net.IPHostEntry GetHostByName(string hostName) => throw null;
            public static System.Net.IPHostEntry GetHostEntry(System.Net.IPAddress address) => throw null;
            public static System.Net.IPHostEntry GetHostEntry(string hostNameOrAddress) => throw null;
            public static System.Threading.Tasks.Task<System.Net.IPHostEntry> GetHostEntryAsync(System.Net.IPAddress address) => throw null;
            public static System.Threading.Tasks.Task<System.Net.IPHostEntry> GetHostEntryAsync(string hostNameOrAddress) => throw null;
            public static string GetHostName() => throw null;
            public static System.Net.IPHostEntry Resolve(string hostName) => throw null;
        }

        // Generated from `System.Net.IPHostEntry` in `System.Net.NameResolution, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class IPHostEntry
        {
            public System.Net.IPAddress[] AddressList { get => throw null; set => throw null; }
            public string[] Aliases { get => throw null; set => throw null; }
            public string HostName { get => throw null; set => throw null; }
            public IPHostEntry() => throw null;
        }

    }
}
