// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace Security
        {
            // Generated from `System.Net.Security.AuthenticatedStream` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Net.Security.CipherSuitesPolicy` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CipherSuitesPolicy
            {
                public System.Collections.Generic.IEnumerable<System.Net.Security.TlsCipherSuite> AllowedCipherSuites { get => throw null; }
                public CipherSuitesPolicy(System.Collections.Generic.IEnumerable<System.Net.Security.TlsCipherSuite> allowedCipherSuites) => throw null;
            }

            // Generated from `System.Net.Security.EncryptionPolicy` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum EncryptionPolicy
            {
                AllowNoEncryption,
                NoEncryption,
                RequireEncryption,
            }

            // Generated from `System.Net.Security.LocalCertificateSelectionCallback` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Security.Cryptography.X509Certificates.X509Certificate LocalCertificateSelectionCallback(object sender, string targetHost, System.Security.Cryptography.X509Certificates.X509CertificateCollection localCertificates, System.Security.Cryptography.X509Certificates.X509Certificate remoteCertificate, string[] acceptableIssuers);

            // Generated from `System.Net.Security.NegotiateStream` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Net.Security.ProtectionLevel` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ProtectionLevel
            {
                EncryptAndSign,
                None,
                Sign,
            }

            // Generated from `System.Net.Security.RemoteCertificateValidationCallback` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate bool RemoteCertificateValidationCallback(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certificate, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors);

            // Generated from `System.Net.Security.ServerCertificateSelectionCallback` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Security.Cryptography.X509Certificates.X509Certificate ServerCertificateSelectionCallback(object sender, string hostName);

            // Generated from `System.Net.Security.ServerOptionsSelectionCallback` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate System.Threading.Tasks.ValueTask<System.Net.Security.SslServerAuthenticationOptions> ServerOptionsSelectionCallback(System.Net.Security.SslStream stream, System.Net.Security.SslClientHelloInfo clientHelloInfo, object state, System.Threading.CancellationToken cancellationToken);

            // Generated from `System.Net.Security.SslApplicationProtocol` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SslApplicationProtocol : System.IEquatable<System.Net.Security.SslApplicationProtocol>
            {
                public static bool operator !=(System.Net.Security.SslApplicationProtocol left, System.Net.Security.SslApplicationProtocol right) => throw null;
                public static bool operator ==(System.Net.Security.SslApplicationProtocol left, System.Net.Security.SslApplicationProtocol right) => throw null;
                public bool Equals(System.Net.Security.SslApplicationProtocol other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Net.Security.SslApplicationProtocol Http11;
                public static System.Net.Security.SslApplicationProtocol Http2;
                public System.ReadOnlyMemory<System.Byte> Protocol { get => throw null; }
                // Stub generator skipped constructor 
                public SslApplicationProtocol(System.Byte[] protocol) => throw null;
                public SslApplicationProtocol(string protocol) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Net.Security.SslClientAuthenticationOptions` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Net.Security.SslClientHelloInfo` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SslClientHelloInfo
            {
                public string ServerName { get => throw null; }
                // Stub generator skipped constructor 
                public System.Security.Authentication.SslProtocols SslProtocols { get => throw null; }
            }

            // Generated from `System.Net.Security.SslServerAuthenticationOptions` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Net.Security.SslStream` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Net.Security.SslStreamCertificateContext` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SslStreamCertificateContext
            {
                public static System.Net.Security.SslStreamCertificateContext Create(System.Security.Cryptography.X509Certificates.X509Certificate2 target, System.Security.Cryptography.X509Certificates.X509Certificate2Collection additionalCertificates, bool offline = default(bool)) => throw null;
            }

            // Generated from `System.Net.Security.TlsCipherSuite` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum TlsCipherSuite
            {
                TLS_AES_128_CCM_8_SHA256,
                TLS_AES_128_CCM_SHA256,
                TLS_AES_128_GCM_SHA256,
                TLS_AES_256_GCM_SHA384,
                TLS_CHACHA20_POLY1305_SHA256,
                TLS_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA,
                TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA,
                TLS_DHE_DSS_WITH_AES_128_CBC_SHA,
                TLS_DHE_DSS_WITH_AES_128_CBC_SHA256,
                TLS_DHE_DSS_WITH_AES_128_GCM_SHA256,
                TLS_DHE_DSS_WITH_AES_256_CBC_SHA,
                TLS_DHE_DSS_WITH_AES_256_CBC_SHA256,
                TLS_DHE_DSS_WITH_AES_256_GCM_SHA384,
                TLS_DHE_DSS_WITH_ARIA_128_CBC_SHA256,
                TLS_DHE_DSS_WITH_ARIA_128_GCM_SHA256,
                TLS_DHE_DSS_WITH_ARIA_256_CBC_SHA384,
                TLS_DHE_DSS_WITH_ARIA_256_GCM_SHA384,
                TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA,
                TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_DHE_DSS_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA,
                TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA256,
                TLS_DHE_DSS_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_DHE_DSS_WITH_DES_CBC_SHA,
                TLS_DHE_DSS_WITH_SEED_CBC_SHA,
                TLS_DHE_PSK_WITH_3DES_EDE_CBC_SHA,
                TLS_DHE_PSK_WITH_AES_128_CBC_SHA,
                TLS_DHE_PSK_WITH_AES_128_CBC_SHA256,
                TLS_DHE_PSK_WITH_AES_128_CCM,
                TLS_DHE_PSK_WITH_AES_128_GCM_SHA256,
                TLS_DHE_PSK_WITH_AES_256_CBC_SHA,
                TLS_DHE_PSK_WITH_AES_256_CBC_SHA384,
                TLS_DHE_PSK_WITH_AES_256_CCM,
                TLS_DHE_PSK_WITH_AES_256_GCM_SHA384,
                TLS_DHE_PSK_WITH_ARIA_128_CBC_SHA256,
                TLS_DHE_PSK_WITH_ARIA_128_GCM_SHA256,
                TLS_DHE_PSK_WITH_ARIA_256_CBC_SHA384,
                TLS_DHE_PSK_WITH_ARIA_256_GCM_SHA384,
                TLS_DHE_PSK_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_DHE_PSK_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_DHE_PSK_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_DHE_PSK_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_DHE_PSK_WITH_CHACHA20_POLY1305_SHA256,
                TLS_DHE_PSK_WITH_NULL_SHA,
                TLS_DHE_PSK_WITH_NULL_SHA256,
                TLS_DHE_PSK_WITH_NULL_SHA384,
                TLS_DHE_PSK_WITH_RC4_128_SHA,
                TLS_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA,
                TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA,
                TLS_DHE_RSA_WITH_AES_128_CBC_SHA,
                TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,
                TLS_DHE_RSA_WITH_AES_128_CCM,
                TLS_DHE_RSA_WITH_AES_128_CCM_8,
                TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,
                TLS_DHE_RSA_WITH_AES_256_CBC_SHA,
                TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,
                TLS_DHE_RSA_WITH_AES_256_CCM,
                TLS_DHE_RSA_WITH_AES_256_CCM_8,
                TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,
                TLS_DHE_RSA_WITH_ARIA_128_CBC_SHA256,
                TLS_DHE_RSA_WITH_ARIA_128_GCM_SHA256,
                TLS_DHE_RSA_WITH_ARIA_256_CBC_SHA384,
                TLS_DHE_RSA_WITH_ARIA_256_GCM_SHA384,
                TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA,
                TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_DHE_RSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA,
                TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA256,
                TLS_DHE_RSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
                TLS_DHE_RSA_WITH_DES_CBC_SHA,
                TLS_DHE_RSA_WITH_SEED_CBC_SHA,
                TLS_DH_DSS_EXPORT_WITH_DES40_CBC_SHA,
                TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA,
                TLS_DH_DSS_WITH_AES_128_CBC_SHA,
                TLS_DH_DSS_WITH_AES_128_CBC_SHA256,
                TLS_DH_DSS_WITH_AES_128_GCM_SHA256,
                TLS_DH_DSS_WITH_AES_256_CBC_SHA,
                TLS_DH_DSS_WITH_AES_256_CBC_SHA256,
                TLS_DH_DSS_WITH_AES_256_GCM_SHA384,
                TLS_DH_DSS_WITH_ARIA_128_CBC_SHA256,
                TLS_DH_DSS_WITH_ARIA_128_GCM_SHA256,
                TLS_DH_DSS_WITH_ARIA_256_CBC_SHA384,
                TLS_DH_DSS_WITH_ARIA_256_GCM_SHA384,
                TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA,
                TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_DH_DSS_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA,
                TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA256,
                TLS_DH_DSS_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_DH_DSS_WITH_DES_CBC_SHA,
                TLS_DH_DSS_WITH_SEED_CBC_SHA,
                TLS_DH_RSA_EXPORT_WITH_DES40_CBC_SHA,
                TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA,
                TLS_DH_RSA_WITH_AES_128_CBC_SHA,
                TLS_DH_RSA_WITH_AES_128_CBC_SHA256,
                TLS_DH_RSA_WITH_AES_128_GCM_SHA256,
                TLS_DH_RSA_WITH_AES_256_CBC_SHA,
                TLS_DH_RSA_WITH_AES_256_CBC_SHA256,
                TLS_DH_RSA_WITH_AES_256_GCM_SHA384,
                TLS_DH_RSA_WITH_ARIA_128_CBC_SHA256,
                TLS_DH_RSA_WITH_ARIA_128_GCM_SHA256,
                TLS_DH_RSA_WITH_ARIA_256_CBC_SHA384,
                TLS_DH_RSA_WITH_ARIA_256_GCM_SHA384,
                TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA,
                TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_DH_RSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA,
                TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA256,
                TLS_DH_RSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_DH_RSA_WITH_DES_CBC_SHA,
                TLS_DH_RSA_WITH_SEED_CBC_SHA,
                TLS_DH_anon_EXPORT_WITH_DES40_CBC_SHA,
                TLS_DH_anon_EXPORT_WITH_RC4_40_MD5,
                TLS_DH_anon_WITH_3DES_EDE_CBC_SHA,
                TLS_DH_anon_WITH_AES_128_CBC_SHA,
                TLS_DH_anon_WITH_AES_128_CBC_SHA256,
                TLS_DH_anon_WITH_AES_128_GCM_SHA256,
                TLS_DH_anon_WITH_AES_256_CBC_SHA,
                TLS_DH_anon_WITH_AES_256_CBC_SHA256,
                TLS_DH_anon_WITH_AES_256_GCM_SHA384,
                TLS_DH_anon_WITH_ARIA_128_CBC_SHA256,
                TLS_DH_anon_WITH_ARIA_128_GCM_SHA256,
                TLS_DH_anon_WITH_ARIA_256_CBC_SHA384,
                TLS_DH_anon_WITH_ARIA_256_GCM_SHA384,
                TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA,
                TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_DH_anon_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA,
                TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA256,
                TLS_DH_anon_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_DH_anon_WITH_DES_CBC_SHA,
                TLS_DH_anon_WITH_RC4_128_MD5,
                TLS_DH_anon_WITH_SEED_CBC_SHA,
                TLS_ECCPWD_WITH_AES_128_CCM_SHA256,
                TLS_ECCPWD_WITH_AES_128_GCM_SHA256,
                TLS_ECCPWD_WITH_AES_256_CCM_SHA384,
                TLS_ECCPWD_WITH_AES_256_GCM_SHA384,
                TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA,
                TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,
                TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,
                TLS_ECDHE_ECDSA_WITH_AES_128_CCM,
                TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8,
                TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
                TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,
                TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,
                TLS_ECDHE_ECDSA_WITH_AES_256_CCM,
                TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8,
                TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
                TLS_ECDHE_ECDSA_WITH_ARIA_128_CBC_SHA256,
                TLS_ECDHE_ECDSA_WITH_ARIA_128_GCM_SHA256,
                TLS_ECDHE_ECDSA_WITH_ARIA_256_CBC_SHA384,
                TLS_ECDHE_ECDSA_WITH_ARIA_256_GCM_SHA384,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,
                TLS_ECDHE_ECDSA_WITH_NULL_SHA,
                TLS_ECDHE_ECDSA_WITH_RC4_128_SHA,
                TLS_ECDHE_PSK_WITH_3DES_EDE_CBC_SHA,
                TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA,
                TLS_ECDHE_PSK_WITH_AES_128_CBC_SHA256,
                TLS_ECDHE_PSK_WITH_AES_128_CCM_8_SHA256,
                TLS_ECDHE_PSK_WITH_AES_128_CCM_SHA256,
                TLS_ECDHE_PSK_WITH_AES_128_GCM_SHA256,
                TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA,
                TLS_ECDHE_PSK_WITH_AES_256_CBC_SHA384,
                TLS_ECDHE_PSK_WITH_AES_256_GCM_SHA384,
                TLS_ECDHE_PSK_WITH_ARIA_128_CBC_SHA256,
                TLS_ECDHE_PSK_WITH_ARIA_256_CBC_SHA384,
                TLS_ECDHE_PSK_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_ECDHE_PSK_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_ECDHE_PSK_WITH_CHACHA20_POLY1305_SHA256,
                TLS_ECDHE_PSK_WITH_NULL_SHA,
                TLS_ECDHE_PSK_WITH_NULL_SHA256,
                TLS_ECDHE_PSK_WITH_NULL_SHA384,
                TLS_ECDHE_PSK_WITH_RC4_128_SHA,
                TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA,
                TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,
                TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
                TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
                TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,
                TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
                TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
                TLS_ECDHE_RSA_WITH_ARIA_128_CBC_SHA256,
                TLS_ECDHE_RSA_WITH_ARIA_128_GCM_SHA256,
                TLS_ECDHE_RSA_WITH_ARIA_256_CBC_SHA384,
                TLS_ECDHE_RSA_WITH_ARIA_256_GCM_SHA384,
                TLS_ECDHE_RSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_ECDHE_RSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_ECDHE_RSA_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_ECDHE_RSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
                TLS_ECDHE_RSA_WITH_NULL_SHA,
                TLS_ECDHE_RSA_WITH_RC4_128_SHA,
                TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA,
                TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA,
                TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256,
                TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256,
                TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA,
                TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384,
                TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384,
                TLS_ECDH_ECDSA_WITH_ARIA_128_CBC_SHA256,
                TLS_ECDH_ECDSA_WITH_ARIA_128_GCM_SHA256,
                TLS_ECDH_ECDSA_WITH_ARIA_256_CBC_SHA384,
                TLS_ECDH_ECDSA_WITH_ARIA_256_GCM_SHA384,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_ECDH_ECDSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_ECDH_ECDSA_WITH_NULL_SHA,
                TLS_ECDH_ECDSA_WITH_RC4_128_SHA,
                TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA,
                TLS_ECDH_RSA_WITH_AES_128_CBC_SHA,
                TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256,
                TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256,
                TLS_ECDH_RSA_WITH_AES_256_CBC_SHA,
                TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384,
                TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384,
                TLS_ECDH_RSA_WITH_ARIA_128_CBC_SHA256,
                TLS_ECDH_RSA_WITH_ARIA_128_GCM_SHA256,
                TLS_ECDH_RSA_WITH_ARIA_256_CBC_SHA384,
                TLS_ECDH_RSA_WITH_ARIA_256_GCM_SHA384,
                TLS_ECDH_RSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_ECDH_RSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_ECDH_RSA_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_ECDH_RSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_ECDH_RSA_WITH_NULL_SHA,
                TLS_ECDH_RSA_WITH_RC4_128_SHA,
                TLS_ECDH_anon_WITH_3DES_EDE_CBC_SHA,
                TLS_ECDH_anon_WITH_AES_128_CBC_SHA,
                TLS_ECDH_anon_WITH_AES_256_CBC_SHA,
                TLS_ECDH_anon_WITH_NULL_SHA,
                TLS_ECDH_anon_WITH_RC4_128_SHA,
                TLS_KRB5_EXPORT_WITH_DES_CBC_40_MD5,
                TLS_KRB5_EXPORT_WITH_DES_CBC_40_SHA,
                TLS_KRB5_EXPORT_WITH_RC2_CBC_40_MD5,
                TLS_KRB5_EXPORT_WITH_RC2_CBC_40_SHA,
                TLS_KRB5_EXPORT_WITH_RC4_40_MD5,
                TLS_KRB5_EXPORT_WITH_RC4_40_SHA,
                TLS_KRB5_WITH_3DES_EDE_CBC_MD5,
                TLS_KRB5_WITH_3DES_EDE_CBC_SHA,
                TLS_KRB5_WITH_DES_CBC_MD5,
                TLS_KRB5_WITH_DES_CBC_SHA,
                TLS_KRB5_WITH_IDEA_CBC_MD5,
                TLS_KRB5_WITH_IDEA_CBC_SHA,
                TLS_KRB5_WITH_RC4_128_MD5,
                TLS_KRB5_WITH_RC4_128_SHA,
                TLS_NULL_WITH_NULL_NULL,
                TLS_PSK_DHE_WITH_AES_128_CCM_8,
                TLS_PSK_DHE_WITH_AES_256_CCM_8,
                TLS_PSK_WITH_3DES_EDE_CBC_SHA,
                TLS_PSK_WITH_AES_128_CBC_SHA,
                TLS_PSK_WITH_AES_128_CBC_SHA256,
                TLS_PSK_WITH_AES_128_CCM,
                TLS_PSK_WITH_AES_128_CCM_8,
                TLS_PSK_WITH_AES_128_GCM_SHA256,
                TLS_PSK_WITH_AES_256_CBC_SHA,
                TLS_PSK_WITH_AES_256_CBC_SHA384,
                TLS_PSK_WITH_AES_256_CCM,
                TLS_PSK_WITH_AES_256_CCM_8,
                TLS_PSK_WITH_AES_256_GCM_SHA384,
                TLS_PSK_WITH_ARIA_128_CBC_SHA256,
                TLS_PSK_WITH_ARIA_128_GCM_SHA256,
                TLS_PSK_WITH_ARIA_256_CBC_SHA384,
                TLS_PSK_WITH_ARIA_256_GCM_SHA384,
                TLS_PSK_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_PSK_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_PSK_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_PSK_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_PSK_WITH_CHACHA20_POLY1305_SHA256,
                TLS_PSK_WITH_NULL_SHA,
                TLS_PSK_WITH_NULL_SHA256,
                TLS_PSK_WITH_NULL_SHA384,
                TLS_PSK_WITH_RC4_128_SHA,
                TLS_RSA_EXPORT_WITH_DES40_CBC_SHA,
                TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5,
                TLS_RSA_EXPORT_WITH_RC4_40_MD5,
                TLS_RSA_PSK_WITH_3DES_EDE_CBC_SHA,
                TLS_RSA_PSK_WITH_AES_128_CBC_SHA,
                TLS_RSA_PSK_WITH_AES_128_CBC_SHA256,
                TLS_RSA_PSK_WITH_AES_128_GCM_SHA256,
                TLS_RSA_PSK_WITH_AES_256_CBC_SHA,
                TLS_RSA_PSK_WITH_AES_256_CBC_SHA384,
                TLS_RSA_PSK_WITH_AES_256_GCM_SHA384,
                TLS_RSA_PSK_WITH_ARIA_128_CBC_SHA256,
                TLS_RSA_PSK_WITH_ARIA_128_GCM_SHA256,
                TLS_RSA_PSK_WITH_ARIA_256_CBC_SHA384,
                TLS_RSA_PSK_WITH_ARIA_256_GCM_SHA384,
                TLS_RSA_PSK_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_RSA_PSK_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_RSA_PSK_WITH_CAMELLIA_256_CBC_SHA384,
                TLS_RSA_PSK_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_RSA_PSK_WITH_CHACHA20_POLY1305_SHA256,
                TLS_RSA_PSK_WITH_NULL_SHA,
                TLS_RSA_PSK_WITH_NULL_SHA256,
                TLS_RSA_PSK_WITH_NULL_SHA384,
                TLS_RSA_PSK_WITH_RC4_128_SHA,
                TLS_RSA_WITH_3DES_EDE_CBC_SHA,
                TLS_RSA_WITH_AES_128_CBC_SHA,
                TLS_RSA_WITH_AES_128_CBC_SHA256,
                TLS_RSA_WITH_AES_128_CCM,
                TLS_RSA_WITH_AES_128_CCM_8,
                TLS_RSA_WITH_AES_128_GCM_SHA256,
                TLS_RSA_WITH_AES_256_CBC_SHA,
                TLS_RSA_WITH_AES_256_CBC_SHA256,
                TLS_RSA_WITH_AES_256_CCM,
                TLS_RSA_WITH_AES_256_CCM_8,
                TLS_RSA_WITH_AES_256_GCM_SHA384,
                TLS_RSA_WITH_ARIA_128_CBC_SHA256,
                TLS_RSA_WITH_ARIA_128_GCM_SHA256,
                TLS_RSA_WITH_ARIA_256_CBC_SHA384,
                TLS_RSA_WITH_ARIA_256_GCM_SHA384,
                TLS_RSA_WITH_CAMELLIA_128_CBC_SHA,
                TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256,
                TLS_RSA_WITH_CAMELLIA_128_GCM_SHA256,
                TLS_RSA_WITH_CAMELLIA_256_CBC_SHA,
                TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256,
                TLS_RSA_WITH_CAMELLIA_256_GCM_SHA384,
                TLS_RSA_WITH_DES_CBC_SHA,
                TLS_RSA_WITH_IDEA_CBC_SHA,
                TLS_RSA_WITH_NULL_MD5,
                TLS_RSA_WITH_NULL_SHA,
                TLS_RSA_WITH_NULL_SHA256,
                TLS_RSA_WITH_RC4_128_MD5,
                TLS_RSA_WITH_RC4_128_SHA,
                TLS_RSA_WITH_SEED_CBC_SHA,
                TLS_SRP_SHA_DSS_WITH_3DES_EDE_CBC_SHA,
                TLS_SRP_SHA_DSS_WITH_AES_128_CBC_SHA,
                TLS_SRP_SHA_DSS_WITH_AES_256_CBC_SHA,
                TLS_SRP_SHA_RSA_WITH_3DES_EDE_CBC_SHA,
                TLS_SRP_SHA_RSA_WITH_AES_128_CBC_SHA,
                TLS_SRP_SHA_RSA_WITH_AES_256_CBC_SHA,
                TLS_SRP_SHA_WITH_3DES_EDE_CBC_SHA,
                TLS_SRP_SHA_WITH_AES_128_CBC_SHA,
                TLS_SRP_SHA_WITH_AES_256_CBC_SHA,
            }

        }
    }
    namespace Security
    {
        namespace Authentication
        {
            // Generated from `System.Security.Authentication.AuthenticationException` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AuthenticationException : System.SystemException
            {
                public AuthenticationException() => throw null;
                protected AuthenticationException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public AuthenticationException(string message) => throw null;
                public AuthenticationException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Security.Authentication.InvalidCredentialException` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InvalidCredentialException : System.Security.Authentication.AuthenticationException
            {
                public InvalidCredentialException() => throw null;
                protected InvalidCredentialException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public InvalidCredentialException(string message) => throw null;
                public InvalidCredentialException(string message, System.Exception innerException) => throw null;
            }

            namespace ExtendedProtection
            {
                // Generated from `System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

                // Generated from `System.Security.Authentication.ExtendedProtection.PolicyEnforcement` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum PolicyEnforcement
                {
                    Always,
                    Never,
                    WhenSupported,
                }

                // Generated from `System.Security.Authentication.ExtendedProtection.ProtectionScenario` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum ProtectionScenario
                {
                    TransportSelected,
                    TrustedProxy,
                }

                // Generated from `System.Security.Authentication.ExtendedProtection.ServiceNameCollection` in `System.Net.Security, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
