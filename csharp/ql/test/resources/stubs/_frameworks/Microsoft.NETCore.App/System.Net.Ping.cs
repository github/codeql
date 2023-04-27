// This file contains auto-generated code.
// Generated from `System.Net.Ping, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Net
    {
        namespace NetworkInformation
        {
            public enum IPStatus : int
            {
                BadDestination = 11018,
                BadHeader = 11042,
                BadOption = 11007,
                BadRoute = 11012,
                DestinationHostUnreachable = 11003,
                DestinationNetworkUnreachable = 11002,
                DestinationPortUnreachable = 11005,
                DestinationProhibited = 11004,
                DestinationProtocolUnreachable = 11004,
                DestinationScopeMismatch = 11045,
                DestinationUnreachable = 11040,
                HardwareError = 11008,
                IcmpError = 11044,
                NoResources = 11006,
                PacketTooBig = 11009,
                ParameterProblem = 11015,
                SourceQuench = 11016,
                Success = 0,
                TimeExceeded = 11041,
                TimedOut = 11010,
                TtlExpired = 11013,
                TtlReassemblyTimeExceeded = 11014,
                Unknown = -1,
                UnrecognizedNextHeader = 11043,
            }

            public class Ping : System.ComponentModel.Component
            {
                protected override void Dispose(bool disposing) => throw null;
                protected void OnPingCompleted(System.Net.NetworkInformation.PingCompletedEventArgs e) => throw null;
                public Ping() => throw null;
                public event System.Net.NetworkInformation.PingCompletedEventHandler PingCompleted;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, System.TimeSpan timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, int timeout) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, int timeout, System.Byte[] buffer) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
                public System.Net.NetworkInformation.PingReply Send(string hostNameOrAddress) => throw null;
                public System.Net.NetworkInformation.PingReply Send(string hostNameOrAddress, System.TimeSpan timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
                public System.Net.NetworkInformation.PingReply Send(string hostNameOrAddress, int timeout) => throw null;
                public System.Net.NetworkInformation.PingReply Send(string hostNameOrAddress, int timeout, System.Byte[] buffer) => throw null;
                public System.Net.NetworkInformation.PingReply Send(string hostNameOrAddress, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
                public void SendAsync(System.Net.IPAddress address, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options, object userToken) => throw null;
                public void SendAsync(System.Net.IPAddress address, int timeout, System.Byte[] buffer, object userToken) => throw null;
                public void SendAsync(System.Net.IPAddress address, int timeout, object userToken) => throw null;
                public void SendAsync(System.Net.IPAddress address, object userToken) => throw null;
                public void SendAsync(string hostNameOrAddress, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options, object userToken) => throw null;
                public void SendAsync(string hostNameOrAddress, int timeout, System.Byte[] buffer, object userToken) => throw null;
                public void SendAsync(string hostNameOrAddress, int timeout, object userToken) => throw null;
                public void SendAsync(string hostNameOrAddress, object userToken) => throw null;
                public void SendAsyncCancel() => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(System.Net.IPAddress address) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(System.Net.IPAddress address, int timeout) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(System.Net.IPAddress address, int timeout, System.Byte[] buffer) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(System.Net.IPAddress address, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(string hostNameOrAddress) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(string hostNameOrAddress, int timeout) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(string hostNameOrAddress, int timeout, System.Byte[] buffer) => throw null;
                public System.Threading.Tasks.Task<System.Net.NetworkInformation.PingReply> SendPingAsync(string hostNameOrAddress, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
            }

            public class PingCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
            {
                internal PingCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
                public System.Net.NetworkInformation.PingReply Reply { get => throw null; }
            }

            public delegate void PingCompletedEventHandler(object sender, System.Net.NetworkInformation.PingCompletedEventArgs e);

            public class PingException : System.InvalidOperationException
            {
                protected PingException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public PingException(string message) => throw null;
                public PingException(string message, System.Exception innerException) => throw null;
            }

            public class PingOptions
            {
                public bool DontFragment { get => throw null; set => throw null; }
                public PingOptions() => throw null;
                public PingOptions(int ttl, bool dontFragment) => throw null;
                public int Ttl { get => throw null; set => throw null; }
            }

            public class PingReply
            {
                public System.Net.IPAddress Address { get => throw null; }
                public System.Byte[] Buffer { get => throw null; }
                public System.Net.NetworkInformation.PingOptions Options { get => throw null; }
                public System.Int64 RoundtripTime { get => throw null; }
                public System.Net.NetworkInformation.IPStatus Status { get => throw null; }
            }

        }
    }
}
