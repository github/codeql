// This file contains auto-generated code.
// Generated from `Microsoft.Identity.Client.Extensions.Msal, Version=4.61.3.0, Culture=neutral, PublicKeyToken=0a613f4dd989e8ae`.
namespace Microsoft
{
    namespace Identity
    {
        namespace Client
        {
            namespace Extensions
            {
                namespace Msal
                {
                    public class CacheChangedEventArgs : System.EventArgs
                    {
                        public readonly System.Collections.Generic.IEnumerable<string> AccountsAdded;
                        public readonly System.Collections.Generic.IEnumerable<string> AccountsRemoved;
                        public CacheChangedEventArgs(System.Collections.Generic.IEnumerable<string> added, System.Collections.Generic.IEnumerable<string> removed) => throw null;
                    }
                    public sealed class CrossPlatLock : System.IDisposable
                    {
                        public CrossPlatLock(string lockfilePath, int lockFileRetryDelay = default(int), int lockFileRetryCount = default(int)) => throw null;
                        public void Dispose() => throw null;
                    }
                    public class MsalCacheHelper
                    {
                        public event System.EventHandler<Microsoft.Identity.Client.Extensions.Msal.CacheChangedEventArgs> CacheChanged;
                        public void Clear() => throw null;
                        public static System.Threading.Tasks.Task<Microsoft.Identity.Client.Extensions.Msal.MsalCacheHelper> CreateAsync(Microsoft.Identity.Client.Extensions.Msal.StorageCreationProperties storageCreationProperties, System.Diagnostics.TraceSource logger = default(System.Diagnostics.TraceSource)) => throw null;
                        public const string LinuxKeyRingDefaultCollection = default;
                        public const string LinuxKeyRingSessionCollection = default;
                        public byte[] LoadUnencryptedTokenCache() => throw null;
                        public void RegisterCache(Microsoft.Identity.Client.ITokenCache tokenCache) => throw null;
                        public void SaveUnencryptedTokenCache(byte[] tokenCache) => throw null;
                        public void UnregisterCache(Microsoft.Identity.Client.ITokenCache tokenCache) => throw null;
                        public static string UserRootDirectory { get => throw null; }
                        public void VerifyPersistence() => throw null;
                    }
                    public class MsalCachePersistenceException : System.Exception
                    {
                        public MsalCachePersistenceException() => throw null;
                        public MsalCachePersistenceException(string message) => throw null;
                        public MsalCachePersistenceException(string message, System.Exception innerException) => throw null;
                        protected MsalCachePersistenceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    }
                    public static class SharedUtilities
                    {
                        public static string GetUserRootDirectory() => throw null;
                        public static bool IsLinuxPlatform() => throw null;
                        public static bool IsMacPlatform() => throw null;
                        public static bool IsWindowsPlatform() => throw null;
                    }
                    public class Storage
                    {
                        public void Clear(bool ignoreExceptions = default(bool)) => throw null;
                        public static Microsoft.Identity.Client.Extensions.Msal.Storage Create(Microsoft.Identity.Client.Extensions.Msal.StorageCreationProperties creationProperties, System.Diagnostics.TraceSource logger = default(System.Diagnostics.TraceSource)) => throw null;
                        public byte[] ReadData() => throw null;
                        public void VerifyPersistence() => throw null;
                        public void WriteData(byte[] data) => throw null;
                    }
                    public class StorageCreationProperties
                    {
                        public string Authority { get => throw null; }
                        public readonly string CacheDirectory;
                        public readonly string CacheFileName;
                        public string CacheFilePath { get => throw null; }
                        public string ClientId { get => throw null; }
                        public readonly System.Collections.Generic.KeyValuePair<string, string> KeyringAttribute1;
                        public readonly System.Collections.Generic.KeyValuePair<string, string> KeyringAttribute2;
                        public readonly string KeyringCollection;
                        public readonly string KeyringSchemaName;
                        public readonly string KeyringSecretLabel;
                        public readonly int LockRetryCount;
                        public readonly int LockRetryDelay;
                        public readonly string MacKeyChainAccountName;
                        public readonly string MacKeyChainServiceName;
                        public readonly bool UseLinuxUnencryptedFallback;
                        public readonly bool UseUnencryptedFallback;
                    }
                    public class StorageCreationPropertiesBuilder
                    {
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationProperties Build() => throw null;
                        public StorageCreationPropertiesBuilder(string cacheFileName, string cacheDirectory, string clientId) => throw null;
                        public StorageCreationPropertiesBuilder(string cacheFileName, string cacheDirectory) => throw null;
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationPropertiesBuilder CustomizeLockRetry(int lockRetryDelay, int lockRetryCount) => throw null;
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationPropertiesBuilder WithCacheChangedEvent(string clientId, string authority = default(string)) => throw null;
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationPropertiesBuilder WithLinuxKeyring(string schemaName, string collection, string secretLabel, System.Collections.Generic.KeyValuePair<string, string> attribute1, System.Collections.Generic.KeyValuePair<string, string> attribute2) => throw null;
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationPropertiesBuilder WithLinuxUnprotectedFile() => throw null;
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationPropertiesBuilder WithMacKeyChain(string serviceName, string accountName) => throw null;
                        public Microsoft.Identity.Client.Extensions.Msal.StorageCreationPropertiesBuilder WithUnprotectedFile() => throw null;
                    }
                    public class TraceSourceLogger
                    {
                        public TraceSourceLogger(System.Diagnostics.TraceSource traceSource) => throw null;
                        public void LogError(string message) => throw null;
                        public void LogInformation(string message) => throw null;
                        public void LogWarning(string message) => throw null;
                        public System.Diagnostics.TraceSource Source { get => throw null; }
                    }
                }
            }
        }
    }
}
