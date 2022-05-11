// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace NetworkInformation
        {
            // Generated from `System.Net.NetworkInformation.IPStatus` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum IPStatus
            {
                BadDestination,
                BadHeader,
                BadOption,
                BadRoute,
                DestinationHostUnreachable,
                DestinationNetworkUnreachable,
                DestinationPortUnreachable,
                DestinationProhibited,
                DestinationProtocolUnreachable,
                DestinationScopeMismatch,
                DestinationUnreachable,
                HardwareError,
                IcmpError,
                NoResources,
                PacketTooBig,
                ParameterProblem,
                SourceQuench,
                Success,
                TimeExceeded,
                TimedOut,
                TtlExpired,
                TtlReassemblyTimeExceeded,
                Unknown,
                UnrecognizedNextHeader,
            }

            // Generated from `System.Net.NetworkInformation.Ping` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Ping : System.ComponentModel.Component
            {
                protected override void Dispose(bool disposing) => throw null;
                protected void OnPingCompleted(System.Net.NetworkInformation.PingCompletedEventArgs e) => throw null;
                public Ping() => throw null;
                public event System.Net.NetworkInformation.PingCompletedEventHandler PingCompleted;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, int timeout) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, int timeout, System.Byte[] buffer) => throw null;
                public System.Net.NetworkInformation.PingReply Send(System.Net.IPAddress address, int timeout, System.Byte[] buffer, System.Net.NetworkInformation.PingOptions options) => throw null;
                public System.Net.NetworkInformation.PingReply Send(string hostNameOrAddress) => throw null;
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

            // Generated from `System.Net.NetworkInformation.PingCompletedEventArgs` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PingCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
            {
                internal PingCompletedEventArgs() : base(default(System.Exception), default(bool), default(object)) => throw null;
                public System.Net.NetworkInformation.PingReply Reply { get => throw null; }
            }

            // Generated from `System.Net.NetworkInformation.PingCompletedEventHandler` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void PingCompletedEventHandler(object sender, System.Net.NetworkInformation.PingCompletedEventArgs e);

            // Generated from `System.Net.NetworkInformation.PingException` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PingException : System.InvalidOperationException
            {
                protected PingException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public PingException(string message) => throw null;
                public PingException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.PingOptions` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PingOptions
            {
                public bool DontFragment { get => throw null; set => throw null; }
                public PingOptions() => throw null;
                public PingOptions(int ttl, bool dontFragment) => throw null;
                public int Ttl { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.NetworkInformation.PingReply` in `System.Net.Ping, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
