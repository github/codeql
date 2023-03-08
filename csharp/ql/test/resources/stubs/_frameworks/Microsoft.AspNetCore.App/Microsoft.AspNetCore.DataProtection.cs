// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.DataProtection, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace DataProtection
        {
            public static class DataProtectionBuilderExtensions
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyEscrowSink(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.Func<System.IServiceProvider, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink> factory) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyEscrowSink(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink sink) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyEscrowSink<TImplementation>(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) where TImplementation : class, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyManagementOptions(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.Action<Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions> setupAction) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder DisableAutomaticKeyGeneration(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder PersistKeysToFileSystem(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.IO.DirectoryInfo directory) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder PersistKeysToRegistry(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.Win32.RegistryKey registryKey) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithCertificate(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithCertificate(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, string thumbprint) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapi(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapi(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, bool protectToLocalMachine) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapiNG(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapiNG(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, string protectionDescriptorRule, Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGProtectionDescriptorFlags flags) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder SetApplicationName(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, string applicationName) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder SetDefaultKeyLifetime(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.TimeSpan lifetime) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UnprotectKeysWithAnyCertificate(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, params System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCustomCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCustomCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCustomCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseEphemeralDataProtectionProvider(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
            }

            public class DataProtectionOptions
            {
                public string ApplicationDiscriminator { get => throw null; set => throw null; }
                public DataProtectionOptions() => throw null;
            }

            public static class DataProtectionUtilityExtensions
            {
                public static string GetApplicationUniqueIdentifier(this System.IServiceProvider services) => throw null;
            }

            public class EphemeralDataProtectionProvider : Microsoft.AspNetCore.DataProtection.IDataProtectionProvider
            {
                public Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(string purpose) => throw null;
                public EphemeralDataProtectionProvider() => throw null;
                public EphemeralDataProtectionProvider(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
            }

            public interface IDataProtectionBuilder
            {
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }

            public interface IPersistedDataProtector : Microsoft.AspNetCore.DataProtection.IDataProtectionProvider, Microsoft.AspNetCore.DataProtection.IDataProtector
            {
                System.Byte[] DangerousUnprotect(System.Byte[] protectedData, bool ignoreRevocationErrors, out bool requiresMigration, out bool wasRevoked);
            }

            public interface ISecret : System.IDisposable
            {
                int Length { get; }
                void WriteSecretIntoBuffer(System.ArraySegment<System.Byte> buffer);
            }

            public class Secret : Microsoft.AspNetCore.DataProtection.ISecret, System.IDisposable
            {
                public void Dispose() => throw null;
                public int Length { get => throw null; }
                public static Microsoft.AspNetCore.DataProtection.Secret Random(int numBytes) => throw null;
                public Secret(System.ArraySegment<System.Byte> value) => throw null;
                public Secret(System.Byte[] value) => throw null;
                public Secret(Microsoft.AspNetCore.DataProtection.ISecret secret) => throw null;
                unsafe public Secret(System.Byte* secret, int secretLength) => throw null;
                public void WriteSecretIntoBuffer(System.ArraySegment<System.Byte> buffer) => throw null;
                unsafe public void WriteSecretIntoBuffer(System.Byte* buffer, int bufferLength) => throw null;
            }

            namespace AuthenticatedEncryption
            {
                public class AuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public AuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                }

                public class CngCbcAuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public CngCbcAuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                }

                public class CngGcmAuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public CngGcmAuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                }

                public enum EncryptionAlgorithm : int
                {
                    AES_128_CBC = 0,
                    AES_128_GCM = 3,
                    AES_192_CBC = 1,
                    AES_192_GCM = 4,
                    AES_256_CBC = 2,
                    AES_256_GCM = 5,
                }

                public interface IAuthenticatedEncryptor
                {
                    System.Byte[] Decrypt(System.ArraySegment<System.Byte> ciphertext, System.ArraySegment<System.Byte> additionalAuthenticatedData);
                    System.Byte[] Encrypt(System.ArraySegment<System.Byte> plaintext, System.ArraySegment<System.Byte> additionalAuthenticatedData);
                }

                public interface IAuthenticatedEncryptorFactory
                {
                    Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key);
                }

                public class ManagedAuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                    public ManagedAuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                }

                public enum ValidationAlgorithm : int
                {
                    HMACSHA256 = 0,
                    HMACSHA512 = 1,
                }

                namespace ConfigurationModel
                {
                    public abstract class AlgorithmConfiguration
                    {
                        protected AlgorithmConfiguration() => throw null;
                        public abstract Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor();
                    }

                    public class AuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public AuthenticatedEncryptorConfiguration() => throw null;
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.EncryptionAlgorithm EncryptionAlgorithm { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ValidationAlgorithm ValidationAlgorithm { get => throw null; set => throw null; }
                    }

                    public class AuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public AuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                    }

                    public class AuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public AuthenticatedEncryptorDescriptorDeserializer() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                    }

                    public class CngCbcAuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public CngCbcAuthenticatedEncryptorConfiguration() => throw null;
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public string EncryptionAlgorithm { get => throw null; set => throw null; }
                        public int EncryptionAlgorithmKeySize { get => throw null; set => throw null; }
                        public string EncryptionAlgorithmProvider { get => throw null; set => throw null; }
                        public string HashAlgorithm { get => throw null; set => throw null; }
                        public string HashAlgorithmProvider { get => throw null; set => throw null; }
                    }

                    public class CngCbcAuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public CngCbcAuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                    }

                    public class CngCbcAuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public CngCbcAuthenticatedEncryptorDescriptorDeserializer() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                    }

                    public class CngGcmAuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public CngGcmAuthenticatedEncryptorConfiguration() => throw null;
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public string EncryptionAlgorithm { get => throw null; set => throw null; }
                        public int EncryptionAlgorithmKeySize { get => throw null; set => throw null; }
                        public string EncryptionAlgorithmProvider { get => throw null; set => throw null; }
                    }

                    public class CngGcmAuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public CngGcmAuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                    }

                    public class CngGcmAuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public CngGcmAuthenticatedEncryptorDescriptorDeserializer() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                    }

                    public interface IAuthenticatedEncryptorDescriptor
                    {
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml();
                    }

                    public interface IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element);
                    }

                    internal interface IInternalAlgorithmConfiguration
                    {
                    }

                    public class ManagedAuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public int EncryptionAlgorithmKeySize { get => throw null; set => throw null; }
                        public System.Type EncryptionAlgorithmType { get => throw null; set => throw null; }
                        public ManagedAuthenticatedEncryptorConfiguration() => throw null;
                        public System.Type ValidationAlgorithmType { get => throw null; set => throw null; }
                    }

                    public class ManagedAuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                        public ManagedAuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                    }

                    public class ManagedAuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                        public ManagedAuthenticatedEncryptorDescriptorDeserializer() => throw null;
                    }

                    public static class XmlExtensions
                    {
                        public static void MarkAsRequiresEncryption(this System.Xml.Linq.XElement element) => throw null;
                    }

                    public class XmlSerializedDescriptorInfo
                    {
                        public System.Type DeserializerType { get => throw null; }
                        public System.Xml.Linq.XElement SerializedDescriptorElement { get => throw null; }
                        public XmlSerializedDescriptorInfo(System.Xml.Linq.XElement serializedDescriptorElement, System.Type deserializerType) => throw null;
                    }

                }
            }
            namespace Internal
            {
                public interface IActivator
                {
                    object CreateInstance(System.Type expectedBaseType, string implementationTypeName);
                }

            }
            namespace KeyManagement
            {
                public interface IKey
                {
                    System.DateTimeOffset ActivationDate { get; }
                    Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptor();
                    System.DateTimeOffset CreationDate { get; }
                    Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor Descriptor { get; }
                    System.DateTimeOffset ExpirationDate { get; }
                    bool IsRevoked { get; }
                    System.Guid KeyId { get; }
                }

                public interface IKeyEscrowSink
                {
                    void Store(System.Guid keyId, System.Xml.Linq.XElement element);
                }

                public interface IKeyManager
                {
                    Microsoft.AspNetCore.DataProtection.KeyManagement.IKey CreateNewKey(System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate);
                    System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.DataProtection.KeyManagement.IKey> GetAllKeys();
                    System.Threading.CancellationToken GetCacheExpirationToken();
                    void RevokeAllKeys(System.DateTimeOffset revocationDate, string reason = default(string));
                    void RevokeKey(System.Guid keyId, string reason = default(string));
                }

                public class KeyManagementOptions
                {
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration AuthenticatedEncryptorConfiguration { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory> AuthenticatedEncryptorFactories { get => throw null; }
                    public bool AutoGenerateKeys { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink> KeyEscrowSinks { get => throw null; }
                    public KeyManagementOptions() => throw null;
                    public System.TimeSpan NewKeyLifetime { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor XmlEncryptor { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.DataProtection.Repositories.IXmlRepository XmlRepository { get => throw null; set => throw null; }
                }

                public class XmlKeyManager : Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyManager, Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager
                {
                    public Microsoft.AspNetCore.DataProtection.KeyManagement.IKey CreateNewKey(System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate) => throw null;
                    Microsoft.AspNetCore.DataProtection.KeyManagement.IKey Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager.CreateNewKey(System.Guid keyId, System.DateTimeOffset creationDate, System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate) => throw null;
                    Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager.DeserializeDescriptorFromKeyElement(System.Xml.Linq.XElement keyElement) => throw null;
                    public System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.DataProtection.KeyManagement.IKey> GetAllKeys() => throw null;
                    public System.Threading.CancellationToken GetCacheExpirationToken() => throw null;
                    public void RevokeAllKeys(System.DateTimeOffset revocationDate, string reason = default(string)) => throw null;
                    public void RevokeKey(System.Guid keyId, string reason = default(string)) => throw null;
                    void Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager.RevokeSingleKey(System.Guid keyId, System.DateTimeOffset revocationDate, string reason) => throw null;
                    public XmlKeyManager(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions> keyManagementOptions, Microsoft.AspNetCore.DataProtection.Internal.IActivator activator) => throw null;
                    public XmlKeyManager(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions> keyManagementOptions, Microsoft.AspNetCore.DataProtection.Internal.IActivator activator, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                }

                namespace Internal
                {
                    public class CacheableKeyRing
                    {
                    }

                    public struct DefaultKeyResolution
                    {
                        public Microsoft.AspNetCore.DataProtection.KeyManagement.IKey DefaultKey;
                        // Stub generator skipped constructor 
                        public Microsoft.AspNetCore.DataProtection.KeyManagement.IKey FallbackKey;
                        public bool ShouldGenerateNewKey;
                    }

                    public interface ICacheableKeyRingProvider
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.CacheableKeyRing GetCacheableKeyRing(System.DateTimeOffset now);
                    }

                    public interface IDefaultKeyResolver
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.DefaultKeyResolution ResolveDefaultKeyPolicy(System.DateTimeOffset now, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.DataProtection.KeyManagement.IKey> allKeys);
                    }

                    public interface IInternalXmlKeyManager
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.IKey CreateNewKey(System.Guid keyId, System.DateTimeOffset creationDate, System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate);
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor DeserializeDescriptorFromKeyElement(System.Xml.Linq.XElement keyElement);
                        void RevokeSingleKey(System.Guid keyId, System.DateTimeOffset revocationDate, string reason);
                    }

                    public interface IKeyRing
                    {
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor DefaultAuthenticatedEncryptor { get; }
                        System.Guid DefaultKeyId { get; }
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor GetAuthenticatedEncryptorByKeyId(System.Guid keyId, out bool isRevoked);
                    }

                    public interface IKeyRingProvider
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IKeyRing GetCurrentKeyRing();
                    }

                }
            }
            namespace Repositories
            {
                public class FileSystemXmlRepository : Microsoft.AspNetCore.DataProtection.Repositories.IXmlRepository
                {
                    public static System.IO.DirectoryInfo DefaultKeyStorageDirectory { get => throw null; }
                    public System.IO.DirectoryInfo Directory { get => throw null; }
                    public FileSystemXmlRepository(System.IO.DirectoryInfo directory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public virtual System.Collections.Generic.IReadOnlyCollection<System.Xml.Linq.XElement> GetAllElements() => throw null;
                    public virtual void StoreElement(System.Xml.Linq.XElement element, string friendlyName) => throw null;
                }

                public interface IXmlRepository
                {
                    System.Collections.Generic.IReadOnlyCollection<System.Xml.Linq.XElement> GetAllElements();
                    void StoreElement(System.Xml.Linq.XElement element, string friendlyName);
                }

                public class RegistryXmlRepository : Microsoft.AspNetCore.DataProtection.Repositories.IXmlRepository
                {
                    public static Microsoft.Win32.RegistryKey DefaultRegistryKey { get => throw null; }
                    public virtual System.Collections.Generic.IReadOnlyCollection<System.Xml.Linq.XElement> GetAllElements() => throw null;
                    public Microsoft.Win32.RegistryKey RegistryKey { get => throw null; }
                    public RegistryXmlRepository(Microsoft.Win32.RegistryKey registryKey, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public virtual void StoreElement(System.Xml.Linq.XElement element, string friendlyName) => throw null;
                }

            }
            namespace XmlEncryption
            {
                public class CertificateResolver : Microsoft.AspNetCore.DataProtection.XmlEncryption.ICertificateResolver
                {
                    public CertificateResolver() => throw null;
                    public virtual System.Security.Cryptography.X509Certificates.X509Certificate2 ResolveCertificate(string thumbprint) => throw null;
                }

                public class CertificateXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public CertificateXmlEncryptor(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public CertificateXmlEncryptor(string thumbprint, Microsoft.AspNetCore.DataProtection.XmlEncryption.ICertificateResolver certificateResolver, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                }

                [System.Flags]
                public enum DpapiNGProtectionDescriptorFlags : int
                {
                    MachineKey = 32,
                    NamedDescriptor = 1,
                    None = 0,
                }

                public class DpapiNGXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public DpapiNGXmlDecryptor() => throw null;
                    public DpapiNGXmlDecryptor(System.IServiceProvider services) => throw null;
                }

                public class DpapiNGXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public DpapiNGXmlEncryptor(string protectionDescriptorRule, Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGProtectionDescriptorFlags flags, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                }

                public class DpapiXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public DpapiXmlDecryptor() => throw null;
                    public DpapiXmlDecryptor(System.IServiceProvider services) => throw null;
                }

                public class DpapiXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public DpapiXmlEncryptor(bool protectToLocalMachine, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                }

                public class EncryptedXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public EncryptedXmlDecryptor() => throw null;
                    public EncryptedXmlDecryptor(System.IServiceProvider services) => throw null;
                }

                public class EncryptedXmlInfo
                {
                    public System.Type DecryptorType { get => throw null; }
                    public System.Xml.Linq.XElement EncryptedElement { get => throw null; }
                    public EncryptedXmlInfo(System.Xml.Linq.XElement encryptedElement, System.Type decryptorType) => throw null;
                }

                public interface ICertificateResolver
                {
                    System.Security.Cryptography.X509Certificates.X509Certificate2 ResolveCertificate(string thumbprint);
                }

                internal interface IInternalCertificateXmlEncryptor
                {
                }

                internal interface IInternalEncryptedXmlDecryptor
                {
                }

                public interface IXmlDecryptor
                {
                    System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement);
                }

                public interface IXmlEncryptor
                {
                    Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement);
                }

                public class NullXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public NullXmlDecryptor() => throw null;
                }

                public class NullXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                    public NullXmlEncryptor() => throw null;
                    public NullXmlEncryptor(System.IServiceProvider services) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class DataProtectionServiceCollectionExtensions
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddDataProtection(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddDataProtection(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.DataProtection.DataProtectionOptions> setupAction) => throw null;
            }

        }
    }
}
