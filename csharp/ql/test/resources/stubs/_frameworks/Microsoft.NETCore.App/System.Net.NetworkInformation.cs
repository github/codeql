// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace NetworkInformation
        {
            // Generated from `System.Net.NetworkInformation.DuplicateAddressDetectionState` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum DuplicateAddressDetectionState
            {
                Deprecated,
                Duplicate,
                Invalid,
                Preferred,
                Tentative,
            }

            // Generated from `System.Net.NetworkInformation.GatewayIPAddressInformation` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class GatewayIPAddressInformation
            {
                public abstract System.Net.IPAddress Address { get; }
                protected GatewayIPAddressInformation() => throw null;
            }

            // Generated from `System.Net.NetworkInformation.GatewayIPAddressInformationCollection` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class GatewayIPAddressInformationCollection : System.Collections.Generic.ICollection<System.Net.NetworkInformation.GatewayIPAddressInformation>, System.Collections.Generic.IEnumerable<System.Net.NetworkInformation.GatewayIPAddressInformation>, System.Collections.IEnumerable
            {
                public virtual void Add(System.Net.NetworkInformation.GatewayIPAddressInformation address) => throw null;
                public virtual void Clear() => throw null;
                public virtual bool Contains(System.Net.NetworkInformation.GatewayIPAddressInformation address) => throw null;
                public virtual void CopyTo(System.Net.NetworkInformation.GatewayIPAddressInformation[] array, int offset) => throw null;
                public virtual int Count { get => throw null; }
                protected internal GatewayIPAddressInformationCollection() => throw null;
                public virtual System.Collections.Generic.IEnumerator<System.Net.NetworkInformation.GatewayIPAddressInformation> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual bool IsReadOnly { get => throw null; }
                public virtual System.Net.NetworkInformation.GatewayIPAddressInformation this[int index] { get => throw null; }
                public virtual bool Remove(System.Net.NetworkInformation.GatewayIPAddressInformation address) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.IPAddressInformation` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPAddressInformation
            {
                public abstract System.Net.IPAddress Address { get; }
                protected IPAddressInformation() => throw null;
                public abstract bool IsDnsEligible { get; }
                public abstract bool IsTransient { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPAddressInformationCollection` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IPAddressInformationCollection : System.Collections.Generic.ICollection<System.Net.NetworkInformation.IPAddressInformation>, System.Collections.Generic.IEnumerable<System.Net.NetworkInformation.IPAddressInformation>, System.Collections.IEnumerable
            {
                public virtual void Add(System.Net.NetworkInformation.IPAddressInformation address) => throw null;
                public virtual void Clear() => throw null;
                public virtual bool Contains(System.Net.NetworkInformation.IPAddressInformation address) => throw null;
                public virtual void CopyTo(System.Net.NetworkInformation.IPAddressInformation[] array, int offset) => throw null;
                public virtual int Count { get => throw null; }
                public virtual System.Collections.Generic.IEnumerator<System.Net.NetworkInformation.IPAddressInformation> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual bool IsReadOnly { get => throw null; }
                public virtual System.Net.NetworkInformation.IPAddressInformation this[int index] { get => throw null; }
                public virtual bool Remove(System.Net.NetworkInformation.IPAddressInformation address) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.IPGlobalProperties` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPGlobalProperties
            {
                public virtual System.IAsyncResult BeginGetUnicastAddresses(System.AsyncCallback callback, object state) => throw null;
                public abstract string DhcpScopeName { get; }
                public abstract string DomainName { get; }
                public virtual System.Net.NetworkInformation.UnicastIPAddressInformationCollection EndGetUnicastAddresses(System.IAsyncResult asyncResult) => throw null;
                public abstract System.Net.NetworkInformation.TcpConnectionInformation[] GetActiveTcpConnections();
                public abstract System.Net.IPEndPoint[] GetActiveTcpListeners();
                public abstract System.Net.IPEndPoint[] GetActiveUdpListeners();
                public static System.Net.NetworkInformation.IPGlobalProperties GetIPGlobalProperties() => throw null;
                public abstract System.Net.NetworkInformation.IPGlobalStatistics GetIPv4GlobalStatistics();
                public abstract System.Net.NetworkInformation.IPGlobalStatistics GetIPv6GlobalStatistics();
                public abstract System.Net.NetworkInformation.IcmpV4Statistics GetIcmpV4Statistics();
                public abstract System.Net.NetworkInformation.IcmpV6Statistics GetIcmpV6Statistics();
                public abstract System.Net.NetworkInformation.TcpStatistics GetTcpIPv4Statistics();
                public abstract System.Net.NetworkInformation.TcpStatistics GetTcpIPv6Statistics();
                public abstract System.Net.NetworkInformation.UdpStatistics GetUdpIPv4Statistics();
                public abstract System.Net.NetworkInformation.UdpStatistics GetUdpIPv6Statistics();
                public virtual System.Net.NetworkInformation.UnicastIPAddressInformationCollection GetUnicastAddresses() => throw null;
                public virtual System.Threading.Tasks.Task<System.Net.NetworkInformation.UnicastIPAddressInformationCollection> GetUnicastAddressesAsync() => throw null;
                public abstract string HostName { get; }
                protected IPGlobalProperties() => throw null;
                public abstract bool IsWinsProxy { get; }
                public abstract System.Net.NetworkInformation.NetBiosNodeType NodeType { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPGlobalStatistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPGlobalStatistics
            {
                public abstract int DefaultTtl { get; }
                public abstract bool ForwardingEnabled { get; }
                protected IPGlobalStatistics() => throw null;
                public abstract int NumberOfIPAddresses { get; }
                public abstract int NumberOfInterfaces { get; }
                public abstract int NumberOfRoutes { get; }
                public abstract System.Int64 OutputPacketRequests { get; }
                public abstract System.Int64 OutputPacketRoutingDiscards { get; }
                public abstract System.Int64 OutputPacketsDiscarded { get; }
                public abstract System.Int64 OutputPacketsWithNoRoute { get; }
                public abstract System.Int64 PacketFragmentFailures { get; }
                public abstract System.Int64 PacketReassembliesRequired { get; }
                public abstract System.Int64 PacketReassemblyFailures { get; }
                public abstract System.Int64 PacketReassemblyTimeout { get; }
                public abstract System.Int64 PacketsFragmented { get; }
                public abstract System.Int64 PacketsReassembled { get; }
                public abstract System.Int64 ReceivedPackets { get; }
                public abstract System.Int64 ReceivedPacketsDelivered { get; }
                public abstract System.Int64 ReceivedPacketsDiscarded { get; }
                public abstract System.Int64 ReceivedPacketsForwarded { get; }
                public abstract System.Int64 ReceivedPacketsWithAddressErrors { get; }
                public abstract System.Int64 ReceivedPacketsWithHeadersErrors { get; }
                public abstract System.Int64 ReceivedPacketsWithUnknownProtocol { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPInterfaceProperties` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPInterfaceProperties
            {
                public abstract System.Net.NetworkInformation.IPAddressInformationCollection AnycastAddresses { get; }
                public abstract System.Net.NetworkInformation.IPAddressCollection DhcpServerAddresses { get; }
                public abstract System.Net.NetworkInformation.IPAddressCollection DnsAddresses { get; }
                public abstract string DnsSuffix { get; }
                public abstract System.Net.NetworkInformation.GatewayIPAddressInformationCollection GatewayAddresses { get; }
                public abstract System.Net.NetworkInformation.IPv4InterfaceProperties GetIPv4Properties();
                public abstract System.Net.NetworkInformation.IPv6InterfaceProperties GetIPv6Properties();
                protected IPInterfaceProperties() => throw null;
                public abstract bool IsDnsEnabled { get; }
                public abstract bool IsDynamicDnsEnabled { get; }
                public abstract System.Net.NetworkInformation.MulticastIPAddressInformationCollection MulticastAddresses { get; }
                public abstract System.Net.NetworkInformation.UnicastIPAddressInformationCollection UnicastAddresses { get; }
                public abstract System.Net.NetworkInformation.IPAddressCollection WinsServersAddresses { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPInterfaceStatistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPInterfaceStatistics
            {
                public abstract System.Int64 BytesReceived { get; }
                public abstract System.Int64 BytesSent { get; }
                protected IPInterfaceStatistics() => throw null;
                public abstract System.Int64 IncomingPacketsDiscarded { get; }
                public abstract System.Int64 IncomingPacketsWithErrors { get; }
                public abstract System.Int64 IncomingUnknownProtocolPackets { get; }
                public abstract System.Int64 NonUnicastPacketsReceived { get; }
                public abstract System.Int64 NonUnicastPacketsSent { get; }
                public abstract System.Int64 OutgoingPacketsDiscarded { get; }
                public abstract System.Int64 OutgoingPacketsWithErrors { get; }
                public abstract System.Int64 OutputQueueLength { get; }
                public abstract System.Int64 UnicastPacketsReceived { get; }
                public abstract System.Int64 UnicastPacketsSent { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPv4InterfaceProperties` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPv4InterfaceProperties
            {
                protected IPv4InterfaceProperties() => throw null;
                public abstract int Index { get; }
                public abstract bool IsAutomaticPrivateAddressingActive { get; }
                public abstract bool IsAutomaticPrivateAddressingEnabled { get; }
                public abstract bool IsDhcpEnabled { get; }
                public abstract bool IsForwardingEnabled { get; }
                public abstract int Mtu { get; }
                public abstract bool UsesWins { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPv4InterfaceStatistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPv4InterfaceStatistics
            {
                public abstract System.Int64 BytesReceived { get; }
                public abstract System.Int64 BytesSent { get; }
                protected IPv4InterfaceStatistics() => throw null;
                public abstract System.Int64 IncomingPacketsDiscarded { get; }
                public abstract System.Int64 IncomingPacketsWithErrors { get; }
                public abstract System.Int64 IncomingUnknownProtocolPackets { get; }
                public abstract System.Int64 NonUnicastPacketsReceived { get; }
                public abstract System.Int64 NonUnicastPacketsSent { get; }
                public abstract System.Int64 OutgoingPacketsDiscarded { get; }
                public abstract System.Int64 OutgoingPacketsWithErrors { get; }
                public abstract System.Int64 OutputQueueLength { get; }
                public abstract System.Int64 UnicastPacketsReceived { get; }
                public abstract System.Int64 UnicastPacketsSent { get; }
            }

            // Generated from `System.Net.NetworkInformation.IPv6InterfaceProperties` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IPv6InterfaceProperties
            {
                public virtual System.Int64 GetScopeId(System.Net.NetworkInformation.ScopeLevel scopeLevel) => throw null;
                protected IPv6InterfaceProperties() => throw null;
                public abstract int Index { get; }
                public abstract int Mtu { get; }
            }

            // Generated from `System.Net.NetworkInformation.IcmpV4Statistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IcmpV4Statistics
            {
                public abstract System.Int64 AddressMaskRepliesReceived { get; }
                public abstract System.Int64 AddressMaskRepliesSent { get; }
                public abstract System.Int64 AddressMaskRequestsReceived { get; }
                public abstract System.Int64 AddressMaskRequestsSent { get; }
                public abstract System.Int64 DestinationUnreachableMessagesReceived { get; }
                public abstract System.Int64 DestinationUnreachableMessagesSent { get; }
                public abstract System.Int64 EchoRepliesReceived { get; }
                public abstract System.Int64 EchoRepliesSent { get; }
                public abstract System.Int64 EchoRequestsReceived { get; }
                public abstract System.Int64 EchoRequestsSent { get; }
                public abstract System.Int64 ErrorsReceived { get; }
                public abstract System.Int64 ErrorsSent { get; }
                protected IcmpV4Statistics() => throw null;
                public abstract System.Int64 MessagesReceived { get; }
                public abstract System.Int64 MessagesSent { get; }
                public abstract System.Int64 ParameterProblemsReceived { get; }
                public abstract System.Int64 ParameterProblemsSent { get; }
                public abstract System.Int64 RedirectsReceived { get; }
                public abstract System.Int64 RedirectsSent { get; }
                public abstract System.Int64 SourceQuenchesReceived { get; }
                public abstract System.Int64 SourceQuenchesSent { get; }
                public abstract System.Int64 TimeExceededMessagesReceived { get; }
                public abstract System.Int64 TimeExceededMessagesSent { get; }
                public abstract System.Int64 TimestampRepliesReceived { get; }
                public abstract System.Int64 TimestampRepliesSent { get; }
                public abstract System.Int64 TimestampRequestsReceived { get; }
                public abstract System.Int64 TimestampRequestsSent { get; }
            }

            // Generated from `System.Net.NetworkInformation.IcmpV6Statistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IcmpV6Statistics
            {
                public abstract System.Int64 DestinationUnreachableMessagesReceived { get; }
                public abstract System.Int64 DestinationUnreachableMessagesSent { get; }
                public abstract System.Int64 EchoRepliesReceived { get; }
                public abstract System.Int64 EchoRepliesSent { get; }
                public abstract System.Int64 EchoRequestsReceived { get; }
                public abstract System.Int64 EchoRequestsSent { get; }
                public abstract System.Int64 ErrorsReceived { get; }
                public abstract System.Int64 ErrorsSent { get; }
                protected IcmpV6Statistics() => throw null;
                public abstract System.Int64 MembershipQueriesReceived { get; }
                public abstract System.Int64 MembershipQueriesSent { get; }
                public abstract System.Int64 MembershipReductionsReceived { get; }
                public abstract System.Int64 MembershipReductionsSent { get; }
                public abstract System.Int64 MembershipReportsReceived { get; }
                public abstract System.Int64 MembershipReportsSent { get; }
                public abstract System.Int64 MessagesReceived { get; }
                public abstract System.Int64 MessagesSent { get; }
                public abstract System.Int64 NeighborAdvertisementsReceived { get; }
                public abstract System.Int64 NeighborAdvertisementsSent { get; }
                public abstract System.Int64 NeighborSolicitsReceived { get; }
                public abstract System.Int64 NeighborSolicitsSent { get; }
                public abstract System.Int64 PacketTooBigMessagesReceived { get; }
                public abstract System.Int64 PacketTooBigMessagesSent { get; }
                public abstract System.Int64 ParameterProblemsReceived { get; }
                public abstract System.Int64 ParameterProblemsSent { get; }
                public abstract System.Int64 RedirectsReceived { get; }
                public abstract System.Int64 RedirectsSent { get; }
                public abstract System.Int64 RouterAdvertisementsReceived { get; }
                public abstract System.Int64 RouterAdvertisementsSent { get; }
                public abstract System.Int64 RouterSolicitsReceived { get; }
                public abstract System.Int64 RouterSolicitsSent { get; }
                public abstract System.Int64 TimeExceededMessagesReceived { get; }
                public abstract System.Int64 TimeExceededMessagesSent { get; }
            }

            // Generated from `System.Net.NetworkInformation.MulticastIPAddressInformation` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class MulticastIPAddressInformation : System.Net.NetworkInformation.IPAddressInformation
            {
                public abstract System.Int64 AddressPreferredLifetime { get; }
                public abstract System.Int64 AddressValidLifetime { get; }
                public abstract System.Int64 DhcpLeaseLifetime { get; }
                public abstract System.Net.NetworkInformation.DuplicateAddressDetectionState DuplicateAddressDetectionState { get; }
                protected MulticastIPAddressInformation() => throw null;
                public abstract System.Net.NetworkInformation.PrefixOrigin PrefixOrigin { get; }
                public abstract System.Net.NetworkInformation.SuffixOrigin SuffixOrigin { get; }
            }

            // Generated from `System.Net.NetworkInformation.MulticastIPAddressInformationCollection` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MulticastIPAddressInformationCollection : System.Collections.Generic.ICollection<System.Net.NetworkInformation.MulticastIPAddressInformation>, System.Collections.Generic.IEnumerable<System.Net.NetworkInformation.MulticastIPAddressInformation>, System.Collections.IEnumerable
            {
                public virtual void Add(System.Net.NetworkInformation.MulticastIPAddressInformation address) => throw null;
                public virtual void Clear() => throw null;
                public virtual bool Contains(System.Net.NetworkInformation.MulticastIPAddressInformation address) => throw null;
                public virtual void CopyTo(System.Net.NetworkInformation.MulticastIPAddressInformation[] array, int offset) => throw null;
                public virtual int Count { get => throw null; }
                public virtual System.Collections.Generic.IEnumerator<System.Net.NetworkInformation.MulticastIPAddressInformation> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual bool IsReadOnly { get => throw null; }
                public virtual System.Net.NetworkInformation.MulticastIPAddressInformation this[int index] { get => throw null; }
                protected internal MulticastIPAddressInformationCollection() => throw null;
                public virtual bool Remove(System.Net.NetworkInformation.MulticastIPAddressInformation address) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.NetBiosNodeType` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum NetBiosNodeType
            {
                Broadcast,
                Hybrid,
                Mixed,
                Peer2Peer,
                Unknown,
            }

            // Generated from `System.Net.NetworkInformation.NetworkAddressChangedEventHandler` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void NetworkAddressChangedEventHandler(object sender, System.EventArgs e);

            // Generated from `System.Net.NetworkInformation.NetworkAvailabilityChangedEventHandler` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void NetworkAvailabilityChangedEventHandler(object sender, System.Net.NetworkInformation.NetworkAvailabilityEventArgs e);

            // Generated from `System.Net.NetworkInformation.NetworkAvailabilityEventArgs` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NetworkAvailabilityEventArgs : System.EventArgs
            {
                public bool IsAvailable { get => throw null; }
            }

            // Generated from `System.Net.NetworkInformation.NetworkChange` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NetworkChange
            {
                public static event System.Net.NetworkInformation.NetworkAddressChangedEventHandler NetworkAddressChanged;
                public static event System.Net.NetworkInformation.NetworkAvailabilityChangedEventHandler NetworkAvailabilityChanged;
                public NetworkChange() => throw null;
                public static void RegisterNetworkChange(System.Net.NetworkInformation.NetworkChange nc) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.NetworkInformationException` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NetworkInformationException : System.ComponentModel.Win32Exception
            {
                public override int ErrorCode { get => throw null; }
                public NetworkInformationException() => throw null;
                protected NetworkInformationException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public NetworkInformationException(int errorCode) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.NetworkInterface` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class NetworkInterface
            {
                public virtual string Description { get => throw null; }
                public static System.Net.NetworkInformation.NetworkInterface[] GetAllNetworkInterfaces() => throw null;
                public virtual System.Net.NetworkInformation.IPInterfaceProperties GetIPProperties() => throw null;
                public virtual System.Net.NetworkInformation.IPInterfaceStatistics GetIPStatistics() => throw null;
                public virtual System.Net.NetworkInformation.IPv4InterfaceStatistics GetIPv4Statistics() => throw null;
                public static bool GetIsNetworkAvailable() => throw null;
                public virtual System.Net.NetworkInformation.PhysicalAddress GetPhysicalAddress() => throw null;
                public static int IPv6LoopbackInterfaceIndex { get => throw null; }
                public virtual string Id { get => throw null; }
                public virtual bool IsReceiveOnly { get => throw null; }
                public static int LoopbackInterfaceIndex { get => throw null; }
                public virtual string Name { get => throw null; }
                protected NetworkInterface() => throw null;
                public virtual System.Net.NetworkInformation.NetworkInterfaceType NetworkInterfaceType { get => throw null; }
                public virtual System.Net.NetworkInformation.OperationalStatus OperationalStatus { get => throw null; }
                public virtual System.Int64 Speed { get => throw null; }
                public virtual bool Supports(System.Net.NetworkInformation.NetworkInterfaceComponent networkInterfaceComponent) => throw null;
                public virtual bool SupportsMulticast { get => throw null; }
            }

            // Generated from `System.Net.NetworkInformation.NetworkInterfaceComponent` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum NetworkInterfaceComponent
            {
                IPv4,
                IPv6,
            }

            // Generated from `System.Net.NetworkInformation.NetworkInterfaceType` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum NetworkInterfaceType
            {
                AsymmetricDsl,
                Atm,
                BasicIsdn,
                Ethernet,
                Ethernet3Megabit,
                FastEthernetFx,
                FastEthernetT,
                Fddi,
                GenericModem,
                GigabitEthernet,
                HighPerformanceSerialBus,
                IPOverAtm,
                Isdn,
                Loopback,
                MultiRateSymmetricDsl,
                Ppp,
                PrimaryIsdn,
                RateAdaptDsl,
                Slip,
                SymmetricDsl,
                TokenRing,
                Tunnel,
                Unknown,
                VeryHighSpeedDsl,
                Wireless80211,
                Wman,
                Wwanpp,
                Wwanpp2,
            }

            // Generated from `System.Net.NetworkInformation.OperationalStatus` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum OperationalStatus
            {
                Dormant,
                Down,
                LowerLayerDown,
                NotPresent,
                Testing,
                Unknown,
                Up,
            }

            // Generated from `System.Net.NetworkInformation.PhysicalAddress` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PhysicalAddress
            {
                public override bool Equals(object comparand) => throw null;
                public System.Byte[] GetAddressBytes() => throw null;
                public override int GetHashCode() => throw null;
                public static System.Net.NetworkInformation.PhysicalAddress None;
                public static System.Net.NetworkInformation.PhysicalAddress Parse(System.ReadOnlySpan<System.Char> address) => throw null;
                public static System.Net.NetworkInformation.PhysicalAddress Parse(string address) => throw null;
                public PhysicalAddress(System.Byte[] address) => throw null;
                public override string ToString() => throw null;
                public static bool TryParse(System.ReadOnlySpan<System.Char> address, out System.Net.NetworkInformation.PhysicalAddress value) => throw null;
                public static bool TryParse(string address, out System.Net.NetworkInformation.PhysicalAddress value) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.PrefixOrigin` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PrefixOrigin
            {
                Dhcp,
                Manual,
                Other,
                RouterAdvertisement,
                WellKnown,
            }

            // Generated from `System.Net.NetworkInformation.ScopeLevel` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ScopeLevel
            {
                Admin,
                Global,
                Interface,
                Link,
                None,
                Organization,
                Site,
                Subnet,
            }

            // Generated from `System.Net.NetworkInformation.SuffixOrigin` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SuffixOrigin
            {
                LinkLayerAddress,
                Manual,
                OriginDhcp,
                Other,
                Random,
                WellKnown,
            }

            // Generated from `System.Net.NetworkInformation.TcpConnectionInformation` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class TcpConnectionInformation
            {
                public abstract System.Net.IPEndPoint LocalEndPoint { get; }
                public abstract System.Net.IPEndPoint RemoteEndPoint { get; }
                public abstract System.Net.NetworkInformation.TcpState State { get; }
                protected TcpConnectionInformation() => throw null;
            }

            // Generated from `System.Net.NetworkInformation.TcpState` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum TcpState
            {
                CloseWait,
                Closed,
                Closing,
                DeleteTcb,
                Established,
                FinWait1,
                FinWait2,
                LastAck,
                Listen,
                SynReceived,
                SynSent,
                TimeWait,
                Unknown,
            }

            // Generated from `System.Net.NetworkInformation.TcpStatistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class TcpStatistics
            {
                public abstract System.Int64 ConnectionsAccepted { get; }
                public abstract System.Int64 ConnectionsInitiated { get; }
                public abstract System.Int64 CumulativeConnections { get; }
                public abstract System.Int64 CurrentConnections { get; }
                public abstract System.Int64 ErrorsReceived { get; }
                public abstract System.Int64 FailedConnectionAttempts { get; }
                public abstract System.Int64 MaximumConnections { get; }
                public abstract System.Int64 MaximumTransmissionTimeout { get; }
                public abstract System.Int64 MinimumTransmissionTimeout { get; }
                public abstract System.Int64 ResetConnections { get; }
                public abstract System.Int64 ResetsSent { get; }
                public abstract System.Int64 SegmentsReceived { get; }
                public abstract System.Int64 SegmentsResent { get; }
                public abstract System.Int64 SegmentsSent { get; }
                protected TcpStatistics() => throw null;
            }

            // Generated from `System.Net.NetworkInformation.UdpStatistics` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class UdpStatistics
            {
                public abstract System.Int64 DatagramsReceived { get; }
                public abstract System.Int64 DatagramsSent { get; }
                public abstract System.Int64 IncomingDatagramsDiscarded { get; }
                public abstract System.Int64 IncomingDatagramsWithErrors { get; }
                public abstract int UdpListeners { get; }
                protected UdpStatistics() => throw null;
            }

            // Generated from `System.Net.NetworkInformation.UnicastIPAddressInformation` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class UnicastIPAddressInformation : System.Net.NetworkInformation.IPAddressInformation
            {
                public abstract System.Int64 AddressPreferredLifetime { get; }
                public abstract System.Int64 AddressValidLifetime { get; }
                public abstract System.Int64 DhcpLeaseLifetime { get; }
                public abstract System.Net.NetworkInformation.DuplicateAddressDetectionState DuplicateAddressDetectionState { get; }
                public abstract System.Net.IPAddress IPv4Mask { get; }
                public virtual int PrefixLength { get => throw null; }
                public abstract System.Net.NetworkInformation.PrefixOrigin PrefixOrigin { get; }
                public abstract System.Net.NetworkInformation.SuffixOrigin SuffixOrigin { get; }
                protected UnicastIPAddressInformation() => throw null;
            }

            // Generated from `System.Net.NetworkInformation.UnicastIPAddressInformationCollection` in `System.Net.NetworkInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UnicastIPAddressInformationCollection : System.Collections.Generic.ICollection<System.Net.NetworkInformation.UnicastIPAddressInformation>, System.Collections.Generic.IEnumerable<System.Net.NetworkInformation.UnicastIPAddressInformation>, System.Collections.IEnumerable
            {
                public virtual void Add(System.Net.NetworkInformation.UnicastIPAddressInformation address) => throw null;
                public virtual void Clear() => throw null;
                public virtual bool Contains(System.Net.NetworkInformation.UnicastIPAddressInformation address) => throw null;
                public virtual void CopyTo(System.Net.NetworkInformation.UnicastIPAddressInformation[] array, int offset) => throw null;
                public virtual int Count { get => throw null; }
                public virtual System.Collections.Generic.IEnumerator<System.Net.NetworkInformation.UnicastIPAddressInformation> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual bool IsReadOnly { get => throw null; }
                public virtual System.Net.NetworkInformation.UnicastIPAddressInformation this[int index] { get => throw null; }
                public virtual bool Remove(System.Net.NetworkInformation.UnicastIPAddressInformation address) => throw null;
                protected internal UnicastIPAddressInformationCollection() => throw null;
            }

        }
    }
}
