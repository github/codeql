// This file contains auto-generated code.
// Generated from `System.Net.Sockets, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Net
    {
        namespace Sockets
        {
            public enum IOControlCode : long
            {
                EnableCircularQueuing = 671088642,
                Flush = 671088644,
                AddressListChange = 671088663,
                DataToRead = 1074030207,
                OobDataRead = 1074033415,
                GetBroadcastAddress = 1207959557,
                AddressListQuery = 1207959574,
                QueryTargetPnpHandle = 1207959576,
                AsyncIO = 2147772029,
                NonBlockingIO = 2147772030,
                AssociateHandle = 2281701377,
                MultipointLoopback = 2281701385,
                MulticastScope = 2281701386,
                SetQos = 2281701387,
                SetGroupQos = 2281701388,
                RoutingInterfaceChange = 2281701397,
                NamespaceChange = 2281701401,
                ReceiveAll = 2550136833,
                ReceiveAllMulticast = 2550136834,
                ReceiveAllIgmpMulticast = 2550136835,
                KeepAliveValues = 2550136836,
                AbsorbRouterAlert = 2550136837,
                UnicastInterface = 2550136838,
                LimitBroadcasts = 2550136839,
                BindToInterface = 2550136840,
                MulticastInterface = 2550136841,
                AddMulticastGroupOnInterface = 2550136842,
                DeleteMulticastGroupFromInterface = 2550136843,
                GetExtensionFunctionPointer = 3355443206,
                GetQos = 3355443207,
                GetGroupQos = 3355443208,
                TranslateHandle = 3355443213,
                RoutingInterfaceQuery = 3355443220,
                AddressListSort = 3355443225,
            }
            public struct IPPacketInformation : System.IEquatable<System.Net.Sockets.IPPacketInformation>
            {
                public System.Net.IPAddress Address { get => throw null; }
                public bool Equals(System.Net.Sockets.IPPacketInformation other) => throw null;
                public override bool Equals(object comparand) => throw null;
                public override int GetHashCode() => throw null;
                public int Interface { get => throw null; }
                public static bool operator ==(System.Net.Sockets.IPPacketInformation packetInformation1, System.Net.Sockets.IPPacketInformation packetInformation2) => throw null;
                public static bool operator !=(System.Net.Sockets.IPPacketInformation packetInformation1, System.Net.Sockets.IPPacketInformation packetInformation2) => throw null;
            }
            public enum IPProtectionLevel
            {
                Unspecified = -1,
                Unrestricted = 10,
                EdgeRestricted = 20,
                Restricted = 30,
            }
            public class IPv6MulticastOption
            {
                public IPv6MulticastOption(System.Net.IPAddress group) => throw null;
                public IPv6MulticastOption(System.Net.IPAddress group, long ifindex) => throw null;
                public System.Net.IPAddress Group { get => throw null; set { } }
                public long InterfaceIndex { get => throw null; set { } }
            }
            public class LingerOption
            {
                public LingerOption(bool enable, int seconds) => throw null;
                public bool Enabled { get => throw null; set { } }
                public override bool Equals(object comparand) => throw null;
                public override int GetHashCode() => throw null;
                public int LingerTime { get => throw null; set { } }
            }
            public class MulticastOption
            {
                public MulticastOption(System.Net.IPAddress group) => throw null;
                public MulticastOption(System.Net.IPAddress group, int interfaceIndex) => throw null;
                public MulticastOption(System.Net.IPAddress group, System.Net.IPAddress mcint) => throw null;
                public System.Net.IPAddress Group { get => throw null; set { } }
                public int InterfaceIndex { get => throw null; set { } }
                public System.Net.IPAddress LocalAddress { get => throw null; set { } }
            }
            public class NetworkStream : System.IO.Stream
            {
                public override System.IAsyncResult BeginRead(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override System.IAsyncResult BeginWrite(byte[] buffer, int offset, int count, System.AsyncCallback callback, object state) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public void Close(int timeout) => throw null;
                public void Close(System.TimeSpan timeout) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket, bool ownsSocket) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket, System.IO.FileAccess access) => throw null;
                public NetworkStream(System.Net.Sockets.Socket socket, System.IO.FileAccess access, bool ownsSocket) => throw null;
                public virtual bool DataAvailable { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override long Length { get => throw null; }
                public override long Position { get => throw null; set { } }
                public override int Read(byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<byte> buffer) => throw null;
                protected bool Readable { get => throw null; set { } }
                public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override int ReadTimeout { get => throw null; set { } }
                public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(long value) => throw null;
                public System.Net.Sockets.Socket Socket { get => throw null; }
                public override void Write(byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<byte> buffer) => throw null;
                protected bool Writeable { get => throw null; set { } }
                public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(byte value) => throw null;
                public override int WriteTimeout { get => throw null; set { } }
            }
            public enum ProtocolFamily
            {
                Unknown = -1,
                Unspecified = 0,
                Unix = 1,
                InterNetwork = 2,
                ImpLink = 3,
                Pup = 4,
                Chaos = 5,
                Ipx = 6,
                NS = 6,
                Iso = 7,
                Osi = 7,
                Ecma = 8,
                DataKit = 9,
                Ccitt = 10,
                Sna = 11,
                DecNet = 12,
                DataLink = 13,
                Lat = 14,
                HyperChannel = 15,
                AppleTalk = 16,
                NetBios = 17,
                VoiceView = 18,
                FireFox = 19,
                Banyan = 21,
                Atm = 22,
                InterNetworkV6 = 23,
                Cluster = 24,
                Ieee12844 = 25,
                Irda = 26,
                NetworkDesigners = 28,
                Max = 29,
                Packet = 65536,
                ControllerAreaNetwork = 65537,
            }
            public enum ProtocolType
            {
                Unknown = -1,
                IP = 0,
                IPv6HopByHopOptions = 0,
                Unspecified = 0,
                Icmp = 1,
                Igmp = 2,
                Ggp = 3,
                IPv4 = 4,
                Tcp = 6,
                Pup = 12,
                Udp = 17,
                Idp = 22,
                IPv6 = 41,
                IPv6RoutingHeader = 43,
                IPv6FragmentHeader = 44,
                IPSecEncapsulatingSecurityPayload = 50,
                IPSecAuthenticationHeader = 51,
                IcmpV6 = 58,
                IPv6NoNextHeader = 59,
                IPv6DestinationOptions = 60,
                ND = 77,
                Raw = 255,
                Ipx = 1000,
                Spx = 1256,
                SpxII = 1257,
            }
            public sealed class SafeSocketHandle : Microsoft.Win32.SafeHandles.SafeHandleMinusOneIsInvalid
            {
                public SafeSocketHandle() : base(default(bool)) => throw null;
                public SafeSocketHandle(nint preexistingHandle, bool ownsHandle) : base(default(bool)) => throw null;
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
            }
            public enum SelectMode
            {
                SelectRead = 0,
                SelectWrite = 1,
                SelectError = 2,
            }
            public class SendPacketsElement
            {
                public byte[] Buffer { get => throw null; }
                public int Count { get => throw null; }
                public SendPacketsElement(byte[] buffer) => throw null;
                public SendPacketsElement(byte[] buffer, int offset, int count) => throw null;
                public SendPacketsElement(byte[] buffer, int offset, int count, bool endOfPacket) => throw null;
                public SendPacketsElement(System.IO.FileStream fileStream) => throw null;
                public SendPacketsElement(System.IO.FileStream fileStream, long offset, int count) => throw null;
                public SendPacketsElement(System.IO.FileStream fileStream, long offset, int count, bool endOfPacket) => throw null;
                public SendPacketsElement(System.ReadOnlyMemory<byte> buffer) => throw null;
                public SendPacketsElement(System.ReadOnlyMemory<byte> buffer, bool endOfPacket) => throw null;
                public SendPacketsElement(string filepath) => throw null;
                public SendPacketsElement(string filepath, int offset, int count) => throw null;
                public SendPacketsElement(string filepath, int offset, int count, bool endOfPacket) => throw null;
                public SendPacketsElement(string filepath, long offset, int count) => throw null;
                public SendPacketsElement(string filepath, long offset, int count, bool endOfPacket) => throw null;
                public bool EndOfPacket { get => throw null; }
                public string FilePath { get => throw null; }
                public System.IO.FileStream FileStream { get => throw null; }
                public System.ReadOnlyMemory<byte>? MemoryBuffer { get => throw null; }
                public int Offset { get => throw null; }
                public long OffsetLong { get => throw null; }
            }
            public class Socket : System.IDisposable
            {
                public System.Net.Sockets.Socket Accept() => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.Socket> AcceptAsync() => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.Socket> AcceptAsync(System.Net.Sockets.Socket acceptSocket) => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.Socket> AcceptAsync(System.Net.Sockets.Socket acceptSocket, System.Threading.CancellationToken cancellationToken) => throw null;
                public bool AcceptAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.Socket> AcceptAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
                public int Available { get => throw null; }
                public System.IAsyncResult BeginAccept(System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginAccept(int receiveSize, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginAccept(System.Net.Sockets.Socket acceptSocket, int receiveSize, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.IPAddress address, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.IPAddress[] addresses, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(string host, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginDisconnect(bool reuseSocket, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceive(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceiveFrom(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginReceiveMessageFrom(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSend(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSendFile(string fileName, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSendFile(string fileName, byte[] preBuffer, byte[] postBuffer, System.Net.Sockets.TransmitFileOptions flags, System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginSendTo(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP, System.AsyncCallback callback, object state) => throw null;
                public void Bind(System.Net.EndPoint localEP) => throw null;
                public bool Blocking { get => throw null; set { } }
                public static void CancelConnectAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public void Close() => throw null;
                public void Close(int timeout) => throw null;
                public void Connect(System.Net.EndPoint remoteEP) => throw null;
                public void Connect(System.Net.IPAddress address, int port) => throw null;
                public void Connect(System.Net.IPAddress[] addresses, int port) => throw null;
                public void Connect(string host, int port) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.EndPoint remoteEP) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.EndPoint remoteEP, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPAddress address, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPAddress address, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPAddress[] addresses, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPAddress[] addresses, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public bool ConnectAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public static bool ConnectAsync(System.Net.Sockets.SocketType socketType, System.Net.Sockets.ProtocolType protocolType, System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(string host, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(string host, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public bool Connected { get => throw null; }
                public Socket(System.Net.Sockets.AddressFamily addressFamily, System.Net.Sockets.SocketType socketType, System.Net.Sockets.ProtocolType protocolType) => throw null;
                public Socket(System.Net.Sockets.SafeSocketHandle handle) => throw null;
                public Socket(System.Net.Sockets.SocketInformation socketInformation) => throw null;
                public Socket(System.Net.Sockets.SocketType socketType, System.Net.Sockets.ProtocolType protocolType) => throw null;
                public void Disconnect(bool reuseSocket) => throw null;
                public System.Threading.Tasks.ValueTask DisconnectAsync(bool reuseSocket, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public bool DisconnectAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool DontFragment { get => throw null; set { } }
                public bool DualMode { get => throw null; set { } }
                public System.Net.Sockets.SocketInformation DuplicateAndClose(int targetProcessId) => throw null;
                public bool EnableBroadcast { get => throw null; set { } }
                public System.Net.Sockets.Socket EndAccept(out byte[] buffer, System.IAsyncResult asyncResult) => throw null;
                public System.Net.Sockets.Socket EndAccept(out byte[] buffer, out int bytesTransferred, System.IAsyncResult asyncResult) => throw null;
                public System.Net.Sockets.Socket EndAccept(System.IAsyncResult asyncResult) => throw null;
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
                public bool ExclusiveAddressUse { get => throw null; set { } }
                public int GetRawSocketOption(int optionLevel, int optionName, System.Span<byte> optionValue) => throw null;
                public object GetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName) => throw null;
                public void GetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, byte[] optionValue) => throw null;
                public byte[] GetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, int optionLength) => throw null;
                public nint Handle { get => throw null; }
                public int IOControl(int ioControlCode, byte[] optionInValue, byte[] optionOutValue) => throw null;
                public int IOControl(System.Net.Sockets.IOControlCode ioControlCode, byte[] optionInValue, byte[] optionOutValue) => throw null;
                public bool IsBound { get => throw null; }
                public System.Net.Sockets.LingerOption LingerState { get => throw null; set { } }
                public void Listen() => throw null;
                public void Listen(int backlog) => throw null;
                public System.Net.EndPoint LocalEndPoint { get => throw null; }
                public bool MulticastLoopback { get => throw null; set { } }
                public bool NoDelay { get => throw null; set { } }
                public static bool OSSupportsIPv4 { get => throw null; }
                public static bool OSSupportsIPv6 { get => throw null; }
                public static bool OSSupportsUnixDomainSockets { get => throw null; }
                public bool Poll(int microSeconds, System.Net.Sockets.SelectMode mode) => throw null;
                public bool Poll(System.TimeSpan timeout, System.Net.Sockets.SelectMode mode) => throw null;
                public System.Net.Sockets.ProtocolType ProtocolType { get => throw null; }
                public int Receive(byte[] buffer) => throw null;
                public int Receive(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Receive(byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(byte[] buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers) => throw null;
                public int Receive(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Receive(System.Span<byte> buffer) => throw null;
                public int Receive(System.Span<byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Receive(System.Span<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public System.Threading.Tasks.Task<int> ReceiveAsync(System.ArraySegment<byte> buffer) => throw null;
                public System.Threading.Tasks.Task<int> ReceiveAsync(System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public System.Threading.Tasks.Task<int> ReceiveAsync(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers) => throw null;
                public System.Threading.Tasks.Task<int> ReceiveAsync(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public System.Threading.Tasks.ValueTask<int> ReceiveAsync(System.Memory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> ReceiveAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public bool ReceiveAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int ReceiveBufferSize { get => throw null; set { } }
                public int ReceiveFrom(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(byte[] buffer, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(byte[] buffer, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(System.Span<byte> buffer, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(System.Span<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP) => throw null;
                public int ReceiveFrom(System.Span<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.SocketAddress receivedAddress) => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveFromResult> ReceiveFromAsync(System.ArraySegment<byte> buffer, System.Net.EndPoint remoteEndPoint) => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveFromResult> ReceiveFromAsync(System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint) => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.SocketReceiveFromResult> ReceiveFromAsync(System.Memory<byte> buffer, System.Net.EndPoint remoteEndPoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.SocketReceiveFromResult> ReceiveFromAsync(System.Memory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> ReceiveFromAsync(System.Memory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.SocketAddress receivedAddress, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public bool ReceiveFromAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int ReceiveMessageFrom(byte[] buffer, int offset, int size, ref System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, out System.Net.Sockets.IPPacketInformation ipPacketInformation) => throw null;
                public int ReceiveMessageFrom(System.Span<byte> buffer, ref System.Net.Sockets.SocketFlags socketFlags, ref System.Net.EndPoint remoteEP, out System.Net.Sockets.IPPacketInformation ipPacketInformation) => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveMessageFromResult> ReceiveMessageFromAsync(System.ArraySegment<byte> buffer, System.Net.EndPoint remoteEndPoint) => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveMessageFromResult> ReceiveMessageFromAsync(System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint) => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.SocketReceiveMessageFromResult> ReceiveMessageFromAsync(System.Memory<byte> buffer, System.Net.EndPoint remoteEndPoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.SocketReceiveMessageFromResult> ReceiveMessageFromAsync(System.Memory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public bool ReceiveMessageFromAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int ReceiveTimeout { get => throw null; set { } }
                public System.Net.EndPoint RemoteEndPoint { get => throw null; }
                public System.Net.Sockets.SafeSocketHandle SafeHandle { get => throw null; }
                public static void Select(System.Collections.IList checkRead, System.Collections.IList checkWrite, System.Collections.IList checkError, int microSeconds) => throw null;
                public static void Select(System.Collections.IList checkRead, System.Collections.IList checkWrite, System.Collections.IList checkError, System.TimeSpan timeout) => throw null;
                public int Send(byte[] buffer) => throw null;
                public int Send(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Send(byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(byte[] buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers) => throw null;
                public int Send(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public int Send(System.ReadOnlySpan<byte> buffer) => throw null;
                public int Send(System.ReadOnlySpan<byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public int Send(System.ReadOnlySpan<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, out System.Net.Sockets.SocketError errorCode) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.ArraySegment<byte> buffer) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public bool SendAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendAsync(System.ReadOnlyMemory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendAsync(System.ReadOnlyMemory<byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public int SendBufferSize { get => throw null; set { } }
                public void SendFile(string fileName) => throw null;
                public void SendFile(string fileName, byte[] preBuffer, byte[] postBuffer, System.Net.Sockets.TransmitFileOptions flags) => throw null;
                public void SendFile(string fileName, System.ReadOnlySpan<byte> preBuffer, System.ReadOnlySpan<byte> postBuffer, System.Net.Sockets.TransmitFileOptions flags) => throw null;
                public System.Threading.Tasks.ValueTask SendFileAsync(string fileName, System.ReadOnlyMemory<byte> preBuffer, System.ReadOnlyMemory<byte> postBuffer, System.Net.Sockets.TransmitFileOptions flags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask SendFileAsync(string fileName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public bool SendPacketsAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public int SendTimeout { get => throw null; set { } }
                public int SendTo(byte[] buffer, int offset, int size, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(byte[] buffer, int size, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(byte[] buffer, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(byte[] buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(System.ReadOnlySpan<byte> buffer, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(System.ReadOnlySpan<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public int SendTo(System.ReadOnlySpan<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.SocketAddress socketAddress) => throw null;
                public System.Threading.Tasks.Task<int> SendToAsync(System.ArraySegment<byte> buffer, System.Net.EndPoint remoteEP) => throw null;
                public System.Threading.Tasks.Task<int> SendToAsync(System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
                public bool SendToAsync(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendToAsync(System.ReadOnlyMemory<byte> buffer, System.Net.EndPoint remoteEP, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendToAsync(System.ReadOnlyMemory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendToAsync(System.ReadOnlyMemory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.SocketAddress socketAddress, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public void SetIPProtectionLevel(System.Net.Sockets.IPProtectionLevel level) => throw null;
                public void SetRawSocketOption(int optionLevel, int optionName, System.ReadOnlySpan<byte> optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, bool optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, byte[] optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, int optionValue) => throw null;
                public void SetSocketOption(System.Net.Sockets.SocketOptionLevel optionLevel, System.Net.Sockets.SocketOptionName optionName, object optionValue) => throw null;
                public void Shutdown(System.Net.Sockets.SocketShutdown how) => throw null;
                public System.Net.Sockets.SocketType SocketType { get => throw null; }
                public static bool SupportsIPv4 { get => throw null; }
                public static bool SupportsIPv6 { get => throw null; }
                public short Ttl { get => throw null; set { } }
                public bool UseOnlyOverlappedIO { get => throw null; set { } }
            }
            public class SocketAsyncEventArgs : System.EventArgs, System.IDisposable
            {
                public System.Net.Sockets.Socket AcceptSocket { get => throw null; set { } }
                public byte[] Buffer { get => throw null; }
                public System.Collections.Generic.IList<System.ArraySegment<byte>> BufferList { get => throw null; set { } }
                public int BytesTransferred { get => throw null; }
                public event System.EventHandler<System.Net.Sockets.SocketAsyncEventArgs> Completed;
                public System.Exception ConnectByNameError { get => throw null; }
                public System.Net.Sockets.Socket ConnectSocket { get => throw null; }
                public int Count { get => throw null; }
                public SocketAsyncEventArgs() => throw null;
                public SocketAsyncEventArgs(bool unsafeSuppressExecutionContextFlow) => throw null;
                public bool DisconnectReuseSocket { get => throw null; set { } }
                public void Dispose() => throw null;
                public System.Net.Sockets.SocketAsyncOperation LastOperation { get => throw null; }
                public System.Memory<byte> MemoryBuffer { get => throw null; }
                public int Offset { get => throw null; }
                protected virtual void OnCompleted(System.Net.Sockets.SocketAsyncEventArgs e) => throw null;
                public System.Net.Sockets.IPPacketInformation ReceiveMessageFromPacketInfo { get => throw null; }
                public System.Net.EndPoint RemoteEndPoint { get => throw null; set { } }
                public System.Net.Sockets.SendPacketsElement[] SendPacketsElements { get => throw null; set { } }
                public System.Net.Sockets.TransmitFileOptions SendPacketsFlags { get => throw null; set { } }
                public int SendPacketsSendSize { get => throw null; set { } }
                public void SetBuffer(byte[] buffer, int offset, int count) => throw null;
                public void SetBuffer(int offset, int count) => throw null;
                public void SetBuffer(System.Memory<byte> buffer) => throw null;
                public System.Net.Sockets.SocketError SocketError { get => throw null; set { } }
                public System.Net.Sockets.SocketFlags SocketFlags { get => throw null; set { } }
                public object UserToken { get => throw null; set { } }
            }
            public enum SocketAsyncOperation
            {
                None = 0,
                Accept = 1,
                Connect = 2,
                Disconnect = 3,
                Receive = 4,
                ReceiveFrom = 5,
                ReceiveMessageFrom = 6,
                Send = 7,
                SendPackets = 8,
                SendTo = 9,
            }
            [System.Flags]
            public enum SocketFlags
            {
                None = 0,
                OutOfBand = 1,
                Peek = 2,
                DontRoute = 4,
                Truncated = 256,
                ControlDataTruncated = 512,
                Broadcast = 1024,
                Multicast = 2048,
                Partial = 32768,
            }
            public struct SocketInformation
            {
                public System.Net.Sockets.SocketInformationOptions Options { get => throw null; set { } }
                public byte[] ProtocolInformation { get => throw null; set { } }
            }
            [System.Flags]
            public enum SocketInformationOptions
            {
                NonBlocking = 1,
                Connected = 2,
                Listening = 4,
                UseOnlyOverlappedIO = 8,
            }
            public enum SocketOptionLevel
            {
                IP = 0,
                Tcp = 6,
                Udp = 17,
                IPv6 = 41,
                Socket = 65535,
            }
            public enum SocketOptionName
            {
                DontLinger = -129,
                ExclusiveAddressUse = -5,
                Debug = 1,
                IPOptions = 1,
                NoChecksum = 1,
                NoDelay = 1,
                AcceptConnection = 2,
                BsdUrgent = 2,
                Expedited = 2,
                HeaderIncluded = 2,
                TcpKeepAliveTime = 3,
                TypeOfService = 3,
                IpTimeToLive = 4,
                ReuseAddress = 4,
                KeepAlive = 8,
                MulticastInterface = 9,
                MulticastTimeToLive = 10,
                MulticastLoopback = 11,
                AddMembership = 12,
                DropMembership = 13,
                DontFragment = 14,
                AddSourceMembership = 15,
                DontRoute = 16,
                DropSourceMembership = 16,
                TcpKeepAliveRetryCount = 16,
                BlockSource = 17,
                TcpKeepAliveInterval = 17,
                UnblockSource = 18,
                PacketInformation = 19,
                ChecksumCoverage = 20,
                HopLimit = 21,
                IPProtectionLevel = 23,
                IPv6Only = 27,
                Broadcast = 32,
                UseLoopback = 64,
                Linger = 128,
                OutOfBandInline = 256,
                SendBuffer = 4097,
                ReceiveBuffer = 4098,
                SendLowWater = 4099,
                ReceiveLowWater = 4100,
                SendTimeout = 4101,
                ReceiveTimeout = 4102,
                Error = 4103,
                Type = 4104,
                ReuseUnicastPort = 12295,
                UpdateAcceptContext = 28683,
                UpdateConnectContext = 28688,
                MaxConnections = 2147483647,
            }
            public struct SocketReceiveFromResult
            {
                public int ReceivedBytes;
                public System.Net.EndPoint RemoteEndPoint;
            }
            public struct SocketReceiveMessageFromResult
            {
                public System.Net.Sockets.IPPacketInformation PacketInformation;
                public int ReceivedBytes;
                public System.Net.EndPoint RemoteEndPoint;
                public System.Net.Sockets.SocketFlags SocketFlags;
            }
            public enum SocketShutdown
            {
                Receive = 0,
                Send = 1,
                Both = 2,
            }
            public static partial class SocketTaskExtensions
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
                public static System.Threading.Tasks.Task<int> ReceiveAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.Task<int> ReceiveAsync(this System.Net.Sockets.Socket socket, System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.ValueTask<int> ReceiveAsync(this System.Net.Sockets.Socket socket, System.Memory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveFromResult> ReceiveFromAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint) => throw null;
                public static System.Threading.Tasks.Task<System.Net.Sockets.SocketReceiveMessageFromResult> ReceiveMessageFromAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEndPoint) => throw null;
                public static System.Threading.Tasks.Task<int> SendAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.Task<int> SendAsync(this System.Net.Sockets.Socket socket, System.Collections.Generic.IList<System.ArraySegment<byte>> buffers, System.Net.Sockets.SocketFlags socketFlags) => throw null;
                public static System.Threading.Tasks.ValueTask<int> SendAsync(this System.Net.Sockets.Socket socket, System.ReadOnlyMemory<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<int> SendToAsync(this System.Net.Sockets.Socket socket, System.ArraySegment<byte> buffer, System.Net.Sockets.SocketFlags socketFlags, System.Net.EndPoint remoteEP) => throw null;
            }
            public enum SocketType
            {
                Unknown = -1,
                Stream = 1,
                Dgram = 2,
                Raw = 3,
                Rdm = 4,
                Seqpacket = 5,
            }
            public class TcpClient : System.IDisposable
            {
                protected bool Active { get => throw null; set { } }
                public int Available { get => throw null; }
                public System.IAsyncResult BeginConnect(System.Net.IPAddress address, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(System.Net.IPAddress[] addresses, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginConnect(string host, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.Net.Sockets.Socket Client { get => throw null; set { } }
                public void Close() => throw null;
                public void Connect(System.Net.IPAddress address, int port) => throw null;
                public void Connect(System.Net.IPAddress[] ipAddresses, int port) => throw null;
                public void Connect(System.Net.IPEndPoint remoteEP) => throw null;
                public void Connect(string hostname, int port) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPAddress address, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPAddress address, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPAddress[] addresses, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPAddress[] addresses, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(System.Net.IPEndPoint remoteEP) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(System.Net.IPEndPoint remoteEP, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task ConnectAsync(string host, int port) => throw null;
                public System.Threading.Tasks.ValueTask ConnectAsync(string host, int port, System.Threading.CancellationToken cancellationToken) => throw null;
                public bool Connected { get => throw null; }
                public TcpClient() => throw null;
                public TcpClient(System.Net.IPEndPoint localEP) => throw null;
                public TcpClient(System.Net.Sockets.AddressFamily family) => throw null;
                public TcpClient(string hostname, int port) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public void EndConnect(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set { } }
                public System.Net.Sockets.NetworkStream GetStream() => throw null;
                public System.Net.Sockets.LingerOption LingerState { get => throw null; set { } }
                public bool NoDelay { get => throw null; set { } }
                public int ReceiveBufferSize { get => throw null; set { } }
                public int ReceiveTimeout { get => throw null; set { } }
                public int SendBufferSize { get => throw null; set { } }
                public int SendTimeout { get => throw null; set { } }
            }
            public class TcpListener : System.IDisposable
            {
                public System.Net.Sockets.Socket AcceptSocket() => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.Socket> AcceptSocketAsync() => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.Socket> AcceptSocketAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Net.Sockets.TcpClient AcceptTcpClient() => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.TcpClient> AcceptTcpClientAsync() => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.TcpClient> AcceptTcpClientAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                protected bool Active { get => throw null; }
                public void AllowNatTraversal(bool allowed) => throw null;
                public System.IAsyncResult BeginAcceptSocket(System.AsyncCallback callback, object state) => throw null;
                public System.IAsyncResult BeginAcceptTcpClient(System.AsyncCallback callback, object state) => throw null;
                public static System.Net.Sockets.TcpListener Create(int port) => throw null;
                public TcpListener(int port) => throw null;
                public TcpListener(System.Net.IPAddress localaddr, int port) => throw null;
                public TcpListener(System.Net.IPEndPoint localEP) => throw null;
                public void Dispose() => throw null;
                public System.Net.Sockets.Socket EndAcceptSocket(System.IAsyncResult asyncResult) => throw null;
                public System.Net.Sockets.TcpClient EndAcceptTcpClient(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set { } }
                public System.Net.EndPoint LocalEndpoint { get => throw null; }
                public bool Pending() => throw null;
                public System.Net.Sockets.Socket Server { get => throw null; }
                public void Start() => throw null;
                public void Start(int backlog) => throw null;
                public void Stop() => throw null;
            }
            [System.Flags]
            public enum TransmitFileOptions
            {
                UseDefaultWorkerThread = 0,
                Disconnect = 1,
                ReuseSocket = 2,
                WriteBehind = 4,
                UseSystemThread = 16,
                UseKernelApc = 32,
            }
            public class UdpClient : System.IDisposable
            {
                protected bool Active { get => throw null; set { } }
                public void AllowNatTraversal(bool allowed) => throw null;
                public int Available { get => throw null; }
                public System.IAsyncResult BeginReceive(System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginSend(byte[] datagram, int bytes, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginSend(byte[] datagram, int bytes, System.Net.IPEndPoint endPoint, System.AsyncCallback requestCallback, object state) => throw null;
                public System.IAsyncResult BeginSend(byte[] datagram, int bytes, string hostname, int port, System.AsyncCallback requestCallback, object state) => throw null;
                public System.Net.Sockets.Socket Client { get => throw null; set { } }
                public void Close() => throw null;
                public void Connect(System.Net.IPAddress addr, int port) => throw null;
                public void Connect(System.Net.IPEndPoint endPoint) => throw null;
                public void Connect(string hostname, int port) => throw null;
                public UdpClient() => throw null;
                public UdpClient(int port) => throw null;
                public UdpClient(int port, System.Net.Sockets.AddressFamily family) => throw null;
                public UdpClient(System.Net.IPEndPoint localEP) => throw null;
                public UdpClient(System.Net.Sockets.AddressFamily family) => throw null;
                public UdpClient(string hostname, int port) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool DontFragment { get => throw null; set { } }
                public void DropMulticastGroup(System.Net.IPAddress multicastAddr) => throw null;
                public void DropMulticastGroup(System.Net.IPAddress multicastAddr, int ifindex) => throw null;
                public bool EnableBroadcast { get => throw null; set { } }
                public byte[] EndReceive(System.IAsyncResult asyncResult, ref System.Net.IPEndPoint remoteEP) => throw null;
                public int EndSend(System.IAsyncResult asyncResult) => throw null;
                public bool ExclusiveAddressUse { get => throw null; set { } }
                public void JoinMulticastGroup(int ifindex, System.Net.IPAddress multicastAddr) => throw null;
                public void JoinMulticastGroup(System.Net.IPAddress multicastAddr) => throw null;
                public void JoinMulticastGroup(System.Net.IPAddress multicastAddr, int timeToLive) => throw null;
                public void JoinMulticastGroup(System.Net.IPAddress multicastAddr, System.Net.IPAddress localAddress) => throw null;
                public bool MulticastLoopback { get => throw null; set { } }
                public byte[] Receive(ref System.Net.IPEndPoint remoteEP) => throw null;
                public System.Threading.Tasks.Task<System.Net.Sockets.UdpReceiveResult> ReceiveAsync() => throw null;
                public System.Threading.Tasks.ValueTask<System.Net.Sockets.UdpReceiveResult> ReceiveAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public int Send(byte[] dgram, int bytes) => throw null;
                public int Send(byte[] dgram, int bytes, System.Net.IPEndPoint endPoint) => throw null;
                public int Send(byte[] dgram, int bytes, string hostname, int port) => throw null;
                public int Send(System.ReadOnlySpan<byte> datagram) => throw null;
                public int Send(System.ReadOnlySpan<byte> datagram, System.Net.IPEndPoint endPoint) => throw null;
                public int Send(System.ReadOnlySpan<byte> datagram, string hostname, int port) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(byte[] datagram, int bytes) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(byte[] datagram, int bytes, System.Net.IPEndPoint endPoint) => throw null;
                public System.Threading.Tasks.Task<int> SendAsync(byte[] datagram, int bytes, string hostname, int port) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendAsync(System.ReadOnlyMemory<byte> datagram, System.Net.IPEndPoint endPoint, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendAsync(System.ReadOnlyMemory<byte> datagram, string hostname, int port, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.ValueTask<int> SendAsync(System.ReadOnlyMemory<byte> datagram, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public short Ttl { get => throw null; set { } }
            }
            public struct UdpReceiveResult : System.IEquatable<System.Net.Sockets.UdpReceiveResult>
            {
                public byte[] Buffer { get => throw null; }
                public UdpReceiveResult(byte[] buffer, System.Net.IPEndPoint remoteEndPoint) => throw null;
                public bool Equals(System.Net.Sockets.UdpReceiveResult other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static bool operator ==(System.Net.Sockets.UdpReceiveResult left, System.Net.Sockets.UdpReceiveResult right) => throw null;
                public static bool operator !=(System.Net.Sockets.UdpReceiveResult left, System.Net.Sockets.UdpReceiveResult right) => throw null;
                public System.Net.IPEndPoint RemoteEndPoint { get => throw null; }
            }
            public sealed class UnixDomainSocketEndPoint : System.Net.EndPoint
            {
                public override System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
                public override System.Net.EndPoint Create(System.Net.SocketAddress socketAddress) => throw null;
                public UnixDomainSocketEndPoint(string path) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public override System.Net.SocketAddress Serialize() => throw null;
                public override string ToString() => throw null;
            }
        }
    }
}
