// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace DataProtection
        {
            // Generated from `Microsoft.AspNetCore.DataProtection.DataProtectionBuilderExtensions` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DataProtectionBuilderExtensions
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyEscrowSink<TImplementation>(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) where TImplementation : class, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyEscrowSink(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.Func<System.IServiceProvider, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink> factory) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyEscrowSink(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink sink) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddKeyManagementOptions(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.Action<Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions> setupAction) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder DisableAutomaticKeyGeneration(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder PersistKeysToFileSystem(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.IO.DirectoryInfo directory) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder PersistKeysToRegistry(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.Win32.RegistryKey registryKey) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithCertificate(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, string thumbprint) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithCertificate(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapi(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, bool protectToLocalMachine) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapi(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapiNG(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, string protectionDescriptorRule, Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGProtectionDescriptorFlags flags) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder ProtectKeysWithDpapiNG(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder SetApplicationName(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, string applicationName) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder SetDefaultKeyLifetime(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, System.TimeSpan lifetime) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UnprotectKeysWithAnyCertificate(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, params System.Security.Cryptography.X509Certificates.X509Certificate2[] certificates) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCustomCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCustomCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseCustomCryptographicAlgorithms(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder, Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorConfiguration configuration) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder UseEphemeralDataProtectionProvider(this Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.DataProtectionOptions` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DataProtectionOptions
            {
                public string ApplicationDiscriminator { get => throw null; set => throw null; }
                public DataProtectionOptions() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.DataProtectionUtilityExtensions` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DataProtectionUtilityExtensions
            {
                public static string GetApplicationUniqueIdentifier(this System.IServiceProvider services) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.EphemeralDataProtectionProvider` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class EphemeralDataProtectionProvider : Microsoft.AspNetCore.DataProtection.IDataProtectionProvider
            {
                public Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(string purpose) => throw null;
                public EphemeralDataProtectionProvider(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public EphemeralDataProtectionProvider() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDataProtectionBuilder
            {
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.IPersistedDataProtector` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IPersistedDataProtector : Microsoft.AspNetCore.DataProtection.IDataProtector, Microsoft.AspNetCore.DataProtection.IDataProtectionProvider
            {
                System.Byte[] DangerousUnprotect(System.Byte[] protectedData, bool ignoreRevocationErrors, out bool requiresMigration, out bool wasRevoked);
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.ISecret` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISecret : System.IDisposable
            {
                int Length { get; }
                void WriteSecretIntoBuffer(System.ArraySegment<System.Byte> buffer);
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.Secret` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class Secret : System.IDisposable, Microsoft.AspNetCore.DataProtection.ISecret
            {
                public void Dispose() => throw null;
                public int Length { get => throw null; }
                public static Microsoft.AspNetCore.DataProtection.Secret Random(int numBytes) => throw null;
                unsafe public Secret(System.Byte* secret, int secretLength) => throw null;
                public Secret(System.Byte[] value) => throw null;
                public Secret(System.ArraySegment<System.Byte> value) => throw null;
                public Secret(Microsoft.AspNetCore.DataProtection.ISecret secret) => throw null;
                unsafe public void WriteSecretIntoBuffer(System.Byte* buffer, int bufferLength) => throw null;
                public void WriteSecretIntoBuffer(System.ArraySegment<System.Byte> buffer) => throw null;
            }

            namespace AuthenticatedEncryption
            {
                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.AuthenticatedEncryptorFactory` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public AuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.CngCbcAuthenticatedEncryptorFactory` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CngCbcAuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public CngCbcAuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.CngGcmAuthenticatedEncryptorFactory` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CngGcmAuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public CngGcmAuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.EncryptionAlgorithm` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum EncryptionAlgorithm
                {
                    AES_128_CBC,
                    AES_128_GCM,
                    AES_192_CBC,
                    AES_192_GCM,
                    AES_256_CBC,
                    AES_256_GCM,
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAuthenticatedEncryptor
                {
                    System.Byte[] Decrypt(System.ArraySegment<System.Byte> ciphertext, System.ArraySegment<System.Byte> additionalAuthenticatedData);
                    System.Byte[] Encrypt(System.ArraySegment<System.Byte> plaintext, System.ArraySegment<System.Byte> additionalAuthenticatedData);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAuthenticatedEncryptorFactory
                {
                    Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ManagedAuthenticatedEncryptorFactory` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ManagedAuthenticatedEncryptorFactory : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptorFactory
                {
                    public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor CreateEncryptorInstance(Microsoft.AspNetCore.DataProtection.KeyManagement.IKey key) => throw null;
                    public ManagedAuthenticatedEncryptorFactory(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ValidationAlgorithm` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum ValidationAlgorithm
                {
                    HMACSHA256,
                    HMACSHA512,
                }

                namespace ConfigurationModel
                {
                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public abstract class AlgorithmConfiguration
                    {
                        protected AlgorithmConfiguration() => throw null;
                        public abstract Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor();
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorConfiguration` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class AuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public AuthenticatedEncryptorConfiguration() => throw null;
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.EncryptionAlgorithm EncryptionAlgorithm { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ValidationAlgorithm ValidationAlgorithm { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorDescriptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class AuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public AuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AuthenticatedEncryptorDescriptorDeserializer` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class AuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public AuthenticatedEncryptorDescriptorDeserializer() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorConfiguration` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorDescriptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CngCbcAuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public CngCbcAuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngCbcAuthenticatedEncryptorDescriptorDeserializer` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CngCbcAuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public CngCbcAuthenticatedEncryptorDescriptorDeserializer() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorConfiguration` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CngGcmAuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public CngGcmAuthenticatedEncryptorConfiguration() => throw null;
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public string EncryptionAlgorithm { get => throw null; set => throw null; }
                        public int EncryptionAlgorithmKeySize { get => throw null; set => throw null; }
                        public string EncryptionAlgorithmProvider { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorDescriptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CngGcmAuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public CngGcmAuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.CngGcmAuthenticatedEncryptorDescriptorDeserializer` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CngGcmAuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public CngGcmAuthenticatedEncryptorDescriptorDeserializer() => throw null;
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IAuthenticatedEncryptorDescriptor
                    {
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml();
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element);
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IInternalAlgorithmConfiguration` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    internal interface IInternalAlgorithmConfiguration
                    {
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorConfiguration` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ManagedAuthenticatedEncryptorConfiguration : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.AlgorithmConfiguration
                    {
                        public override Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor CreateNewDescriptor() => throw null;
                        public int EncryptionAlgorithmKeySize { get => throw null; set => throw null; }
                        public System.Type EncryptionAlgorithmType { get => throw null; set => throw null; }
                        public ManagedAuthenticatedEncryptorConfiguration() => throw null;
                        public System.Type ValidationAlgorithmType { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorDescriptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ManagedAuthenticatedEncryptorDescriptor : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor
                    {
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo ExportToXml() => throw null;
                        public ManagedAuthenticatedEncryptorDescriptor(Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorConfiguration configuration, Microsoft.AspNetCore.DataProtection.ISecret masterKey) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.ManagedAuthenticatedEncryptorDescriptorDeserializer` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ManagedAuthenticatedEncryptorDescriptorDeserializer : Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptorDeserializer
                    {
                        public Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor ImportFromXml(System.Xml.Linq.XElement element) => throw null;
                        public ManagedAuthenticatedEncryptorDescriptorDeserializer() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlExtensions` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public static class XmlExtensions
                    {
                        public static void MarkAsRequiresEncryption(this System.Xml.Linq.XElement element) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.XmlSerializedDescriptorInfo` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                // Generated from `Microsoft.AspNetCore.DataProtection.Internal.IActivator` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActivator
                {
                    object CreateInstance(System.Type expectedBaseType, string implementationTypeName);
                }

            }
            namespace KeyManagement
            {
                // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.IKey` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyEscrowSink` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IKeyEscrowSink
                {
                    void Store(System.Guid keyId, System.Xml.Linq.XElement element);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyManager` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IKeyManager
                {
                    Microsoft.AspNetCore.DataProtection.KeyManagement.IKey CreateNewKey(System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate);
                    System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.DataProtection.KeyManagement.IKey> GetAllKeys();
                    System.Threading.CancellationToken GetCacheExpirationToken();
                    void RevokeAllKeys(System.DateTimeOffset revocationDate, string reason = default(string));
                    void RevokeKey(System.Guid keyId, string reason = default(string));
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class XmlKeyManager : Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager, Microsoft.AspNetCore.DataProtection.KeyManagement.IKeyManager
                {
                    public Microsoft.AspNetCore.DataProtection.KeyManagement.IKey CreateNewKey(System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate) => throw null;
                    Microsoft.AspNetCore.DataProtection.KeyManagement.IKey Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager.CreateNewKey(System.Guid keyId, System.DateTimeOffset creationDate, System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate) => throw null;
                    Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager.DeserializeDescriptorFromKeyElement(System.Xml.Linq.XElement keyElement) => throw null;
                    public System.Collections.Generic.IReadOnlyCollection<Microsoft.AspNetCore.DataProtection.KeyManagement.IKey> GetAllKeys() => throw null;
                    public System.Threading.CancellationToken GetCacheExpirationToken() => throw null;
                    public void RevokeAllKeys(System.DateTimeOffset revocationDate, string reason = default(string)) => throw null;
                    public void RevokeKey(System.Guid keyId, string reason = default(string)) => throw null;
                    void Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager.RevokeSingleKey(System.Guid keyId, System.DateTimeOffset revocationDate, string reason) => throw null;
                    public XmlKeyManager(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions> keyManagementOptions, Microsoft.AspNetCore.DataProtection.Internal.IActivator activator, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public XmlKeyManager(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.DataProtection.KeyManagement.KeyManagementOptions> keyManagementOptions, Microsoft.AspNetCore.DataProtection.Internal.IActivator activator) => throw null;
                }

                namespace Internal
                {
                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.CacheableKeyRing` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CacheableKeyRing
                    {
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.DefaultKeyResolution` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct DefaultKeyResolution
                    {
                        public Microsoft.AspNetCore.DataProtection.KeyManagement.IKey DefaultKey;
                        // Stub generator skipped constructor 
                        public Microsoft.AspNetCore.DataProtection.KeyManagement.IKey FallbackKey;
                        public bool ShouldGenerateNewKey;
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.ICacheableKeyRingProvider` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface ICacheableKeyRingProvider
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.CacheableKeyRing GetCacheableKeyRing(System.DateTimeOffset now);
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IDefaultKeyResolver` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IDefaultKeyResolver
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.DefaultKeyResolution ResolveDefaultKeyPolicy(System.DateTimeOffset now, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.DataProtection.KeyManagement.IKey> allKeys);
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IInternalXmlKeyManager` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IInternalXmlKeyManager
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.IKey CreateNewKey(System.Guid keyId, System.DateTimeOffset creationDate, System.DateTimeOffset activationDate, System.DateTimeOffset expirationDate);
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.ConfigurationModel.IAuthenticatedEncryptorDescriptor DeserializeDescriptorFromKeyElement(System.Xml.Linq.XElement keyElement);
                        void RevokeSingleKey(System.Guid keyId, System.DateTimeOffset revocationDate, string reason);
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IKeyRing` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IKeyRing
                    {
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor DefaultAuthenticatedEncryptor { get; }
                        System.Guid DefaultKeyId { get; }
                        Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption.IAuthenticatedEncryptor GetAuthenticatedEncryptorByKeyId(System.Guid keyId, out bool isRevoked);
                    }

                    // Generated from `Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IKeyRingProvider` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IKeyRingProvider
                    {
                        Microsoft.AspNetCore.DataProtection.KeyManagement.Internal.IKeyRing GetCurrentKeyRing();
                    }

                }
            }
            namespace Repositories
            {
                // Generated from `Microsoft.AspNetCore.DataProtection.Repositories.FileSystemXmlRepository` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FileSystemXmlRepository : Microsoft.AspNetCore.DataProtection.Repositories.IXmlRepository
                {
                    public static System.IO.DirectoryInfo DefaultKeyStorageDirectory { get => throw null; }
                    public System.IO.DirectoryInfo Directory { get => throw null; }
                    public FileSystemXmlRepository(System.IO.DirectoryInfo directory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public virtual System.Collections.Generic.IReadOnlyCollection<System.Xml.Linq.XElement> GetAllElements() => throw null;
                    public virtual void StoreElement(System.Xml.Linq.XElement element, string friendlyName) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.Repositories.IXmlRepository` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IXmlRepository
                {
                    System.Collections.Generic.IReadOnlyCollection<System.Xml.Linq.XElement> GetAllElements();
                    void StoreElement(System.Xml.Linq.XElement element, string friendlyName);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.Repositories.RegistryXmlRepository` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.CertificateResolver` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CertificateResolver : Microsoft.AspNetCore.DataProtection.XmlEncryption.ICertificateResolver
                {
                    public CertificateResolver() => throw null;
                    public virtual System.Security.Cryptography.X509Certificates.X509Certificate2 ResolveCertificate(string thumbprint) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.CertificateXmlEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CertificateXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public CertificateXmlEncryptor(string thumbprint, Microsoft.AspNetCore.DataProtection.XmlEncryption.ICertificateResolver certificateResolver, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public CertificateXmlEncryptor(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGProtectionDescriptorFlags` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                [System.Flags]
                public enum DpapiNGProtectionDescriptorFlags
                {
                    MachineKey,
                    NamedDescriptor,
                    None,
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGXmlDecryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DpapiNGXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public DpapiNGXmlDecryptor(System.IServiceProvider services) => throw null;
                    public DpapiNGXmlDecryptor() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGXmlEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DpapiNGXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public DpapiNGXmlEncryptor(string protectionDescriptorRule, Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiNGProtectionDescriptorFlags flags, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiXmlDecryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DpapiXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public DpapiXmlDecryptor(System.IServiceProvider services) => throw null;
                    public DpapiXmlDecryptor() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.DpapiXmlEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DpapiXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public DpapiXmlEncryptor(bool protectToLocalMachine, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlDecryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EncryptedXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public EncryptedXmlDecryptor(System.IServiceProvider services) => throw null;
                    public EncryptedXmlDecryptor() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EncryptedXmlInfo
                {
                    public System.Type DecryptorType { get => throw null; }
                    public System.Xml.Linq.XElement EncryptedElement { get => throw null; }
                    public EncryptedXmlInfo(System.Xml.Linq.XElement encryptedElement, System.Type decryptorType) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.ICertificateResolver` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICertificateResolver
                {
                    System.Security.Cryptography.X509Certificates.X509Certificate2 ResolveCertificate(string thumbprint);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.IInternalCertificateXmlEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IInternalCertificateXmlEncryptor
                {
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.IInternalEncryptedXmlDecryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IInternalEncryptedXmlDecryptor
                {
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IXmlDecryptor
                {
                    System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IXmlEncryptor
                {
                    Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement);
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.NullXmlDecryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullXmlDecryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlDecryptor
                {
                    public System.Xml.Linq.XElement Decrypt(System.Xml.Linq.XElement encryptedElement) => throw null;
                    public NullXmlDecryptor() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.DataProtection.XmlEncryption.NullXmlEncryptor` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullXmlEncryptor : Microsoft.AspNetCore.DataProtection.XmlEncryption.IXmlEncryptor
                {
                    public Microsoft.AspNetCore.DataProtection.XmlEncryption.EncryptedXmlInfo Encrypt(System.Xml.Linq.XElement plaintextElement) => throw null;
                    public NullXmlEncryptor(System.IServiceProvider services) => throw null;
                    public NullXmlEncryptor() => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.DataProtectionServiceCollectionExtensions` in `Microsoft.AspNetCore.DataProtection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DataProtectionServiceCollectionExtensions
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddDataProtection(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.DataProtection.DataProtectionOptions> setupAction) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder AddDataProtection(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
