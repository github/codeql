// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace Sockets
        {
            // Generated from `System.Net.Sockets.IOControlCode` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum IOControlCode
            {
                AbsorbRouterAlert,
                AddMulticastGroupOnInterface,
                AddressListChange,
                AddressListQuery,
                AddressListSort,
                AssociateHandle,
                AsyncIO,
                BindToInterface,
                DataToRead,
                DeleteMulticastGroupFromInterface,
                EnableCircularQueuing,
                Flush,
                GetBroadcastAddress,
                GetExtensionFunctionPointer,
                GetGroupQos,
                GetQos,
                KeepAliveValues,
                LimitBroadcasts,
                MulticastInterface,
                MulticastScope,
                MultipointLoopback,
                NamespaceChange,
                NonBlockingIO,
                OobDataRead,
                QueryTargetPnpHandle,
                ReceiveAll,
                ReceiveAllIgmpMulticast,
                ReceiveAllMulticast,
                RoutingInterfaceChange,
                RoutingInterfaceQuery,
                SetGroupQos,
                SetQos,
                TranslateHandle,
                UnicastInterface,
            }

            // Generated from `System.Net.Sockets.IPPacketInformation` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct IPPacketInformation
            {
                public static bool operator !=(System.Net.Sockets.IPPacketInformation packetInformation1, System.Net.Sockets.IPPacketInformation packetInformation2) => throw null;
                public static bool operator ==(System.Net.Sockets.IPPacketInformation packetInformation1, System.Net.Sockets.IPPacketInformation packetInformation2) => throw null;
                public System.Net.IPAddress Address { get => throw null; }
                public override bool Equals(object comparand) => throw null;
                public override int GetHashCode() => throw null;
                // Stub generator skipped constructor 
                public int Interface { get => throw null; }
            }

            // Generated from `System.Net.Sockets.IPProtectionLevel` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum IPProtectionLevel
            {
                EdgeRestricted,
                Restricted,
                Unrestricted,
                Unspecified,
            }

            // Generated from `System.Net.Sockets.IPv6MulticastOption` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IPv6MulticastOption
            {
                public System.Net.IPAddress Group { get => throw null; set => throw null; }
                public IPv6MulticastOption(System.Net.IPAddress group) => throw null;
                public IPv6MulticastOption(System.Net.IPAddress group, System.Int64 ifindex) => throw null;
                public System.Int64 InterfaceIndex { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Sockets.LingerOption` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class LingerOption
            {
                public bool Enabled { get => throw null; set => throw null; }
                public LingerOption(bool enable, int seconds) => throw null;
                public int LingerTime { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Sockets.MulticastOption` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MulticastOption
            {
                public System.Net.IPAddress Group { get => throw null; set => throw null; }
                public int InterfaceIndex { get => throw null; set => throw null; }
                public System.Net.IPAddress LocalAddress { get => throw null; set => throw null; }
                public MulticastOption(System.Net.IPAddress group) => throw null;
                public MulticastOption(System.Net.IPAddress group, System.Net.IPAddress mcint) => throw null;
                public MulticastOption(System.Net.IPAddress group, int interfaceIndex) => throw null;
            }

            // Generated from `System.Net.Sockets.NetworkStream` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NetworkStream : System.IO.Stream
            {
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int size, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int size, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public void Close(int timeout) => throw null;
                public virtual bool DataAvailable { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Int64 Length { get => throw null; }
                public NetworkStream(System.Net.Sockets.Socket socket) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket, System.IO.FileAccess access) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket, System.IO.FileAccess access, bool ownsSocket) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket, bool ownsSocket) => throw null;
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int size) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int size, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override int ReadTimeout { get => throw null; set => throw null; }
                protected bool Readable { get => throw null; set => throw null; }
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public System.Net.Sockets.Socket Socket { get => throw null; }
                public override void Write(System.Byte[] buffer, int offset, int size) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int size, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(System.Byte value) => throw null;
                public override int WriteTimeout { get => throw null; set => throw null; }
                protected bool Writeable { get => throw null; set => throw null; }
                // ERR: Stub generator didn't handle member: ~NetworkStream
            }

            // Generated from `System.Net.Sockets.ProtocolFamily` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ProtocolFamily
            {
                AppleTalk,
                Atm,
                Banyan,
                Ccitt,
                Chaos,
                Cluster,
                ControllerAreaNetwork,
                DataKit,
                DataLink,
                DecNet,
                Ecma,
                FireFox,
                HyperChannel,
                Ieee12844,
                ImpLink,
                InterNetwork,
                InterNetworkV6,
                Ipx,
                Irda,
                Iso,
                Lat,
                Max,
                NS,
                NetBios,
                NetworkDesigners,
                Osi,
                Packet,
                Pup,
                Sna,
                Unix,
                Unknown,
                Unspecified,
                VoiceView,
            }

            // Generated from `System.Net.Sockets.ProtocolType` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ProtocolType
            {
                Ggp,
                IP,
                IPSecAuthenticationHeader,
                IPSecEncapsulatingSecurityPayload,
                IPv4,
                IPv6,
                IPv6DestinationOptions,
                IPv6FragmentHeader,
                IPv6HopByHopOptions,
                IPv6NoNextHeader,
                IPv6RoutingHeader,
                Icmp,
                IcmpV6,
                Idp,
                Igmp,
                Ipx,
                ND,
                Pup,
                Raw,
                Spx,
                SpxII,
                Tcp,
                Udp,
                Unknown,
                Unspecified,
            }

            // Generated from `System.Net.Sockets.SafeSocketHandle` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeSocketHandle : Microsoft.Win32.SafeHandles.SafeHandleMinusOneIsInvalid
            {
                protected override bool ReleaseHandle() => throw null;
                public SafeSocketHandle(System.IntPtr preexistingHandle, bool ownsHandle) : base(default(bool)) => throw null;
            }

            // Generated from `System.Net.Sockets.SelectMode` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SelectMode
            {
                SelectError,
                SelectRead,
                SelectWrite,
            }

            // Generated from `System.Net.Sockets.SendPacketsElement` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SendPacketsElement
            {
                public System.Byte[] Buffer { get => throw null; }
                public int Count { get => throw null; }
                public bool EndOfPacket { get => throw null; }
                public string FilePath { get => throw null; }
                public System.IO.FileStream FileStream { get => throw null; }
                public int Offset { get => throw null; }
                public System.Int64 OffsetLong { get => throw null; }
                public SendPacketsElement(System.Byte[] buffer) => throw null;
                public SendPacketsElement(System.Byte[] buffer, int offset, int count) => throw null;
                public SendPacketsElement(System.Byte[] buffer, int offset, int count, bool endOfPacket) => throw null;
                public SendPacketsElement(System.IO.FileStream fileStream) => throw null;
                public SendPacketsElement(System.IO.FileStream fileStream, System.Int64 offset, int count) => throw null;
                public SendPacketsElement(System.IO.FileStream fileStream, System.Int64 offset, int count, bool endOfPacket) => throw null;
                public SendPacketsElement(string filepath) => throw null;
                public SendPacketsElement(string filepath, int offset, int count) => throw null;
                public SendPacketsElement(string filepath, int offset, int count, bool endOfPacket) => throw null;
                public SendPacketsElement(string filepath, System.Int64 offset, int count) => throw null;
                public SendPacketsElement(string filepath, System.Int64 offset, int count, bool endOfPacket) => throw null;
            }

            // Generated from `System.Net.Sockets.Socket` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Socket : System.IDisposable
            {
                public System.Net.Sockets.Socket Accept() => throw null;
                public bool AcceptAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
                public int Available { get => throw null; }
                public System.IAsyncResult BeginAccept(System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginAccept(System.Net.Sockets.Socket acceptSocket, int receiveSize, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginAccept(int receiveSize, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.IPAddress address, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.IPAddress[] addresses, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(string host, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginDisconnect(bool reuseSocket, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceiveFrom(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceiveMessageFrom(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSendFile(string fileName, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSendFile(string fileName, System.Byte[] preBuffer, System.Byte[] postBuffer, System.Net.Sockets.TransmitFileOptions flags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSendTo(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public void Bind(System.Net.EndPoint localEP) => throw null;
                public bool Blocking { get => throw null; set => throw null; }
                public static void CancelConnectAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public void Close() => throw null;
                public void Close(int timeout) => throw null;
                public void Connect(System.Net.EndPoint remoteEP) => throw null;
                public void Connect(System.Net.IPAddress address, int port) => throw null;
                public void Connect(System.Net.IPAddress[] addresses, int port) => throw null;
                public void Connect(string host, int port) => throw null;
                public bool ConnectAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public static bool ConnectAsync(System.Net.Sockets.SocketType socketType, System.Net.Sockets.ProtocolType protocolType, System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public bool Connected { get => throw null; }
                public void Disconnect(bool reuseSocket) => throw null;
                public bool DisconnectAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool DontFragment { get => throw null; set => throw null; }
                public bool DualMode { get => throw null; set => throw null; }
                public System.Net.Sockets.SocketInformation DuplicateAndClose(int targetProcessId) => throw null;
                public bool EnableBroadcast { get => throw null; set => throw null; }
                public System.Net.Sockets.Socket EndAccept(System.IAsyncResult asyncResult) => throw null;
                public System.Net.Sockets.Socket EndAccept(out System.Byte[] buffer, System.IAsyncResult asyncResult) => throw null;
                public System.Net.Sockets.Socket EndAccept(out System.Byte[] buffer, out int bytesTransferred, System.IAsyncResult asyncResult) => throw null;
                public void EndConnect(System.IAsyncResult asyncResult) => throw null;
                public void EndDisconnect(System.IAsyncResult asyncResult) => throw null;
                public int EndReceive(System.IAsyncResult asyncResult) => throw null;
                public int EndReceive(System.IAsyncResult asyncResult, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int EndReceiveFrom(System.IAsyncResult asyncResult, ref System.Net.EndPoint endPoint) => throw null;
                public int EndReceiveMessageFrom(System.IAsyncResult asyncResult, ref System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint endPoint, out System.Net.Sockets.IPPacketInformation ipPacketInformation) => throw null;
                public int EndSend(System.IAsyncResult asyncResult) => throw null;
                public int EndSend(System.IAsyncResult asyncResult, out System.Net.Sockets.SocketError errorCode) => throw null;
                public void EndSendFile(System.IAsyncResult asyncResult) => throw null;
                public int EndSendTo(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set => throw null; }
                public int GetRawSocketOption(int optionLevel, int optionName, System.Span<System.Byte> optionValue) => throw null;
                public object GetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName) => throw null;
                public void GetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, System.Byte[] optionValue) => throw null;
                public System.Byte[] GetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, int optionLength) => throw null;
                public System.IntPtr Handle { get => throw null; }
                public int IOControl(System.Net.Sockets.IOControlCode ioControlCode, System.Byte[] optionInValue, System.Byte[] optionOutValue) => throw null;
                public int IOControl(int ioControlCode, System.Byte[] optionInValue, System.Byte[] optionOutValue) => throw null;
                public bool IsBound { get => throw null; }
                public System.Net.Sockets.LingerOption LingerState { get => throw null; set => throw null; }
                public void Listen() => throw null;
                public void Listen(int backlog) => throw null;
                public System.Net.EndPoint LocalEndPoint { get => throw null; }
                public bool MulticastLoopback { get => throw null; set => throw null; }
                public bool NoDelay { get => throw null; set => throw null; }
                public static bool OSSupportsIPv4 { get => throw null; }
                public static bool OSSupportsIPv6 { get => throw null; }
                public static bool OSSupportsUnixDomainSockets { get => throw null; }
                public bool Poll(int microSeconds, System.Net.Sockets.SelectMode mode) => throw null;
                public System.Net.Sockets.ProtocolType ProtocolType { get => throw null; }
                public int Receive(System.Byte[] buffer) => throw null;
                public int Receive(System.Byte[] buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Receive(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers) => throw null;
                public int Receive(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Receive(System.Span<System.Byte> buffer) => throw null;
                public int Receive(System.Span<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Span<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public bool ReceiveAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int ReceiveBufferSize { get => throw null; set => throw null; }
                public int ReceiveFrom(System.Byte[] buffer, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(System.Byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(System.Byte[] buffer, ref System.Net.EndPoint remoteEP) => throw null;
                public bool ReceiveFromAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int ReceiveMessageFrom(System.Byte[] buffer, int offset, int size, ref System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, out System.Net.Sockets.IPPacketInformation ipPacketInformation) => throw null;
                public bool ReceiveMessageFromAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int ReceiveTimeout { get => throw null; set => throw null; }
                public System.Net.EndPoint RemoteEndPoint { get => throw null; }
                public System.Net.Sockets.SafeSocketHandle SafeHandle { get => throw null; }
                public static void Select(System.Collections.IList checkRead, System.Collections.IList checkWrite, System.Collections.IList checkError, int microSeconds) => throw null;
                public int Send(System.Byte[] buffer) => throw null;
                public int Send(System.Byte[] buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.Byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Send(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers) => throw null;
                public int Send(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Send(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public int Send(System.ReadOnlySpan<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.ReadOnlySpan<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public bool SendAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int SendBufferSize { get => throw null; set => throw null; }
                public void SendFile(string fileName) => throw null;
                public void SendFile(string fileName, System.Byte[] preBuffer, System.Byte[] postBuffer, System.Net.Sockets.TransmitFileOptions flags) => throw null;
                public bool SendPacketsAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int SendTimeout { get => throw null; set => throw null; }
                public int SendTo(System.Byte[] buffer, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(System.Byte[] buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(System.Byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(System.Byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public bool SendToAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public void SetIPProtectionLevel(System.Net.Sockets.IPProtectionLevel level) => throw null;
                public void SetRawSocketOption(int optionLevel, int optionName, System.ReadOnlySpan<System.Byte> optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, System.Byte[] optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, bool optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, int optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, object optionValue) => throw null;
                public void Shutdown(System.Net.Sockets.SocketShutdown how) => throw null;
                public Socket(System.Net.Sockets.AddressFamily addressFamily, System.Net.Sockets.SocketType socketType, System.Net.Sockets.ProtocolType protocolType) => throw null;
                public Socket(System.Net.Sockets.SafeSocketHandle handle) => throw null;
                public Socket(System.Net.Sockets.SocketInformation socketInformation) => throw null;
                public Socket(System.Net.Sockets.SocketType socketType, System.Net.Sockets.ProtocolType protocolType) => throw null;
                public System.Net.Sockets.SocketType SocketType { get => throw null; }
                public static bool SupportsIPv4 { get => throw null; }
                public static bool SupportsIPv6 { get => throw null; }
                public System.Int16 Ttl { get => throw null; set => throw null; }
                public bool UseOnlyOverlappedIO { get => throw null; set => throw null; }
                // ERR: Stub generator didn't handle member: ~Socket
            }

            // Generated from `System.Net.Sockets.SocketAsyncEventArgs` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SocketAsyncEventArgs : System.EventArgs, System.IDisposable
            {
                public System.Net.Sockets.Socket AcceptSocket { get => throw null; set => throw null; }
                public System.Byte[] Buffer { get => throw null; }
                public System.Collections.Generic.IList<System.ArraySegment<System.Byte>> BufferList { get => throw null; set => throw null; }
                public int BytesTransferred { get => throw null; }
                public event System.EventHandler<System.Net.Sockets.SocketAsyncEventArgs> Completed;
                public System.Exception ConnectByNameError { get => throw null; }
                public System.Net.Sockets.Socket ConnectSocket { get => throw null; }
                public int Count { get => throw null; }
                public bool DisconnectReuseSocket { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                public System.Net.Sockets.SocketAsyncOperation LastOperation { get => throw null; }
                public System.Memory<System.Byte> MemoryBuffer { get => throw null; }
                public int Offset { get => throw null; }
                protected virtual void OnCompleted(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Net.Sockets.IPPacketInformation ReceiveMessageFromPacketInfo { get => throw null; }
                public System.Net.EndPoint RemoteEndPoint { get => throw null; set => throw null; }
                public System.Net.Sockets.SendPacketsElement[] SendPacketsElements { get => throw null; set => throw null; }
                public System.Net.Sockets.TransmitFileOptions SendPacketsFlags { get => throw null; set => throw null; }
                public int SendPacketsSendSize { get => throw null; set => throw null; }
                public void SetBuffer(System.Byte[] buffer, int offset, int count) => throw null;
                public void SetBuffer(System.Memory<System.Byte> buffer) => throw null;
                public void SetBuffer(int offset, int count) => throw null;
                public SocketAsyncEventArgs() => throw null;
                public SocketAsyncEventArgs(bool unsafeSuppressExecutionContextFlow) => throw null;
                public System.Net.Sockets.SocketError SocketError { get => throw null; set => throw null; }
                public System.Net.Sockets.SocketFlags SocketFlags { get => throw null; set => throw null; }
                public object UserToken { get => throw null; set => throw null; }
                // ERR: Stub generator didn't handle member: ~SocketAsyncEventArgs
            }

            // Generated from `System.Net.Sockets.SocketAsyncOperation` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SocketAsyncOperation
            {
                Accept,
                Connect,
                Disconnect,
                None,
                Receive,
                ReceiveFrom,
                ReceiveMessageFrom,
                Send,
                SendPackets,
                SendTo,
            }

            // Generated from `System.Net.Sockets.SocketFlags` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SocketFlags
            {
                Broadcast,
                ControlDataTruncated,
                DontRoute,
                Multicast,
                None,
                OutOfBand,
                Partial,
                Peek,
                Truncated,
            }

            // Generated from `System.Net.Sockets.SocketInformation` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SocketInformation
            {
                public System.Net.Sockets.SocketInformationOptions Options { get => throw null; set => throw null; }
                public System.Byte[] ProtocolInformation { get => throw null; set => throw null; }
                // Stub generator skipped constructor 
            }

            // Generated from `System.Net.Sockets.SocketInformationOptions` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SocketInformationOptions
            {
                Connected,
                Listening,
                NonBlocking,
                UseOnlyOverlappedIO,
            }

            // Generated from `System.Net.Sockets.SocketOptionLevel` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SocketOptionLevel
            {
                IP,
                IPv6,
                Socket,
                Tcp,
                Udp,
            }

            // Generated from `System.Net.Sockets.SocketOptionName` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SocketOptionName
            {
                AcceptConnection,
                AddMembership,
                AddSourceMembership,
                BlockSource,
                Broadcast,
                BsdUrgent,
                ChecksumCoverage,
                Debug,
                DontFragment,
                DontLinger,
                DontRoute,
                DropMembership,
                DropSourceMembership,
                Error,
                ExclusiveAddressUse,
                Expedited,
                HeaderIncluded,
                HopLimit,
                IPOptions,
                IPProtectionLevel,
                IPv6Only,
                IpTimeToLive,
                KeepAlive,
                Linger,
                MaxConnections,
                MulticastInterface,
                MulticastLoopback,
                MulticastTimeToLive,
                NoChecksum,
                NoDelay,
                OutOfBandInline,
                PacketInformation,
                ReceiveBuffer,
                ReceiveLowWater,
                ReceiveTimeout,
                ReuseAddress,
                ReuseUnicastPort,
                SendBuffer,
                SendLowWater,
                SendTimeout,
                TcpKeepAliveInterval,
                TcpKeepAliveRetryCount,
                TcpKeepAliveTime,
                Type,
                TypeOfService,
                UnblockSource,
                UpdateAcceptContext,
                UpdateConnectContext,
                UseLoopback,
            }

            // Generated from `System.Net.Sockets.SocketReceiveFromResult` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SocketReceiveFromResult
            {
                public int ReceivedBytes;
                public System.Net.EndPoint RemoteEndPoint;
                // Stub generator skipped constructor 
            }

            // Generated from `System.Net.Sockets.SocketReceiveMessageFromResult` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SocketReceiveMessageFromResult
            {
                public System.Net.Sockets.IPPacketInformation PacketInformation;
                public int ReceivedBytes;
                public System.Net.EndPoint RemoteEndPoint;
                public System.Net.Sockets.SocketFlags SocketFlags;
                // Stub generator skipped constructor 
            }

            // Generated from `System.Net.Sockets.SocketShutdown` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SocketShutdown
            {
                Both,
                Receive,
                Send,
            }

            // Generated from `System.Net.Sockets.SocketTaskExtensions` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class SocketTaskExtensions
            {
                public static System.Threading.Tasks.Task<System.Net.Sockets.Socket> AcceptAsync(this System.Net.Sockets.Socket socket) => throw null;
                public static System.Threading.Tasks.Task<System.Net.Sockets.Socket> AcceptAsync(this System.Net.Sockets.Socket socket, System.Net.Sockets.Socket acceptSocket) => throw null;
                public static System.Threading.Tasks.Task ConnectAsync(this System.Net.Sockets.Socket socket, System.Net.EndPoint remoteEP) => throw null;
                public static System.Threading.Tasks.ValueTask ConnectAsync(this System.Net.Sockets.Socket socket, System.Net.EndPoint remoteEP, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task ConnectAsync(this System.Net.Sockets.Socket socket, System.Net.IPAddress address, int port) => throw null;
                public static System.Threading.Tasks.ValueTask ConnectAsync(this System.Net.Sockets.Socket socket, System.Net.IPAddress address, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task ConnectAsync(this System.Net.Sockets.Socket socket, System.Net.IPAddress[] addresses, int port) => throw null;
                public static System.Threading.Tasks.ValueTask ConnectAsync(this System.Net.Sockets.Socket socket, System.Net.IPAddress[] addresses, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task ConnectAsync(this System.Net.Sockets.Socket socket, string host, int port) => throw null;
                public static System.Threading.Tasks.ValueTask ConnectAsync(this System.Net.Sockets.Socket socket, string host, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<int> ReceiveAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.Task<int> ReceiveAsync(this System.Net.Sockets.Socket socket, System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.ValueTask<int> ReceiveAsync(this System.Net.Sockets.Socket socket, System.Memory<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveFromResult> ReceiveFromAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint) => throw null;
                public static System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveMessageFromResult> ReceiveMessageFromAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint) => throw null;
                public static System.Threading.Tasks.Task<int> SendAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.Task<int> SendAsync(this System.Net.Sockets.Socket socket, System.Collections.Generic.IList<System.ArraySegment<System.Byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.ValueTask<int> SendAsync(this System.Net.Sockets.Socket socket, System.ReadOnlyMemory<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> SendToAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<System.Byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
            }

            // Generated from `System.Net.Sockets.SocketType` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SocketType
            {
                Dgram,
                Raw,
                Rdm,
                Seqpacket,
                Stream,
                Unknown,
            }

            // Generated from `System.Net.Sockets.TcpClient` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TcpClient : System.IDisposable
            {
                protected bool Active { get => throw null; set => throw null; }
                public int Available { get => throw null; }
                public System.IAsyncResult BeginConnect(System.Net.IPAddress address, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.IPAddress[] addresses, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(string host, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.Net.Sockets.Socket Client { get => throw null; set => throw null; }
                public void Close() => throw null;
                public void Connect(System.Net.IPAddress address, int port) => throw null;
                public void Connect(System.Net.IPAddress[] ipAddresses, int port) => throw null;
                public void Connect(System.Net.IPEndPoint remoteEP) => throw null;
                public void Connect(string hostname, int port) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPAddress address, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPAddress address, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPAddress[] addresses, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPAddress[] addresses, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(string host, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(string host, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public bool Connected { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public void EndConnect(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set => throw null; }
                public System.Net.Sockets.NetworkStream GetStream() => throw null;
                public System.Net.Sockets.LingerOption LingerState { get => throw null; set => throw null; }
                public bool NoDelay { get => throw null; set => throw null; }
                public int ReceiveBufferSize { get => throw null; set => throw null; }
                public int ReceiveTimeout { get => throw null; set => throw null; }
                public int SendBufferSize { get => throw null; set => throw null; }
                public int SendTimeout { get => throw null; set => throw null; }
                public TcpClient() => throw null;
                public TcpClient(System.Net.Sockets.AddressFamily family) => throw null;
                public TcpClient(System.Net.IPEndPoint localEP) => throw null;
                public TcpClient(string hostname, int port) => throw null;
                // ERR: Stub generator didn't handle member: ~TcpClient
            }

            // Generated from `System.Net.Sockets.TcpListener` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TcpListener
            {
                public System.Net.Sockets.Socket AcceptSocket() => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.Socket> AcceptSocketAsync() => throw null;
                public System.Net.Sockets.TcpClient AcceptTcpClient() => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.TcpClient> AcceptTcpClientAsync() => throw null;
                protected bool Active { get => throw null; }
                public void AllowNatTraversal(bool allowed) => throw null;
                public System.IAsyncResult BeginAcceptSocket(System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginAcceptTcpClient(System.AsyncCallback callback, object state) => throw null;
                public static System.Net.Sockets.TcpListener Create(int port) => throw null;
                public System.Net.Sockets.Socket EndAcceptSocket(System.IAsyncResult asyncResult) => throw null;
                public System.Net.Sockets.TcpClient EndAcceptTcpClient(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set => throw null; }
                public System.Net.EndPoint LocalEndpoint { get => throw null; }
                public bool Pending() => throw null;
                public System.Net.Sockets.Socket Server { get => throw null; }
                public void Start() => throw null;
                public void Start(int backlog) => throw null;
                public void Stop() => throw null;
                public TcpListener(System.Net.IPAddress localaddr, int port) => throw null;
                public TcpListener(System.Net.IPEndPoint localEP) => throw null;
                public TcpListener(int port) => throw null;
            }

            // Generated from `System.Net.Sockets.TransmitFileOptions` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TransmitFileOptions
            {
                Disconnect,
                ReuseSocket,
                UseDefaultWorkerThread,
                UseKernelApc,
                UseSystemThread,
                WriteBehind,
            }

            // Generated from `System.Net.Sockets.UdpClient` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UdpClient : System.IDisposable
            {
                protected bool Active { get => throw null; set => throw null; }
                public void AllowNatTraversal(bool allowed) => throw null;
                public int Available { get => throw null; }
                public System.IAsyncResult BeginReceive(System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Byte[] datagram, int bytes, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Byte[] datagram, int bytes, System.Net.IPEndPoint endPoint, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Byte[] datagram, int bytes, string hostname, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.Net.Sockets.Socket Client { get => throw null; set => throw null; }
                public void Close() => throw null;
                public void Connect(System.Net.IPAddress addr, int port) => throw null;
                public void Connect(System.Net.IPEndPoint endPoint) => throw null;
                public void Connect(string hostname, int port) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool DontFragment { get => throw null; set => throw null; }
                public void DropMulticastGroup(System.Net.IPAddress multicastAddr) => throw null;
                public void DropMulticastGroup(System.Net.IPAddress multicastAddr, int ifindex) => throw null;
                public bool EnableBroadcast { get => throw null; set => throw null; }
                public System.Byte[] EndReceive(System.IAsyncResult asyncResult, ref System.Net.IPEndPoint remoteEP) => throw null;
                public int EndSend(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set => throw null; }
                public void JoinMulticastGroup(System.Net.IPAddress multicastAddr) => throw null;
                public void JoinMulticastGroup(System.Net.IPAddress multicastAddr, System.Net.IPAddress localAddress) => throw null;
                public void JoinMulticastGroup(System.Net.IPAddress multicastAddr, int timeToLive) => throw null;
                public void JoinMulticastGroup(int ifindex, System.Net.IPAddress multicastAddr) => throw null;
                public bool MulticastLoopback { get => throw null; set => throw null; }
                public System.Byte[] Receive(ref System.Net.IPEndPoint remoteEP) => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.UdpReceiveResult> ReceiveAsync() => throw null;
                public int Send(System.Byte[] dgram, int bytes) => throw null;
                public int Send(System.Byte[] dgram, int bytes, System.Net.IPEndPoint endPoint) => throw null;
                public int Send(System.Byte[] dgram, int bytes, string hostname, int port) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.Byte[] datagram, int bytes) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.Byte[] datagram, int bytes, System.Net.IPEndPoint endPoint) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.Byte[] datagram, int bytes, string hostname, int port) => throw null;
                public System.Int16 Ttl { get => throw null; set => throw null; }
                public UdpClient() => throw null;
                public UdpClient(System.Net.Sockets.AddressFamily family) => throw null;
                public UdpClient(System.Net.IPEndPoint localEP) => throw null;
                public UdpClient(int port) => throw null;
                public UdpClient(int port, System.Net.Sockets.AddressFamily family) => throw null;
                public UdpClient(string hostname, int port) => throw null;
            }

            // Generated from `System.Net.Sockets.UdpReceiveResult` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct UdpReceiveResult : System.IEquatable<System.Net.Sockets.UdpReceiveResult>
            {
                public static bool operator !=(System.Net.Sockets.UdpReceiveResult left, System.Net.Sockets.UdpReceiveResult right) => throw null;
                public static bool operator ==(System.Net.Sockets.UdpReceiveResult left, System.Net.Sockets.UdpReceiveResult right) => throw null;
                public System.Byte[] Buffer { get => throw null; }
                public bool Equals(System.Net.Sockets.UdpReceiveResult other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Net.IPEndPoint RemoteEndPoint { get => throw null; }
                // Stub generator skipped constructor 
                public UdpReceiveResult(System.Byte[] buffer, System.Net.IPEndPoint remoteEndPoint) => throw null;
            }

            // Generated from `System.Net.Sockets.UnixDomainSocketEndPoint` in `System.Net.Sockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnixDomainSocketEndPoint : System.Net.EndPoint
            {
                public UnixDomainSocketEndPoint(string path) => throw null;
            }

        }
    }
}
