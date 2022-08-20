// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace Security
        {
            // Generated from `System.Net.Security.AuthenticatedStream` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AuthenticatedStream : System.IO.Stream
            {
                protected AuthenticatedStream(System.IO.Stream innerStream, bool leaveInnerStreamOpen) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected System.IO.Stream InnerStream { get => throw null; }
                public abstract bool IsAuthenticated { get; }
                public abstract bool IsEncrypted { get; }
                public abstract bool IsMutuallyAuthenticated { get; }
                public abstract bool IsServer { get; }
                public abstract bool IsSigned { get; }
                public bool LeaveInnerStreamOpen { get => throw null; }
            }

            // Generated from `System.Net.Security.CipherSuitesPolicy` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CipherSuitesPolicy
            {
                public System.Collections.Generic.IEnumerable<System.Net.Security.TlsCipherSuite> AllowedCipherSuites { get => throw null; }
                public CipherSuitesPolicy(System.Collections.Generic.IEnumerable<System.Net.Security.TlsCipherSuite> allowedCipherSuites) => throw null;
            }

            // Generated from `System.Net.Security.EncryptionPolicy` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EncryptionPolicy : int
            {
                AllowNoEncryption = 1,
                NoEncryption = 2,
                RequireEncryption = 0,
            }

            // Generated from `System.Net.Security.LocalCertificateSelectionCallback` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Security.Cryptography.X509Certificates.X509Certificate LocalCertificateSelectionCallback(object sender, string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection localCertificates, System.Security.Cryptography.X509Certificates.X509Certificate remoteCertificate, string[] acceptableIssuers);

            // Generated from `System.Net.Security.NegotiateStream` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NegotiateStream : System.Net.Security.AuthenticatedStream
            {
                public virtual void AuthenticateAsClient() => throw null;
                public virtual void AuthenticateAsClient(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ChannelBinding binding, string targetName) => throw null;
                public virtual void AuthenticateAsClient(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ChannelBinding binding, string targetName, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel allowedImpersonationLevel) => throw null;
                public virtual void AuthenticateAsClient(System.Net.NetworkCredential credential, string targetName) => throw null;
                public virtual void AuthenticateAsClient(System.Net.NetworkCredential credential, string targetName, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel allowedImpersonationLevel) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync() => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ChannelBinding binding, string targetName) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ChannelBinding binding, string targetName, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel allowedImpersonationLevel) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(System.Net.NetworkCredential credential, string targetName) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(System.Net.NetworkCredential credential, string targetName, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel allowedImpersonationLevel) => throw null;
                public virtual void AuthenticateAsServer() => throw null;
                public virtual void AuthenticateAsServer(System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy policy) => throw null;
                public virtual void AuthenticateAsServer(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy policy, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel requiredImpersonationLevel) => throw null;
                public virtual void AuthenticateAsServer(System.Net.NetworkCredential credential, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel requiredImpersonationLevel) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync() => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy policy) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy policy, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel requiredImpersonationLevel) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Net.NetworkCredential credential, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel requiredImpersonationLevel) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ChannelBinding binding, string targetName, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ChannelBinding binding, string targetName, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel allowedImpersonationLevel, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(System.Net.NetworkCredential credential, string targetName, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(System.Net.NetworkCredential credential, string targetName, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel allowedImpersonationLevel, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy policy, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.Net.NetworkCredential credential, System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy policy, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel requiredImpersonationLevel, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.Net.NetworkCredential credential, System.Net.Security.ProtectionLevel requiredProtectionLevel, System.Security.Principal.TokenImpersonationLevel requiredImpersonationLevel, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public virtual void EndAuthenticateAsClient(System.IAsyncResult asyncResult) => throw null;
                public virtual void EndAuthenticateAsServer(System.IAsyncResult asyncResult) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Security.Principal.TokenImpersonationLevel ImpersonationLevel { get => throw null; }
                public override bool IsAuthenticated { get => throw null; }
                public override bool IsEncrypted { get => throw null; }
                public override bool IsMutuallyAuthenticated { get => throw null; }
                public override bool IsServer { get => throw null; }
                public override bool IsSigned { get => throw null; }
                public override System.Int64 Length { get => throw null; }
                public NegotiateStream(System.IO.Stream innerStream) : base(default(System.IO.Stream), default(bool)) => throw null;
                public NegotiateStream(System.IO.Stream innerStream, bool leaveInnerStreamOpen) : base(default(System.IO.Stream), default(bool)) => throw null;
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadTimeout { get => throw null; set => throw null; }
                public virtual System.Security.Principal.IIdentity RemoteIdentity { get => throw null; }
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int WriteTimeout { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Security.ProtectionLevel` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ProtectionLevel : int
            {
                EncryptAndSign = 2,
                None = 0,
                Sign = 1,
            }

            // Generated from `System.Net.Security.RemoteCertificateValidationCallback` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate bool RemoteCertificateValidationCallback(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certificate, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors);

            // Generated from `System.Net.Security.ServerCertificateSelectionCallback` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Security.Cryptography.X509Certificates.X509Certificate ServerCertificateSelectionCallback(object sender, string hostName);

            // Generated from `System.Net.Security.ServerOptionsSelectionCallback` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Threading.Tasks.ValueTask<System.Net.Security.SslServerAuthenticationOptions> ServerOptionsSelectionCallback(System.Net.Security.SslStream stream, System.Net.Security.SslClientHelloInfo clientHelloInfo, object state, System.Threading.CancellationToken cancellationToken);

            // Generated from `System.Net.Security.SslApplicationProtocol` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SslApplicationProtocol : System.IEquatable<System.Net.Security.SslApplicationProtocol>
            {
                public static bool operator !=(System.Net.Security.SslApplicationProtocol left, System.Net.Security.SslApplicationProtocol right) => throw null;
                public static bool operator ==(System.Net.Security.SslApplicationProtocol left, System.Net.Security.SslApplicationProtocol right) => throw null;
                public bool Equals(System.Net.Security.SslApplicationProtocol other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Net.Security.SslApplicationProtocol Http11;
                public static System.Net.Security.SslApplicationProtocol Http2;
                public static System.Net.Security.SslApplicationProtocol Http3;
                public System.ReadOnlyMemory<System.Byte> Protocol { get => throw null; }
                // Stub generator skipped constructor 
                public SslApplicationProtocol(System.Byte[] protocol) => throw null;
                public SslApplicationProtocol(string protocol) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Net.Security.SslCertificateTrust` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SslCertificateTrust
            {
                public static System.Net.Security.SslCertificateTrust CreateForX509Collection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection trustList, bool sendTrustInHandshake = default(bool)) => throw null;
                public static System.Net.Security.SslCertificateTrust CreateForX509Store(System.Security.Cryptography.X509Certificates.X509Store store, bool sendTrustInHandshake = default(bool)) => throw null;
            }

            // Generated from `System.Net.Security.SslClientAuthenticationOptions` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SslClientAuthenticationOptions
            {
                public bool AllowRenegotiation { get => throw null; set => throw null; }
                public System.Collections.Generic.List<System.Net.Security.SslApplicationProtocol> ApplicationProtocols { get => throw null; set => throw null; }
                public System.Security.Cryptography.X509Certificates.X509RevocationMode CertificateRevocationCheckMode { get => throw null; set => throw null; }
                public System.Net.Security.CipherSuitesPolicy CipherSuitesPolicy { get => throw null; set => throw null; }
                public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; set => throw null; }
                public System.Security.Authentication.SslProtocols EnabledSslProtocols { get => throw null; set => throw null; }
                public System.Net.Security.EncryptionPolicy EncryptionPolicy { get => throw null; set => throw null; }
                public System.Net.Security.LocalCertificateSelectionCallback LocalCertificateSelectionCallback { get => throw null; set => throw null; }
                public System.Net.Security.RemoteCertificateValidationCallback RemoteCertificateValidationCallback { get => throw null; set => throw null; }
                public SslClientAuthenticationOptions() => throw null;
                public string TargetHost { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Security.SslClientHelloInfo` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SslClientHelloInfo
            {
                public string ServerName { get => throw null; }
                // Stub generator skipped constructor 
                public System.Security.Authentication.SslProtocols SslProtocols { get => throw null; }
            }

            // Generated from `System.Net.Security.SslServerAuthenticationOptions` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SslServerAuthenticationOptions
            {
                public bool AllowRenegotiation { get => throw null; set => throw null; }
                public System.Collections.Generic.List<System.Net.Security.SslApplicationProtocol> ApplicationProtocols { get => throw null; set => throw null; }
                public System.Security.Cryptography.X509Certificates.X509RevocationMode CertificateRevocationCheckMode { get => throw null; set => throw null; }
                public System.Net.Security.CipherSuitesPolicy CipherSuitesPolicy { get => throw null; set => throw null; }
                public bool ClientCertificateRequired { get => throw null; set => throw null; }
                public System.Security.Authentication.SslProtocols EnabledSslProtocols { get => throw null; set => throw null; }
                public System.Net.Security.EncryptionPolicy EncryptionPolicy { get => throw null; set => throw null; }
                public System.Net.Security.RemoteCertificateValidationCallback RemoteCertificateValidationCallback { get => throw null; set => throw null; }
                public System.Security.Cryptography.X509Certificates.X509Certificate ServerCertificate { get => throw null; set => throw null; }
                public System.Net.Security.SslStreamCertificateContext ServerCertificateContext { get => throw null; set => throw null; }
                public System.Net.Security.ServerCertificateSelectionCallback ServerCertificateSelectionCallback { get => throw null; set => throw null; }
                public SslServerAuthenticationOptions() => throw null;
            }

            // Generated from `System.Net.Security.SslStream` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SslStream : System.Net.Security.AuthenticatedStream
            {
                public void AuthenticateAsClient(System.Net.Security.SslClientAuthenticationOptions sslClientAuthenticationOptions) => throw null;
                public virtual void AuthenticateAsClient(string targetHost) => throw null;
                public virtual void AuthenticateAsClient(string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection clientCertificates, System.Security.Authentication.SslProtocols enabledSslProtocols, bool checkCertificateRevocation) => throw null;
                public virtual void AuthenticateAsClient(string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection clientCertificates, bool checkCertificateRevocation) => throw null;
                public System.Threading.Tasks.Task AuthenticateAsClientAsync(System.Net.Security.SslClientAuthenticationOptions sslClientAuthenticationOptions, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(string targetHost) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection clientCertificates, System.Security.Authentication.SslProtocols enabledSslProtocols, bool checkCertificateRevocation) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsClientAsync(string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection clientCertificates, bool checkCertificateRevocation) => throw null;
                public void AuthenticateAsServer(System.Net.Security.SslServerAuthenticationOptions sslServerAuthenticationOptions) => throw null;
                public virtual void AuthenticateAsServer(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate) => throw null;
                public virtual void AuthenticateAsServer(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, bool clientCertificateRequired, System.Security.Authentication.SslProtocols enabledSslProtocols, bool checkCertificateRevocation) => throw null;
                public virtual void AuthenticateAsServer(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, bool clientCertificateRequired, bool checkCertificateRevocation) => throw null;
                public System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Net.Security.ServerOptionsSelectionCallback optionsCallback, object state, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Net.Security.SslServerAuthenticationOptions sslServerAuthenticationOptions, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, bool clientCertificateRequired, System.Security.Authentication.SslProtocols enabledSslProtocols, bool checkCertificateRevocation) => throw null;
                public virtual System.Threading.Tasks.Task AuthenticateAsServerAsync(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, bool clientCertificateRequired, bool checkCertificateRevocation) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(string targetHost, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection clientCertificates, System.Security.Authentication.SslProtocols enabledSslProtocols, bool checkCertificateRevocation, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsClient(string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection clientCertificates, bool checkCertificateRevocation, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, bool clientCertificateRequired, System.Security.Authentication.SslProtocols enabledSslProtocols, bool checkCertificateRevocation, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public virtual System.IAsyncResult BeginAuthenticateAsServer(System.Security.Cryptography.X509Certificates.X509Certificate serverCertificate, bool clientCertificateRequired, bool checkCertificateRevocation, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginRead(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] buffer, int offset, int count, System.AsyncCallback asyncCallback, object asyncState) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanTimeout { get => throw null; }
                public override bool CanWrite { get => throw null; }
                public virtual bool CheckCertRevocationStatus { get => throw null; }
                public virtual System.Security.Authentication.CipherAlgorithmType CipherAlgorithm { get => throw null; }
                public virtual int CipherStrength { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public virtual void EndAuthenticateAsClient(System.IAsyncResult asyncResult) => throw null;
                public virtual void EndAuthenticateAsServer(System.IAsyncResult asyncResult) => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Security.Authentication.HashAlgorithmType HashAlgorithm { get => throw null; }
                public virtual int HashStrength { get => throw null; }
                public override bool IsAuthenticated { get => throw null; }
                public override bool IsEncrypted { get => throw null; }
                public override bool IsMutuallyAuthenticated { get => throw null; }
                public override bool IsServer { get => throw null; }
                public override bool IsSigned { get => throw null; }
                public virtual System.Security.Authentication.ExchangeAlgorithmType KeyExchangeAlgorithm { get => throw null; }
                public virtual int KeyExchangeStrength { get => throw null; }
                public override System.Int64 Length { get => throw null; }
                public virtual System.Security.Cryptography.X509Certificates.X509Certificate LocalCertificate { get => throw null; }
                public virtual System.Threading.Tasks.Task NegotiateClientCertificateAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Net.Security.SslApplicationProtocol NegotiatedApplicationProtocol { get => throw null; }
                public virtual System.Net.Security.TlsCipherSuite NegotiatedCipherSuite { get => throw null; }
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override int ReadTimeout { get => throw null; set => throw null; }
                public virtual System.Security.Cryptography.X509Certificates.X509Certificate RemoteCertificate { get => throw null; }
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public virtual System.Threading.Tasks.Task ShutdownAsync() => throw null;
                public virtual System.Security.Authentication.SslProtocols SslProtocol { get => throw null; }
                public SslStream(System.IO.Stream innerStream) : base(default(System.IO.Stream), default(bool)) => throw null;
                public SslStream(System.IO.Stream innerStream, bool leaveInnerStreamOpen) : base(default(System.IO.Stream), default(bool)) => throw null;
                public SslStream(System.IO.Stream innerStream, bool leaveInnerStreamOpen, System.Net.Security.RemoteCertificateValidationCallback userCertificateValidationCallback) : base(default(System.IO.Stream), default(bool)) => throw null;
                public SslStream(System.IO.Stream innerStream, bool leaveInnerStreamOpen, System.Net.Security.RemoteCertificateValidationCallback userCertificateValidationCallback, System.Net.Security.LocalCertificateSelectionCallback userCertificateSelectionCallback) : base(default(System.IO.Stream), default(bool)) => throw null;
                public SslStream(System.IO.Stream innerStream, bool leaveInnerStreamOpen, System.Net.Security.RemoteCertificateValidationCallback userCertificateValidationCallback, System.Net.Security.LocalCertificateSelectionCallback userCertificateSelectionCallback, System.Net.Security.EncryptionPolicy encryptionPolicy) : base(default(System.IO.Stream), default(bool)) => throw null;
                public string TargetHostName { get => throw null; }
                public System.Net.TransportContext TransportContext { get => throw null; }
                public void Write(System.Byte[] buffer) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int WriteTimeout { get => throw null; set => throw null; }
                // ERR: Stub generator didn't handle member: ~SslStream
            }

            // Generated from `System.Net.Security.SslStreamCertificateContext` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SslStreamCertificateContext
            {
                public static System.Net.Security.SslStreamCertificateContext Create(System.Security.Cryptography.X509Certificates.X509Certificate2 target, System.Security.Cryptography.X509Certificates.X509Certificate2Collection additionalCertificates, bool offline) => throw null;
                public static System.Net.Security.SslStreamCertificateContext Create(System.Security.Cryptography.X509Certificates.X509Certificate2 target, System.Security.Cryptography.X509Certificates.X509Certificate2Collection additionalCertificates, bool offline = default(bool), System.Net.Security.SslCertificateTrust trust = default(System.Net.Security.SslCertificateTrust)) => throw null;
            }

            // Generated from `System.Net.Security.TlsCipherSuite` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum TlsCipherSuite : ushort
            {
                TLS_AES_128_CCM_8_SHA256 = 4869,
                TLS_AES_128_CCM_SHA256 = 4868,
                TLS_AES_128_GCM_SHA256 = 4865,
                TLS_AES_256_GCM_SHA384 = 4866,
                TLS_CHACHA20_POLY1305_SHA256 = 4867,
                TLS_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA = 17,
                TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA = 19,
                TLS_DHE_DSS_WITH_AES_128_CBC_SHA = 50,
                TLS_DHE_DSS_WITH_AES_128_CBC_SHA256 = 64,
                TLS_DHE_DSS_WITH_AES_128_GCM_SHA256 = 162,
                TLS_DHE_DSS_WITH_AES_256_CBC_SHA = 56,
                TLS_DHE_DSS_WITH_AES_256_CBC_SHA256 = 106,
                TLS_DHE_DSS_WITH_AES_256_GCM_SHA384 = 163,
                TLS_DHE_DSS_WITH_ARIA_128_CBC_SHA256 = 49218,
                TLS_DHE_DSS_WITH_ARIA_128_GCM_SHA256 = 49238,
                TLS_DHE_DSS_WITH_ARIA_256_CBC_SHA384 = 49219,
                TLS_DHE_DSS_WITH_ARIA_256_GCM_SHA384 = 49239,
                TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA = 68,
                TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA256 = 189,
                TLS_DHE_DSS_WITH_CAMELLIA_128_GCM_SHA256 = 49280,
                TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA = 135,
                TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA256 = 195,
                TLS_DHE_DSS_WITH_CAMELLIA_256_GCM_SHA384 = 49281,
                TLS_DHE_DSS_WITH_DES_CBC_SHA = 18,
                TLS_DHE_DSS_WITH_SEED_CBC_SHA = 153,
                TLS_DHE_PSK_WITH_3DES_EDE_CBC_SHA = 143,
                TLS_DHE_PSK_WITH_AES_128_CBC_SHA = 144,
                TLS_DHE_PSK_WITH_AES_128_CBC_SHA256 = 178,
                TLS_DHE_PSK_WITH_AES_128_CCM = 49318,
                TLS_DHE_PSK_WITH_AES_128_GCM_SHA256 = 170,
                TLS_DHE_PSK_WITH_AES_256_CBC_SHA = 145,
                TLS_DHE_PSK_WITH_AES_256_CBC_SHA384 = 179,
                TLS_DHE_PSK_WITH_AES_256_CCM = 49319,
                TLS_DHE_PSK_WITH_AES_256_GCM_SHA384 = 171,
                TLS_DHE_PSK_WITH_ARIA_128_CBC_SHA256 = 49254,
                TLS_DHE_PSK_WITH_ARIA_128_GCM_SHA256 = 49260,
                TLS_DHE_PSK_WITH_ARIA_256_CBC_SHA384 = 49255,
                TLS_DHE_PSK_WITH_ARIA_256_GCM_SHA384 = 49261,
                TLS_DHE_PSK_WITH_CAMELLIA_128_CBC_SHA256 = 49302,
                TLS_DHE_PSK_WITH_CAMELLIA_128_GCM_SHA256 = 49296,
                TLS_DHE_PSK_WITH_CAMELLIA_256_CBC_SHA384 = 49303,
                TLS_DHE_PSK_WITH_CAMELLIA_256_GCM_SHA384 = 49297,
                TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256 = 52397,
                TLS_DHE_PSK_WITH_NULL_SHA = 45,
                TLS_DHE_PSK_WITH_NULL_SHA256 = 180,
                TLS_DHE_PSK_WITH_NULL_SHA384 = 181,
                TLS_DHE_PSK_WITH_RC4_128_SHA = 142,
                TLS_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA = 20,
                TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA = 22,
                TLS_DHE_RSA_WITH_AES_128_CBC_SHA = 51,
                TLS_DHE_RSA_WITH_AES_128_CBC_SHA256 = 103,
                TLS_DHE_RSA_WITH_AES_128_CCM = 49310,
                TLS_DHE_RSA_WITH_AES_128_CCM_8 = 49314,
                TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 = 158,
                TLS_DHE_RSA_WITH_AES_256_CBC_SHA = 57,
                TLS_DHE_RSA_WITH_AES_256_CBC_SHA256 = 107,
                TLS_DHE_RSA_WITH_AES_256_CCM = 49311,
                TLS_DHE_RSA_WITH_AES_256_CCM_8 = 49315,
                TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 = 159,
                TLS_DHE_RSA_WITH_ARIA_128_CBC_SHA256 = 49220,
                TLS_DHE_RSA_WITH_ARIA_128_GCM_SHA256 = 49234,
                TLS_DHE_RSA_WITH_ARIA_256_CBC_SHA384 = 49221,
                TLS_DHE_RSA_WITH_ARIA_256_GCM_SHA384 = 49235,
                TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA = 69,
                TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256 = 190,
                TLS_DHE_RSA_WITH_CAMELLIA_128_GCM_SHA256 = 49276,
                TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA = 136,
                TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256 = 196,
                TLS_DHE_RSA_WITH_CAMELLIA_256_GCM_SHA384 = 49277,
                TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256 = 52394,
                TLS_DHE_RSA_WITH_DES_CBC_SHA = 21,
                TLS_DHE_RSA_WITH_SEED_CBC_SHA = 154,
                TLS_DH_DSS_EXPORT_WITH_DES40_CBC_SHA = 11,
                TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA = 13,
                TLS_DH_DSS_WITH_AES_128_CBC_SHA = 48,
                TLS_DH_DSS_WITH_AES_128_CBC_SHA256 = 62,
                TLS_DH_DSS_WITH_AES_128_GCM_SHA256 = 164,
                TLS_DH_DSS_WITH_AES_256_CBC_SHA = 54,
                TLS_DH_DSS_WITH_AES_256_CBC_SHA256 = 104,
                TLS_DH_DSS_WITH_AES_256_GCM_SHA384 = 165,
                TLS_DH_DSS_WITH_ARIA_128_CBC_SHA256 = 49214,
                TLS_DH_DSS_WITH_ARIA_128_GCM_SHA256 = 49240,
                TLS_DH_DSS_WITH_ARIA_256_CBC_SHA384 = 49215,
                TLS_DH_DSS_WITH_ARIA_256_GCM_SHA384 = 49241,
                TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA = 66,
                TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA256 = 187,
                TLS_DH_DSS_WITH_CAMELLIA_128_GCM_SHA256 = 49282,
                TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA = 133,
                TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA256 = 193,
                TLS_DH_DSS_WITH_CAMELLIA_256_GCM_SHA384 = 49283,
                TLS_DH_DSS_WITH_DES_CBC_SHA = 12,
                TLS_DH_DSS_WITH_SEED_CBC_SHA = 151,
                TLS_DH_RSA_EXPORT_WITH_DES40_CBC_SHA = 14,
                TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA = 16,
                TLS_DH_RSA_WITH_AES_128_CBC_SHA = 49,
                TLS_DH_RSA_WITH_AES_128_CBC_SHA256 = 63,
                TLS_DH_RSA_WITH_AES_128_GCM_SHA256 = 160,
                TLS_DH_RSA_WITH_AES_256_CBC_SHA = 55,
                TLS_DH_RSA_WITH_AES_256_CBC_SHA256 = 105,
                TLS_DH_RSA_WITH_AES_256_GCM_SHA384 = 161,
                TLS_DH_RSA_WITH_ARIA_128_CBC_SHA256 = 49216,
                TLS_DH_RSA_WITH_ARIA_128_GCM_SHA256 = 49236,
                TLS_DH_RSA_WITH_ARIA_256_CBC_SHA384 = 49217,
                TLS_DH_RSA_WITH_ARIA_256_GCM_SHA384 = 49237,
                TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA = 67,
                TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA256 = 188,
                TLS_DH_RSA_WITH_CAMELLIA_128_GCM_SHA256 = 49278,
                TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA = 134,
                TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA256 = 194,
                TLS_DH_RSA_WITH_CAMELLIA_256_GCM_SHA384 = 49279,
                TLS_DH_RSA_WITH_DES_CBC_SHA = 15,
                TLS_DH_RSA_WITH_SEED_CBC_SHA = 152,
                TLS_DH_anon_EXPORT_WITH_DES40_CBC_SHA = 25,
                TLS_DH_anon_EXPORT_WITH_RC4_40_MD5 = 23,
                TLS_DH_anon_WITH_3DES_EDE_CBC_SHA = 27,
                TLS_DH_anon_WITH_AES_128_CBC_SHA = 52,
                TLS_DH_anon_WITH_AES_128_CBC_SHA256 = 108,
                TLS_DH_anon_WITH_AES_128_GCM_SHA256 = 166,
                TLS_DH_anon_WITH_AES_256_CBC_SHA = 58,
                TLS_DH_anon_WITH_AES_256_CBC_SHA256 = 109,
                TLS_DH_anon_WITH_AES_256_GCM_SHA384 = 167,
                TLS_DH_anon_WITH_ARIA_128_CBC_SHA256 = 49222,
                TLS_DH_anon_WITH_ARIA_128_GCM_SHA256 = 49242,
                TLS_DH_anon_WITH_ARIA_256_CBC_SHA384 = 49223,
                TLS_DH_anon_WITH_ARIA_256_GCM_SHA384 = 49243,
                TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA = 70,
                TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA256 = 191,
                TLS_DH_anon_WITH_CAMELLIA_128_GCM_SHA256 = 49284,
                TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA = 137,
                TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA256 = 197,
                TLS_DH_anon_WITH_CAMELLIA_256_GCM_SHA384 = 49285,
                TLS_DH_anon_WITH_DES_CBC_SHA = 26,
                TLS_DH_anon_WITH_RC4_128_MD5 = 24,
                TLS_DH_anon_WITH_SEED_CBC_SHA = 155,
                TLS_ECCPWD_WITH_AES_128_CCM_SHA256 = 49330,
                TLS_ECCPWD_WITH_AES_128_GCM_SHA256 = 49328,
                TLS_ECCPWD_WITH_AES_256_CCM_SHA384 = 49331,
                TLS_ECCPWD_WITH_AES_256_GCM_SHA384 = 49329,
                TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA = 49160,
                TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA = 49161,
                TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256 = 49187,
                TLS_ECDHE_ECDSA_WITH_AES_128_CCM = 49324,
                TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8 = 49326,
                TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 = 49195,
                TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA = 49162,
                TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384 = 49188,
                TLS_ECDHE_ECDSA_WITH_AES_256_CCM = 49325,
                TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8 = 49327,
                TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 = 49196,
                TLS_ECDHE_ECDSA_WITH_ARIA_128_CBC_SHA256 = 49224,
                TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256 = 49244,
                TLS_ECDHE_ECDSA_WITH_ARIA_256_CBC_SHA384 = 49225,
                TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384 = 49245,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_CBC_SHA256 = 49266,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_GCM_SHA256 = 49286,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_CBC_SHA384 = 49267,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_GCM_SHA384 = 49287,
                TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256 = 52393,
                TLS_ECDHE_ECDSA_WITH_NULL_SHA = 49158,
                TLS_ECDHE_ECDSA_WITH_RC4_128_SHA = 49159,
                TLS_ECDHE_PSK_WITH_3DES_EDE_CBC_SHA = 49204,
                TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA = 49205,
                TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256 = 49207,
                TLS_ECDHE_PSK_WITH_AES_128_CCM_8_SHA256 = 53251,
                TLS_ECDHE_PSK_WITH_AES_128_CCM_SHA256 = 53253,
                TLS_ECDHE_PSK_WITH_AES_128_GCM_SHA256 = 53249,
                TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA = 49206,
                TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA384 = 49208,
                TLS_ECDHE_PSK_WITH_AES_256_GCM_SHA384 = 53250,
                TLS_ECDHE_PSK_WITH_ARIA_128_CBC_SHA256 = 49264,
                TLS_ECDHE_PSK_WITH_ARIA_256_CBC_SHA384 = 49265,
                TLS_ECDHE_PSK_WITH_CAMELLIA_128_CBC_SHA256 = 49306,
                TLS_ECDHE_PSK_WITH_CAMELLIA_256_CBC_SHA384 = 49307,
                TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256 = 52396,
                TLS_ECDHE_PSK_WITH_NULL_SHA = 49209,
                TLS_ECDHE_PSK_WITH_NULL_SHA256 = 49210,
                TLS_ECDHE_PSK_WITH_NULL_SHA384 = 49211,
                TLS_ECDHE_PSK_WITH_RC4_128_SHA = 49203,
                TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA = 49170,
                TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA = 49171,
                TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 = 49191,
                TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 = 49199,
                TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA = 49172,
                TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 = 49192,
                TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 = 49200,
                TLS_ECDHE_RSA_WITH_ARIA_128_CBC_SHA256 = 49228,
                TLS_ECDHE_RSA_WITH_ARIA_128_GCM_SHA256 = 49248,
                TLS_ECDHE_RSA_WITH_ARIA_256_CBC_SHA384 = 49229,
                TLS_ECDHE_RSA_WITH_ARIA_256_GCM_SHA384 = 49249,
                TLS_ECDHE_RSA_WITH_CAMELLIA_128_CBC_SHA256 = 49270,
                TLS_ECDHE_RSA_WITH_CAMELLIA_128_GCM_SHA256 = 49290,
                TLS_ECDHE_RSA_WITH_CAMELLIA_256_CBC_SHA384 = 49271,
                TLS_ECDHE_RSA_WITH_CAMELLIA_256_GCM_SHA384 = 49291,
                TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 = 52392,
                TLS_ECDHE_RSA_WITH_NULL_SHA = 49168,
                TLS_ECDHE_RSA_WITH_RC4_128_SHA = 49169,
                TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA = 49155,
                TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA = 49156,
                TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256 = 49189,
                TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256 = 49197,
                TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA = 49157,
                TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384 = 49190,
                TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384 = 49198,
                TLS_ECDH_ECDSA_WITH_ARIA_128_CBC_SHA256 = 49226,
                TLS_ECDH_ECDSA_WITH_ARIA_128_GCM_SHA256 = 49246,
                TLS_ECDH_ECDSA_WITH_ARIA_256_CBC_SHA384 = 49227,
                TLS_ECDH_ECDSA_WITH_ARIA_256_GCM_SHA384 = 49247,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_128_CBC_SHA256 = 49268,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_128_GCM_SHA256 = 49288,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_256_CBC_SHA384 = 49269,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_256_GCM_SHA384 = 49289,
                TLS_ECDH_ECDSA_WITH_NULL_SHA = 49153,
                TLS_ECDH_ECDSA_WITH_RC4_128_SHA = 49154,
                TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA = 49165,
                TLS_ECDH_RSA_WITH_AES_128_CBC_SHA = 49166,
                TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256 = 49193,
                TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256 = 49201,
                TLS_ECDH_RSA_WITH_AES_256_CBC_SHA = 49167,
                TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384 = 49194,
                TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384 = 49202,
                TLS_ECDH_RSA_WITH_ARIA_128_CBC_SHA256 = 49230,
                TLS_ECDH_RSA_WITH_ARIA_128_GCM_SHA256 = 49250,
                TLS_ECDH_RSA_WITH_ARIA_256_CBC_SHA384 = 49231,
                TLS_ECDH_RSA_WITH_ARIA_256_GCM_SHA384 = 49251,
                TLS_ECDH_RSA_WITH_CAMELLIA_128_CBC_SHA256 = 49272,
                TLS_ECDH_RSA_WITH_CAMELLIA_128_GCM_SHA256 = 49292,
                TLS_ECDH_RSA_WITH_CAMELLIA_256_CBC_SHA384 = 49273,
                TLS_ECDH_RSA_WITH_CAMELLIA_256_GCM_SHA384 = 49293,
                TLS_ECDH_RSA_WITH_NULL_SHA = 49163,
                TLS_ECDH_RSA_WITH_RC4_128_SHA = 49164,
                TLS_ECDH_anon_WITH_3DES_EDE_CBC_SHA = 49175,
                TLS_ECDH_anon_WITH_AES_128_CBC_SHA = 49176,
                TLS_ECDH_anon_WITH_AES_256_CBC_SHA = 49177,
                TLS_ECDH_anon_WITH_NULL_SHA = 49173,
                TLS_ECDH_anon_WITH_RC4_128_SHA = 49174,
                TLS_KRB5_EXPORT_WITH_DES_CBC_40_MD5 = 41,
                TLS_KRB5_EXPORT_WITH_DES_CBC_40_SHA = 38,
                TLS_KRB5_EXPORT_WITH_RC2_CBC_40_MD5 = 42,
                TLS_KRB5_EXPORT_WITH_RC2_CBC_40_SHA = 39,
                TLS_KRB5_EXPORT_WITH_RC4_40_MD5 = 43,
                TLS_KRB5_EXPORT_WITH_RC4_40_SHA = 40,
                TLS_KRB5_WITH_3DES_EDE_CBC_MD5 = 35,
                TLS_KRB5_WITH_3DES_EDE_CBC_SHA = 31,
                TLS_KRB5_WITH_DES_CBC_MD5 = 34,
                TLS_KRB5_WITH_DES_CBC_SHA = 30,
                TLS_KRB5_WITH_IDEA_CBC_MD5 = 37,
                TLS_KRB5_WITH_IDEA_CBC_SHA = 33,
                TLS_KRB5_WITH_RC4_128_MD5 = 36,
                TLS_KRB5_WITH_RC4_128_SHA = 32,
                TLS_NULL_WITH_NULL_NULL = 0,
                TLS_PSK_DHE_WITH_AES_128_CCM_8 = 49322,
                TLS_PSK_DHE_WITH_AES_256_CCM_8 = 49323,
                TLS_PSK_WITH_3DES_EDE_CBC_SHA = 139,
                TLS_PSK_WITH_AES_128_CBC_SHA = 140,
                TLS_PSK_WITH_AES_128_CBC_SHA256 = 174,
                TLS_PSK_WITH_AES_128_CCM = 49316,
                TLS_PSK_WITH_AES_128_CCM_8 = 49320,
                TLS_PSK_WITH_AES_128_GCM_SHA256 = 168,
                TLS_PSK_WITH_AES_256_CBC_SHA = 141,
                TLS_PSK_WITH_AES_256_CBC_SHA384 = 175,
                TLS_PSK_WITH_AES_256_CCM = 49317,
                TLS_PSK_WITH_AES_256_CCM_8 = 49321,
                TLS_PSK_WITH_AES_256_GCM_SHA384 = 169,
                TLS_PSK_WITH_ARIA_128_CBC_SHA256 = 49252,
                TLS_PSK_WITH_ARIA_128_GCM_SHA256 = 49258,
                TLS_PSK_WITH_ARIA_256_CBC_SHA384 = 49253,
                TLS_PSK_WITH_ARIA_256_GCM_SHA384 = 49259,
                TLS_PSK_WITH_CAMELLIA_128_CBC_SHA256 = 49300,
                TLS_PSK_WITH_CAMELLIA_128_GCM_SHA256 = 49294,
                TLS_PSK_WITH_CAMELLIA_256_CBC_SHA384 = 49301,
                TLS_PSK_WITH_CAMELLIA_256_GCM_SHA384 = 49295,
                TLS_PSK_WITH_CHACHA20_POLY1305_SHA256 = 52395,
                TLS_PSK_WITH_NULL_SHA = 44,
                TLS_PSK_WITH_NULL_SHA256 = 176,
                TLS_PSK_WITH_NULL_SHA384 = 177,
                TLS_PSK_WITH_RC4_128_SHA = 138,
                TLS_RSA_EXPORT_WITH_DES40_CBC_SHA = 8,
                TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5 = 6,
                TLS_RSA_EXPORT_WITH_RC4_40_MD5 = 3,
                TLS_RSA_PSK_WITH_3DES_EDE_CBC_SHA = 147,
                TLS_RSA_PSK_WITH_AES_128_CBC_SHA = 148,
                TLS_RSA_PSK_WITH_AES_128_CBC_SHA256 = 182,
                TLS_RSA_PSK_WITH_AES_128_GCM_SHA256 = 172,
                TLS_RSA_PSK_WITH_AES_256_CBC_SHA = 149,
                TLS_RSA_PSK_WITH_AES_256_CBC_SHA384 = 183,
                TLS_RSA_PSK_WITH_AES_256_GCM_SHA384 = 173,
                TLS_RSA_PSK_WITH_ARIA_128_CBC_SHA256 = 49256,
                TLS_RSA_PSK_WITH_ARIA_128_GCM_SHA256 = 49262,
                TLS_RSA_PSK_WITH_ARIA_256_CBC_SHA384 = 49257,
                TLS_RSA_PSK_WITH_ARIA_256_GCM_SHA384 = 49263,
                TLS_RSA_PSK_WITH_CAMELLIA_128_CBC_SHA256 = 49304,
                TLS_RSA_PSK_WITH_CAMELLIA_128_GCM_SHA256 = 49298,
                TLS_RSA_PSK_WITH_CAMELLIA_256_CBC_SHA384 = 49305,
                TLS_RSA_PSK_WITH_CAMELLIA_256_GCM_SHA384 = 49299,
                TLS_RSA_PSK_WITH_CHACHA20_POLY1305_SHA256 = 52398,
                TLS_RSA_PSK_WITH_NULL_SHA = 46,
                TLS_RSA_PSK_WITH_NULL_SHA256 = 184,
                TLS_RSA_PSK_WITH_NULL_SHA384 = 185,
                TLS_RSA_PSK_WITH_RC4_128_SHA = 146,
                TLS_RSA_WITH_3DES_EDE_CBC_SHA = 10,
                TLS_RSA_WITH_AES_128_CBC_SHA = 47,
                TLS_RSA_WITH_AES_128_CBC_SHA256 = 60,
                TLS_RSA_WITH_AES_128_CCM = 49308,
                TLS_RSA_WITH_AES_128_CCM_8 = 49312,
                TLS_RSA_WITH_AES_128_GCM_SHA256 = 156,
                TLS_RSA_WITH_AES_256_CBC_SHA = 53,
                TLS_RSA_WITH_AES_256_CBC_SHA256 = 61,
                TLS_RSA_WITH_AES_256_CCM = 49309,
                TLS_RSA_WITH_AES_256_CCM_8 = 49313,
                TLS_RSA_WITH_AES_256_GCM_SHA384 = 157,
                TLS_RSA_WITH_ARIA_128_CBC_SHA256 = 49212,
                TLS_RSA_WITH_ARIA_128_GCM_SHA256 = 49232,
                TLS_RSA_WITH_ARIA_256_CBC_SHA384 = 49213,
                TLS_RSA_WITH_ARIA_256_GCM_SHA384 = 49233,
                TLS_RSA_WITH_CAMELLIA_128_CBC_SHA = 65,
                TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256 = 186,
                TLS_RSA_WITH_CAMELLIA_128_GCM_SHA256 = 49274,
                TLS_RSA_WITH_CAMELLIA_256_CBC_SHA = 132,
                TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256 = 192,
                TLS_RSA_WITH_CAMELLIA_256_GCM_SHA384 = 49275,
                TLS_RSA_WITH_DES_CBC_SHA = 9,
                TLS_RSA_WITH_IDEA_CBC_SHA = 7,
                TLS_RSA_WITH_NULL_MD5 = 1,
                TLS_RSA_WITH_NULL_SHA = 2,
                TLS_RSA_WITH_NULL_SHA256 = 59,
                TLS_RSA_WITH_RC4_128_MD5 = 4,
                TLS_RSA_WITH_RC4_128_SHA = 5,
                TLS_RSA_WITH_SEED_CBC_SHA = 150,
                TLS_SRP_SHA_DSS_WITH_3DES_EDE_CBC_SHA = 49180,
                TLS_SRP_SHA_DSS_WITH_AES_128_CBC_SHA = 49183,
                TLS_SRP_SHA_DSS_WITH_AES_256_CBC_SHA = 49186,
                TLS_SRP_SHA_RSA_WITH_3DES_EDE_CBC_SHA = 49179,
                TLS_SRP_SHA_RSA_WITH_AES_128_CBC_SHA = 49182,
                TLS_SRP_SHA_RSA_WITH_AES_256_CBC_SHA = 49185,
                TLS_SRP_SHA_WITH_3DES_EDE_CBC_SHA = 49178,
                TLS_SRP_SHA_WITH_AES_128_CBC_SHA = 49181,
                TLS_SRP_SHA_WITH_AES_256_CBC_SHA = 49184,
            }

        }
    }
    namespace Security
    {
        namespace Authentication
        {
            // Generated from `System.Security.Authentication.AuthenticationException` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AuthenticationException : System.SystemException
            {
                public AuthenticationException() => throw null;
                protected AuthenticationException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public AuthenticationException(string message) => throw null;
                public AuthenticationException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Security.Authentication.InvalidCredentialException` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InvalidCredentialException : System.Security.Authentication.AuthenticationException
            {
                public InvalidCredentialException() => throw null;
                protected InvalidCredentialException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public InvalidCredentialException(string message) => throw null;
                public InvalidCredentialException(string message, System.Exception innerException) => throw null;
            }

            namespace ExtendedProtection
            {
                // Generated from `System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ExtendedProtectionPolicy : System.Runtime.Serialization.ISerializable
                {
                    public System.Security.Authentication.ExtendedProtection.ChannelBinding CustomChannelBinding { get => throw null; }
                    public System.Security.Authentication.ExtendedProtection.ServiceNameCollection CustomServiceNames { get => throw null; }
                    public ExtendedProtectionPolicy(System.Security.Authentication.ExtendedProtection.PolicyEnforcement policyEnforcement) => throw null;
                    public ExtendedProtectionPolicy(System.Security.Authentication.ExtendedProtection.PolicyEnforcement policyEnforcement, System.Security.Authentication.ExtendedProtection.ChannelBinding customChannelBinding) => throw null;
                    public ExtendedProtectionPolicy(System.Security.Authentication.ExtendedProtection.PolicyEnforcement policyEnforcement, System.Security.Authentication.ExtendedProtection.ProtectionScenario protectionScenario, System.Collections.ICollection customServiceNames) => throw null;
                    public ExtendedProtectionPolicy(System.Security.Authentication.ExtendedProtection.PolicyEnforcement policyEnforcement, System.Security.Authentication.ExtendedProtection.ProtectionScenario protectionScenario, System.Security.Authentication.ExtendedProtection.ServiceNameCollection customServiceNames) => throw null;
                    protected ExtendedProtectionPolicy(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public static bool OSSupportsExtendedProtection { get => throw null; }
                    public System.Security.Authentication.ExtendedProtection.PolicyEnforcement PolicyEnforcement { get => throw null; }
                    public System.Security.Authentication.ExtendedProtection.ProtectionScenario ProtectionScenario { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `System.Security.Authentication.ExtendedProtection.PolicyEnforcement` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum PolicyEnforcement : int
                {
                    Always = 2,
                    Never = 0,
                    WhenSupported = 1,
                }

                // Generated from `System.Security.Authentication.ExtendedProtection.ProtectionScenario` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum ProtectionScenario : int
                {
                    TransportSelected = 0,
                    TrustedProxy = 1,
                }

                // Generated from `System.Security.Authentication.ExtendedProtection.ServiceNameCollection` in `System.Net.Security, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ServiceNameCollection : System.Collections.ReadOnlyCollectionBase
                {
                    public bool Contains(string searchServiceName) => throw null;
                    public System.Security.Authentication.ExtendedProtection.ServiceNameCollection Merge(System.Collections.IEnumerable serviceNames) => throw null;
                    public System.Security.Authentication.ExtendedProtection.ServiceNameCollection Merge(string serviceName) => throw null;
                    public ServiceNameCollection(System.Collections.ICollection items) => throw null;
                }

            }
        }
    }
}
