// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Tokens, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Tokens
        {
            public delegate bool AlgorithmValidator(string algorithm, Microsoft.IdentityModel.Tokens.SecurityKey securityKey, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public abstract class AsymmetricSecurityKey : Microsoft.IdentityModel.Tokens.SecurityKey
            {
                public AsymmetricSecurityKey() => throw null;
                public abstract bool HasPrivateKey { get; }
                public abstract Microsoft.IdentityModel.Tokens.PrivateKeyStatus PrivateKeyStatus { get; }
            }
            public class AsymmetricSignatureProvider : Microsoft.IdentityModel.Tokens.SignatureProvider
            {
                public AsymmetricSignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) : base(default(Microsoft.IdentityModel.Tokens.SecurityKey), default(string)) => throw null;
                public AsymmetricSignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, bool willCreateSignatures) : base(default(Microsoft.IdentityModel.Tokens.SecurityKey), default(string)) => throw null;
                public static readonly System.Collections.Generic.Dictionary<string, int> DefaultMinimumAsymmetricKeySizeInBitsForSigningMap;
                public static readonly System.Collections.Generic.Dictionary<string, int> DefaultMinimumAsymmetricKeySizeInBitsForVerifyingMap;
                protected override void Dispose(bool disposing) => throw null;
                protected virtual System.Security.Cryptography.HashAlgorithmName GetHashAlgorithmName(string algorithm) => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, int> MinimumAsymmetricKeySizeInBitsForSigningMap { get => throw null; }
                public System.Collections.Generic.IReadOnlyDictionary<string, int> MinimumAsymmetricKeySizeInBitsForVerifyingMap { get => throw null; }
                public override bool Sign(System.ReadOnlySpan<byte> input, System.Span<byte> signature, out int bytesWritten) => throw null;
                public override byte[] Sign(byte[] input) => throw null;
                public override byte[] Sign(byte[] input, int offset, int count) => throw null;
                public virtual void ValidateAsymmetricSecurityKeySize(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, bool willCreateSignatures) => throw null;
                public override bool Verify(byte[] input, byte[] signature) => throw null;
                public override bool Verify(byte[] input, int inputOffset, int inputLength, byte[] signature, int signatureOffset, int signatureLength) => throw null;
            }
            public delegate bool AudienceValidator(System.Collections.Generic.IEnumerable<string> audiences, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public class AuthenticatedEncryptionProvider : System.IDisposable
            {
                public string Algorithm { get => throw null; }
                public string Context { get => throw null; set { } }
                public AuthenticatedEncryptionProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public virtual byte[] Decrypt(byte[] ciphertext, byte[] authenticatedData, byte[] iv, byte[] authenticationTag) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.AuthenticatedEncryptionResult Encrypt(byte[] plaintext, byte[] authenticatedData) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.AuthenticatedEncryptionResult Encrypt(byte[] plaintext, byte[] authenticatedData, byte[] iv) => throw null;
                protected virtual byte[] GetKeyBytes(Microsoft.IdentityModel.Tokens.SecurityKey key) => throw null;
                protected virtual bool IsSupportedAlgorithm(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
                protected virtual void ValidateKeySize(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
            }
            public class AuthenticatedEncryptionResult
            {
                public byte[] AuthenticationTag { get => throw null; }
                public byte[] Ciphertext { get => throw null; }
                public AuthenticatedEncryptionResult(Microsoft.IdentityModel.Tokens.SecurityKey key, byte[] ciphertext, byte[] iv, byte[] authenticationTag) => throw null;
                public byte[] IV { get => throw null; }
                public Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
            }
            public static class Base64UrlEncoder
            {
                public static string Decode(string arg) => throw null;
                public static byte[] DecodeBytes(string str) => throw null;
                public static string Encode(string arg) => throw null;
                public static string Encode(byte[] inArray) => throw null;
                public static string Encode(byte[] inArray, int offset, int length) => throw null;
                public static int Encode(System.ReadOnlySpan<byte> inArray, System.Span<char> output) => throw null;
            }
            public abstract class BaseConfiguration
            {
                public virtual string ActiveTokenEndpoint { get => throw null; set { } }
                protected BaseConfiguration() => throw null;
                public virtual string Issuer { get => throw null; set { } }
                public virtual System.Collections.Generic.ICollection<Microsoft.IdentityModel.Tokens.SecurityKey> SigningKeys { get => throw null; }
                public virtual System.Collections.Generic.ICollection<Microsoft.IdentityModel.Tokens.SecurityKey> TokenDecryptionKeys { get => throw null; }
                public virtual string TokenEndpoint { get => throw null; set { } }
            }
            public abstract class BaseConfigurationManager
            {
                public System.TimeSpan AutomaticRefreshInterval { get => throw null; set { } }
                public BaseConfigurationManager() => throw null;
                public BaseConfigurationManager(Microsoft.IdentityModel.Tokens.Configuration.LKGConfigurationCacheOptions options) => throw null;
                public static readonly System.TimeSpan DefaultAutomaticRefreshInterval;
                public static readonly System.TimeSpan DefaultLastKnownGoodConfigurationLifetime;
                public static readonly System.TimeSpan DefaultRefreshInterval;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.BaseConfiguration> GetBaseConfigurationAsync(System.Threading.CancellationToken cancel) => throw null;
                public bool IsLastKnownGoodValid { get => throw null; }
                public Microsoft.IdentityModel.Tokens.BaseConfiguration LastKnownGoodConfiguration { get => throw null; set { } }
                public System.TimeSpan LastKnownGoodLifetime { get => throw null; set { } }
                public string MetadataAddress { get => throw null; set { } }
                public static readonly System.TimeSpan MinimumAutomaticRefreshInterval;
                public static readonly System.TimeSpan MinimumRefreshInterval;
                public System.TimeSpan RefreshInterval { get => throw null; set { } }
                public abstract void RequestRefresh();
                public bool UseLastKnownGoodConfiguration { get => throw null; set { } }
            }
            public class CallContext : Microsoft.IdentityModel.Logging.LoggerContext
            {
                public CallContext() => throw null;
                public CallContext(System.Guid activityId) => throw null;
            }
            public static class CollectionUtilities
            {
                public static bool IsNullOrEmpty<T>(this System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
            }
            public class CompressionAlgorithms
            {
                public CompressionAlgorithms() => throw null;
                public const string Deflate = default;
            }
            public class CompressionProviderFactory
            {
                public Microsoft.IdentityModel.Tokens.ICompressionProvider CreateCompressionProvider(string algorithm) => throw null;
                public Microsoft.IdentityModel.Tokens.ICompressionProvider CreateCompressionProvider(string algorithm, int maximumDeflateSize) => throw null;
                public CompressionProviderFactory() => throw null;
                public CompressionProviderFactory(Microsoft.IdentityModel.Tokens.CompressionProviderFactory other) => throw null;
                public Microsoft.IdentityModel.Tokens.ICompressionProvider CustomCompressionProvider { get => throw null; set { } }
                public static Microsoft.IdentityModel.Tokens.CompressionProviderFactory Default { get => throw null; set { } }
                public virtual bool IsSupportedAlgorithm(string algorithm) => throw null;
            }
            namespace Configuration
            {
                public class LKGConfigurationCacheOptions
                {
                    public System.Collections.Generic.IEqualityComparer<Microsoft.IdentityModel.Tokens.BaseConfiguration> BaseConfigurationComparer { get => throw null; set { } }
                    public LKGConfigurationCacheOptions() => throw null;
                    public static readonly int DefaultLKGConfigurationSizeLimit;
                    public int LastKnownGoodConfigurationSizeLimit { get => throw null; set { } }
                    public bool RemoveExpiredValues { get => throw null; set { } }
                    public System.Threading.Tasks.TaskCreationOptions TaskCreationOptions { get => throw null; set { } }
                }
            }
            public abstract class CryptoProviderCache
            {
                protected CryptoProviderCache() => throw null;
                protected abstract string GetCacheKey(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider);
                protected abstract string GetCacheKey(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, string algorithm, string typeofProvider);
                public abstract bool TryAdd(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider);
                public abstract bool TryGetSignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, string algorithm, string typeofProvider, bool willCreateSignatures, out Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider);
                public abstract bool TryRemove(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider);
            }
            public class CryptoProviderCacheOptions
            {
                public CryptoProviderCacheOptions() => throw null;
                public static readonly int DefaultSizeLimit;
                public int SizeLimit { get => throw null; set { } }
            }
            public class CryptoProviderFactory
            {
                public bool CacheSignatureProviders { get => throw null; set { } }
                public virtual Microsoft.IdentityModel.Tokens.AuthenticatedEncryptionProvider CreateAuthenticatedEncryptionProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.SignatureProvider CreateForSigning(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.SignatureProvider CreateForSigning(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, bool cacheProvider) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.SignatureProvider CreateForVerifying(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.SignatureProvider CreateForVerifying(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, bool cacheProvider) => throw null;
                public virtual System.Security.Cryptography.HashAlgorithm CreateHashAlgorithm(System.Security.Cryptography.HashAlgorithmName algorithm) => throw null;
                public virtual System.Security.Cryptography.HashAlgorithm CreateHashAlgorithm(string algorithm) => throw null;
                public virtual System.Security.Cryptography.KeyedHashAlgorithm CreateKeyedHashAlgorithm(byte[] keyBytes, string algorithm) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.KeyWrapProvider CreateKeyWrapProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.KeyWrapProvider CreateKeyWrapProviderForUnwrap(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public Microsoft.IdentityModel.Tokens.CryptoProviderCache CryptoProviderCache { get => throw null; }
                public CryptoProviderFactory() => throw null;
                public CryptoProviderFactory(Microsoft.IdentityModel.Tokens.CryptoProviderCache cache) => throw null;
                public CryptoProviderFactory(Microsoft.IdentityModel.Tokens.CryptoProviderFactory other) => throw null;
                public Microsoft.IdentityModel.Tokens.ICryptoProvider CustomCryptoProvider { get => throw null; set { } }
                public static Microsoft.IdentityModel.Tokens.CryptoProviderFactory Default { get => throw null; set { } }
                public static bool DefaultCacheSignatureProviders { get => throw null; set { } }
                public static int DefaultSignatureProviderObjectPoolCacheSize { get => throw null; set { } }
                public virtual bool IsSupportedAlgorithm(string algorithm) => throw null;
                public virtual bool IsSupportedAlgorithm(string algorithm, Microsoft.IdentityModel.Tokens.SecurityKey key) => throw null;
                public virtual void ReleaseHashAlgorithm(System.Security.Cryptography.HashAlgorithm hashAlgorithm) => throw null;
                public virtual void ReleaseKeyWrapProvider(Microsoft.IdentityModel.Tokens.KeyWrapProvider provider) => throw null;
                public virtual void ReleaseRsaKeyWrapProvider(Microsoft.IdentityModel.Tokens.RsaKeyWrapProvider provider) => throw null;
                public virtual void ReleaseSignatureProvider(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider) => throw null;
                public int SignatureProviderObjectPoolCacheSize { get => throw null; set { } }
            }
            public static class DateTimeUtil
            {
                public static System.DateTime Add(System.DateTime time, System.TimeSpan timespan) => throw null;
                public static System.DateTime GetMaxValue(System.DateTimeKind kind) => throw null;
                public static System.DateTime GetMinValue(System.DateTimeKind kind) => throw null;
                public static System.DateTime? ToUniversalTime(System.DateTime? value) => throw null;
                public static System.DateTime ToUniversalTime(System.DateTime value) => throw null;
            }
            public class DeflateCompressionProvider : Microsoft.IdentityModel.Tokens.ICompressionProvider
            {
                public string Algorithm { get => throw null; }
                public byte[] Compress(byte[] value) => throw null;
                public System.IO.Compression.CompressionLevel CompressionLevel { get => throw null; }
                public DeflateCompressionProvider() => throw null;
                public DeflateCompressionProvider(System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public byte[] Decompress(byte[] value) => throw null;
                public bool IsSupportedAlgorithm(string algorithm) => throw null;
                public int MaximumDeflateSize { get => throw null; set { } }
            }
            public class EcdhKeyExchangeProvider
            {
                public EcdhKeyExchangeProvider(Microsoft.IdentityModel.Tokens.SecurityKey privateKey, Microsoft.IdentityModel.Tokens.SecurityKey publicKey, string alg, string enc) => throw null;
                public Microsoft.IdentityModel.Tokens.SecurityKey GenerateKdf(string apu = default(string), string apv = default(string)) => throw null;
                public int KeyDataLen { get => throw null; set { } }
            }
            public class ECDsaSecurityKey : Microsoft.IdentityModel.Tokens.AsymmetricSecurityKey
            {
                public override bool CanComputeJwkThumbprint() => throw null;
                public override byte[] ComputeJwkThumbprint() => throw null;
                public ECDsaSecurityKey(System.Security.Cryptography.ECDsa ecdsa) => throw null;
                public System.Security.Cryptography.ECDsa ECDsa { get => throw null; }
                public override bool HasPrivateKey { get => throw null; }
                public override int KeySize { get => throw null; }
                public override Microsoft.IdentityModel.Tokens.PrivateKeyStatus PrivateKeyStatus { get => throw null; }
            }
            public class EncryptingCredentials
            {
                public string Alg { get => throw null; }
                public Microsoft.IdentityModel.Tokens.CryptoProviderFactory CryptoProviderFactory { get => throw null; set { } }
                protected EncryptingCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, string alg, string enc) => throw null;
                public EncryptingCredentials(Microsoft.IdentityModel.Tokens.SecurityKey key, string alg, string enc) => throw null;
                public EncryptingCredentials(Microsoft.IdentityModel.Tokens.SymmetricSecurityKey key, string enc) => throw null;
                public string Enc { get => throw null; }
                public Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
                public Microsoft.IdentityModel.Tokens.SecurityKey KeyExchangePublicKey { get => throw null; set { } }
                public bool SetDefaultCtyClaim { get => throw null; set { } }
            }
            public static class EpochTime
            {
                public static System.DateTime DateTime(long secondsSinceUnixEpoch) => throw null;
                public static long GetIntDate(System.DateTime datetime) => throw null;
                public static readonly System.DateTime UnixEpoch;
            }
            public interface ICompressionProvider
            {
                string Algorithm { get; }
                byte[] Compress(byte[] value);
                byte[] Decompress(byte[] value);
                bool IsSupportedAlgorithm(string algorithm);
            }
            public interface ICryptoProvider
            {
                object Create(string algorithm, params object[] args);
                bool IsSupportedAlgorithm(string algorithm, params object[] args);
                void Release(object cryptoInstance);
            }
            public class InMemoryCryptoProviderCache : Microsoft.IdentityModel.Tokens.CryptoProviderCache, System.IDisposable
            {
                public InMemoryCryptoProviderCache() => throw null;
                public InMemoryCryptoProviderCache(Microsoft.IdentityModel.Tokens.CryptoProviderCacheOptions cryptoProviderCacheOptions) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                protected override string GetCacheKey(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider) => throw null;
                protected override string GetCacheKey(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, string algorithm, string typeofProvider) => throw null;
                public override bool TryAdd(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider) => throw null;
                public override bool TryGetSignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, string algorithm, string typeofProvider, bool willCreateSignatures, out Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider) => throw null;
                public override bool TryRemove(Microsoft.IdentityModel.Tokens.SignatureProvider signatureProvider) => throw null;
            }
            public interface ISecurityTokenValidator
            {
                bool CanReadToken(string securityToken);
                bool CanValidateToken { get; }
                int MaximumTokenSizeInBytes { get; set; }
                System.Security.Claims.ClaimsPrincipal ValidateToken(string securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, out Microsoft.IdentityModel.Tokens.SecurityToken validatedToken);
            }
            public delegate System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> IssuerSigningKeyResolver(string token, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, string kid, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public delegate System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> IssuerSigningKeyResolverUsingConfiguration(string token, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, string kid, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, Microsoft.IdentityModel.Tokens.BaseConfiguration configuration);
            public delegate bool IssuerSigningKeyValidator(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public delegate bool IssuerSigningKeyValidatorUsingConfiguration(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, Microsoft.IdentityModel.Tokens.BaseConfiguration configuration);
            public delegate string IssuerValidator(string issuer, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public delegate string IssuerValidatorUsingConfiguration(string issuer, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, Microsoft.IdentityModel.Tokens.BaseConfiguration configuration);
            public interface ITokenReplayCache
            {
                bool TryAdd(string securityToken, System.DateTime expiresOn);
                bool TryFind(string securityToken);
            }
            public static class JsonWebAlgorithmsKeyTypes
            {
                public const string EllipticCurve = default;
                public const string Octet = default;
                public const string RSA = default;
            }
            public class JsonWebKey : Microsoft.IdentityModel.Tokens.SecurityKey
            {
                public System.Collections.Generic.IDictionary<string, object> AdditionalData { get => throw null; }
                public string Alg { get => throw null; set { } }
                public override bool CanComputeJwkThumbprint() => throw null;
                public override byte[] ComputeJwkThumbprint() => throw null;
                public static Microsoft.IdentityModel.Tokens.JsonWebKey Create(string json) => throw null;
                public string Crv { get => throw null; set { } }
                public JsonWebKey() => throw null;
                public JsonWebKey(string json) => throw null;
                public string D { get => throw null; set { } }
                public string DP { get => throw null; set { } }
                public string DQ { get => throw null; set { } }
                public string E { get => throw null; set { } }
                public bool HasPrivateKey { get => throw null; }
                public string K { get => throw null; set { } }
                public override string KeyId { get => throw null; set { } }
                public System.Collections.Generic.IList<string> KeyOps { get => throw null; }
                public override int KeySize { get => throw null; }
                public string Kid { get => throw null; set { } }
                public string Kty { get => throw null; set { } }
                public string N { get => throw null; set { } }
                public System.Collections.Generic.IList<string> Oth { get => throw null; }
                public string P { get => throw null; set { } }
                public string Q { get => throw null; set { } }
                public string QI { get => throw null; set { } }
                public override string ToString() => throw null;
                public string Use { get => throw null; set { } }
                public string X { get => throw null; set { } }
                public System.Collections.Generic.IList<string> X5c { get => throw null; }
                public string X5t { get => throw null; set { } }
                public string X5tS256 { get => throw null; set { } }
                public string X5u { get => throw null; set { } }
                public string Y { get => throw null; set { } }
            }
            public class JsonWebKeyConverter
            {
                public static Microsoft.IdentityModel.Tokens.JsonWebKey ConvertFromECDsaSecurityKey(Microsoft.IdentityModel.Tokens.ECDsaSecurityKey key) => throw null;
                public static Microsoft.IdentityModel.Tokens.JsonWebKey ConvertFromRSASecurityKey(Microsoft.IdentityModel.Tokens.RsaSecurityKey key) => throw null;
                public static Microsoft.IdentityModel.Tokens.JsonWebKey ConvertFromSecurityKey(Microsoft.IdentityModel.Tokens.SecurityKey key) => throw null;
                public static Microsoft.IdentityModel.Tokens.JsonWebKey ConvertFromSymmetricSecurityKey(Microsoft.IdentityModel.Tokens.SymmetricSecurityKey key) => throw null;
                public static Microsoft.IdentityModel.Tokens.JsonWebKey ConvertFromX509SecurityKey(Microsoft.IdentityModel.Tokens.X509SecurityKey key) => throw null;
                public static Microsoft.IdentityModel.Tokens.JsonWebKey ConvertFromX509SecurityKey(Microsoft.IdentityModel.Tokens.X509SecurityKey key, bool representAsRsaKey) => throw null;
                public JsonWebKeyConverter() => throw null;
            }
            public static class JsonWebKeyECTypes
            {
                public const string P256 = default;
                public const string P384 = default;
                public const string P512 = default;
                public const string P521 = default;
            }
            public static class JsonWebKeyParameterNames
            {
                public const string Alg = default;
                public const string Crv = default;
                public const string D = default;
                public const string DP = default;
                public const string DQ = default;
                public const string E = default;
                public const string K = default;
                public const string KeyOps = default;
                public const string Keys = default;
                public const string Kid = default;
                public const string Kty = default;
                public const string N = default;
                public const string Oth = default;
                public const string P = default;
                public const string Q = default;
                public const string QI = default;
                public const string Use = default;
                public const string X = default;
                public const string X5c = default;
                public const string X5t = default;
                public const string X5tS256 = default;
                public const string X5u = default;
                public const string Y = default;
            }
            public class JsonWebKeySet
            {
                public System.Collections.Generic.IDictionary<string, object> AdditionalData { get => throw null; }
                public static Microsoft.IdentityModel.Tokens.JsonWebKeySet Create(string json) => throw null;
                public JsonWebKeySet() => throw null;
                public JsonWebKeySet(string json) => throw null;
                public static bool DefaultSkipUnresolvedJsonWebKeys;
                public System.Collections.Generic.IList<Microsoft.IdentityModel.Tokens.SecurityKey> GetSigningKeys() => throw null;
                public System.Collections.Generic.IList<Microsoft.IdentityModel.Tokens.JsonWebKey> Keys { get => throw null; }
                public bool SkipUnresolvedJsonWebKeys { get => throw null; set { } }
            }
            public static class JsonWebKeySetParameterNames
            {
                public const string Keys = default;
            }
            public static class JsonWebKeyUseNames
            {
                public const string Enc = default;
                public const string Sig = default;
            }
            public abstract class KeyWrapProvider : System.IDisposable
            {
                public abstract string Algorithm { get; }
                public abstract string Context { get; set; }
                protected KeyWrapProvider() => throw null;
                public void Dispose() => throw null;
                protected abstract void Dispose(bool disposing);
                public abstract Microsoft.IdentityModel.Tokens.SecurityKey Key { get; }
                public abstract byte[] UnwrapKey(byte[] keyBytes);
                public abstract byte[] WrapKey(byte[] keyBytes);
            }
            public delegate bool LifetimeValidator(System.DateTime? notBefore, System.DateTime? expires, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public enum PrivateKeyStatus
            {
                Exists = 0,
                DoesNotExist = 1,
                Unknown = 2,
            }
            public class RsaKeyWrapProvider : Microsoft.IdentityModel.Tokens.KeyWrapProvider
            {
                public override string Algorithm { get => throw null; }
                public override string Context { get => throw null; set { } }
                public RsaKeyWrapProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, bool willUnwrap) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected virtual bool IsSupportedAlgorithm(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public override Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
                public override byte[] UnwrapKey(byte[] keyBytes) => throw null;
                public override byte[] WrapKey(byte[] keyBytes) => throw null;
            }
            public class RsaSecurityKey : Microsoft.IdentityModel.Tokens.AsymmetricSecurityKey
            {
                public override bool CanComputeJwkThumbprint() => throw null;
                public override byte[] ComputeJwkThumbprint() => throw null;
                public RsaSecurityKey(System.Security.Cryptography.RSAParameters rsaParameters) => throw null;
                public RsaSecurityKey(System.Security.Cryptography.RSA rsa) => throw null;
                public override bool HasPrivateKey { get => throw null; }
                public override int KeySize { get => throw null; }
                public System.Security.Cryptography.RSAParameters Parameters { get => throw null; }
                public override Microsoft.IdentityModel.Tokens.PrivateKeyStatus PrivateKeyStatus { get => throw null; }
                public System.Security.Cryptography.RSA Rsa { get => throw null; }
            }
            public static class SecurityAlgorithms
            {
                public const string Aes128CbcHmacSha256 = default;
                public const string Aes128Encryption = default;
                public const string Aes128Gcm = default;
                public const string Aes128KeyWrap = default;
                public const string Aes128KW = default;
                public const string Aes192CbcHmacSha384 = default;
                public const string Aes192Encryption = default;
                public const string Aes192Gcm = default;
                public const string Aes192KeyWrap = default;
                public const string Aes192KW = default;
                public const string Aes256CbcHmacSha512 = default;
                public const string Aes256Encryption = default;
                public const string Aes256Gcm = default;
                public const string Aes256KeyWrap = default;
                public const string Aes256KW = default;
                public const string DesEncryption = default;
                public const string EcdhEs = default;
                public const string EcdhEsA128kw = default;
                public const string EcdhEsA192kw = default;
                public const string EcdhEsA256kw = default;
                public const string EcdsaSha256 = default;
                public const string EcdsaSha256Signature = default;
                public const string EcdsaSha384 = default;
                public const string EcdsaSha384Signature = default;
                public const string EcdsaSha512 = default;
                public const string EcdsaSha512Signature = default;
                public const string EnvelopedSignature = default;
                public const string ExclusiveC14n = default;
                public const string ExclusiveC14nWithComments = default;
                public const string HmacSha256 = default;
                public const string HmacSha256Signature = default;
                public const string HmacSha384 = default;
                public const string HmacSha384Signature = default;
                public const string HmacSha512 = default;
                public const string HmacSha512Signature = default;
                public const string None = default;
                public const string Ripemd160Digest = default;
                public const string RsaOAEP = default;
                public const string RsaOaepKeyWrap = default;
                public const string RsaPKCS1 = default;
                public const string RsaSha256 = default;
                public const string RsaSha256Signature = default;
                public const string RsaSha384 = default;
                public const string RsaSha384Signature = default;
                public const string RsaSha512 = default;
                public const string RsaSha512Signature = default;
                public const string RsaSsaPssSha256 = default;
                public const string RsaSsaPssSha256Signature = default;
                public const string RsaSsaPssSha384 = default;
                public const string RsaSsaPssSha384Signature = default;
                public const string RsaSsaPssSha512 = default;
                public const string RsaSsaPssSha512Signature = default;
                public const string RsaV15KeyWrap = default;
                public const string Sha256 = default;
                public const string Sha256Digest = default;
                public const string Sha384 = default;
                public const string Sha384Digest = default;
                public const string Sha512 = default;
                public const string Sha512Digest = default;
            }
            public abstract class SecurityKey
            {
                public virtual bool CanComputeJwkThumbprint() => throw null;
                public virtual byte[] ComputeJwkThumbprint() => throw null;
                public Microsoft.IdentityModel.Tokens.CryptoProviderFactory CryptoProviderFactory { get => throw null; set { } }
                public SecurityKey() => throw null;
                public virtual bool IsSupportedAlgorithm(string algorithm) => throw null;
                public virtual string KeyId { get => throw null; set { } }
                public abstract int KeySize { get; }
                public override string ToString() => throw null;
            }
            public class SecurityKeyIdentifierClause
            {
                public SecurityKeyIdentifierClause() => throw null;
            }
            public abstract class SecurityToken : Microsoft.IdentityModel.Logging.ISafeLogSecurityArtifact
            {
                protected SecurityToken() => throw null;
                public abstract string Id { get; }
                public abstract string Issuer { get; }
                public abstract Microsoft.IdentityModel.Tokens.SecurityKey SecurityKey { get; }
                public abstract Microsoft.IdentityModel.Tokens.SecurityKey SigningKey { get; set; }
                public virtual string UnsafeToString() => throw null;
                public abstract System.DateTime ValidFrom { get; }
                public abstract System.DateTime ValidTo { get; }
            }
            public class SecurityTokenArgumentException : System.ArgumentException
            {
                public SecurityTokenArgumentException() => throw null;
                public SecurityTokenArgumentException(string message) => throw null;
                public SecurityTokenArgumentException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenArgumentException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenCompressionFailedException : Microsoft.IdentityModel.Tokens.SecurityTokenException
            {
                public SecurityTokenCompressionFailedException() => throw null;
                public SecurityTokenCompressionFailedException(string message) => throw null;
                public SecurityTokenCompressionFailedException(string message, System.Exception inner) => throw null;
                protected SecurityTokenCompressionFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenDecompressionFailedException : Microsoft.IdentityModel.Tokens.SecurityTokenException
            {
                public SecurityTokenDecompressionFailedException() => throw null;
                public SecurityTokenDecompressionFailedException(string message) => throw null;
                public SecurityTokenDecompressionFailedException(string message, System.Exception inner) => throw null;
                protected SecurityTokenDecompressionFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenDecryptionFailedException : Microsoft.IdentityModel.Tokens.SecurityTokenException
            {
                public SecurityTokenDecryptionFailedException() => throw null;
                public SecurityTokenDecryptionFailedException(string message) => throw null;
                public SecurityTokenDecryptionFailedException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenDecryptionFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenDescriptor
            {
                public System.Collections.Generic.IDictionary<string, object> AdditionalHeaderClaims { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> AdditionalInnerHeaderClaims { get => throw null; set { } }
                public string Audience { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> Claims { get => throw null; set { } }
                public string CompressionAlgorithm { get => throw null; set { } }
                public SecurityTokenDescriptor() => throw null;
                public Microsoft.IdentityModel.Tokens.EncryptingCredentials EncryptingCredentials { get => throw null; set { } }
                public System.DateTime? Expires { get => throw null; set { } }
                public System.DateTime? IssuedAt { get => throw null; set { } }
                public string Issuer { get => throw null; set { } }
                public System.DateTime? NotBefore { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SigningCredentials SigningCredentials { get => throw null; set { } }
                public System.Security.Claims.ClaimsIdentity Subject { get => throw null; set { } }
                public string TokenType { get => throw null; set { } }
            }
            public class SecurityTokenEncryptionFailedException : Microsoft.IdentityModel.Tokens.SecurityTokenException
            {
                public SecurityTokenEncryptionFailedException() => throw null;
                public SecurityTokenEncryptionFailedException(string message) => throw null;
                public SecurityTokenEncryptionFailedException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenEncryptionFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenEncryptionKeyNotFoundException : Microsoft.IdentityModel.Tokens.SecurityTokenDecryptionFailedException
            {
                public SecurityTokenEncryptionKeyNotFoundException() => throw null;
                public SecurityTokenEncryptionKeyNotFoundException(string message) => throw null;
                public SecurityTokenEncryptionKeyNotFoundException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenEncryptionKeyNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenException : System.Exception
            {
                public SecurityTokenException() => throw null;
                public SecurityTokenException(string message) => throw null;
                public SecurityTokenException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenExpiredException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenExpiredException() => throw null;
                public SecurityTokenExpiredException(string message) => throw null;
                public SecurityTokenExpiredException(string message, System.Exception inner) => throw null;
                protected SecurityTokenExpiredException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.DateTime Expires { get => throw null; set { } }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public abstract class SecurityTokenHandler : Microsoft.IdentityModel.Tokens.TokenHandler, Microsoft.IdentityModel.Tokens.ISecurityTokenValidator
            {
                public virtual bool CanReadToken(System.Xml.XmlReader reader) => throw null;
                public virtual bool CanReadToken(string tokenString) => throw null;
                public virtual bool CanValidateToken { get => throw null; }
                public virtual bool CanWriteToken { get => throw null; }
                public virtual Microsoft.IdentityModel.Tokens.SecurityKeyIdentifierClause CreateSecurityTokenReference(Microsoft.IdentityModel.Tokens.SecurityToken token, bool attached) => throw null;
                public virtual Microsoft.IdentityModel.Tokens.SecurityToken CreateToken(Microsoft.IdentityModel.Tokens.SecurityTokenDescriptor tokenDescriptor) => throw null;
                protected SecurityTokenHandler() => throw null;
                public virtual Microsoft.IdentityModel.Tokens.SecurityToken ReadToken(System.Xml.XmlReader reader) => throw null;
                public abstract Microsoft.IdentityModel.Tokens.SecurityToken ReadToken(System.Xml.XmlReader reader, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
                public abstract System.Type TokenType { get; }
                public virtual System.Security.Claims.ClaimsPrincipal ValidateToken(string securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, out Microsoft.IdentityModel.Tokens.SecurityToken validatedToken) => throw null;
                public virtual System.Security.Claims.ClaimsPrincipal ValidateToken(System.Xml.XmlReader reader, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, out Microsoft.IdentityModel.Tokens.SecurityToken validatedToken) => throw null;
                public virtual string WriteToken(Microsoft.IdentityModel.Tokens.SecurityToken token) => throw null;
                public abstract void WriteToken(System.Xml.XmlWriter writer, Microsoft.IdentityModel.Tokens.SecurityToken token);
            }
            public class SecurityTokenInvalidAlgorithmException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidAlgorithmException() => throw null;
                public SecurityTokenInvalidAlgorithmException(string message) => throw null;
                public SecurityTokenInvalidAlgorithmException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenInvalidAlgorithmException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string InvalidAlgorithm { get => throw null; set { } }
            }
            public class SecurityTokenInvalidAudienceException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidAudienceException() => throw null;
                public SecurityTokenInvalidAudienceException(string message) => throw null;
                public SecurityTokenInvalidAudienceException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenInvalidAudienceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string InvalidAudience { get => throw null; set { } }
            }
            public class SecurityTokenInvalidIssuerException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidIssuerException() => throw null;
                public SecurityTokenInvalidIssuerException(string message) => throw null;
                public SecurityTokenInvalidIssuerException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenInvalidIssuerException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string InvalidIssuer { get => throw null; set { } }
            }
            public class SecurityTokenInvalidLifetimeException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidLifetimeException() => throw null;
                public SecurityTokenInvalidLifetimeException(string message) => throw null;
                public SecurityTokenInvalidLifetimeException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenInvalidLifetimeException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.DateTime? Expires { get => throw null; set { } }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.DateTime? NotBefore { get => throw null; set { } }
            }
            public class SecurityTokenInvalidSignatureException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidSignatureException() => throw null;
                public SecurityTokenInvalidSignatureException(string message) => throw null;
                public SecurityTokenInvalidSignatureException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenInvalidSignatureException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenInvalidSigningKeyException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidSigningKeyException() => throw null;
                public SecurityTokenInvalidSigningKeyException(string message) => throw null;
                public SecurityTokenInvalidSigningKeyException(string message, System.Exception inner) => throw null;
                protected SecurityTokenInvalidSigningKeyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public Microsoft.IdentityModel.Tokens.SecurityKey SigningKey { get => throw null; set { } }
            }
            public class SecurityTokenInvalidTypeException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenInvalidTypeException() => throw null;
                public SecurityTokenInvalidTypeException(string message) => throw null;
                public SecurityTokenInvalidTypeException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenInvalidTypeException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string InvalidType { get => throw null; set { } }
            }
            public class SecurityTokenKeyWrapException : Microsoft.IdentityModel.Tokens.SecurityTokenException
            {
                public SecurityTokenKeyWrapException() => throw null;
                public SecurityTokenKeyWrapException(string message) => throw null;
                public SecurityTokenKeyWrapException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenKeyWrapException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenMalformedException : Microsoft.IdentityModel.Tokens.SecurityTokenArgumentException
            {
                public SecurityTokenMalformedException() => throw null;
                public SecurityTokenMalformedException(string message) => throw null;
                public SecurityTokenMalformedException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenMalformedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenNoExpirationException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenNoExpirationException() => throw null;
                public SecurityTokenNoExpirationException(string message) => throw null;
                public SecurityTokenNoExpirationException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenNoExpirationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenNotYetValidException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenNotYetValidException() => throw null;
                public SecurityTokenNotYetValidException(string message) => throw null;
                public SecurityTokenNotYetValidException(string message, System.Exception inner) => throw null;
                protected SecurityTokenNotYetValidException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.DateTime NotBefore { get => throw null; set { } }
            }
            public class SecurityTokenReplayAddFailedException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenReplayAddFailedException() => throw null;
                public SecurityTokenReplayAddFailedException(string message) => throw null;
                public SecurityTokenReplayAddFailedException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenReplayAddFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenReplayDetectedException : Microsoft.IdentityModel.Tokens.SecurityTokenValidationException
            {
                public SecurityTokenReplayDetectedException() => throw null;
                public SecurityTokenReplayDetectedException(string message) => throw null;
                public SecurityTokenReplayDetectedException(string message, System.Exception inner) => throw null;
                protected SecurityTokenReplayDetectedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenSignatureKeyNotFoundException : Microsoft.IdentityModel.Tokens.SecurityTokenInvalidSignatureException
            {
                public SecurityTokenSignatureKeyNotFoundException() => throw null;
                public SecurityTokenSignatureKeyNotFoundException(string message) => throw null;
                public SecurityTokenSignatureKeyNotFoundException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenSignatureKeyNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class SecurityTokenUnableToValidateException : Microsoft.IdentityModel.Tokens.SecurityTokenInvalidSignatureException
            {
                public SecurityTokenUnableToValidateException() => throw null;
                public SecurityTokenUnableToValidateException(Microsoft.IdentityModel.Tokens.ValidationFailure validationFailure, string message) => throw null;
                public SecurityTokenUnableToValidateException(string message) => throw null;
                public SecurityTokenUnableToValidateException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenUnableToValidateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public Microsoft.IdentityModel.Tokens.ValidationFailure ValidationFailure { get => throw null; set { } }
            }
            public class SecurityTokenValidationException : Microsoft.IdentityModel.Tokens.SecurityTokenException
            {
                public SecurityTokenValidationException() => throw null;
                public SecurityTokenValidationException(string message) => throw null;
                public SecurityTokenValidationException(string message, System.Exception innerException) => throw null;
                protected SecurityTokenValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public abstract class SignatureProvider : System.IDisposable
            {
                public string Algorithm { get => throw null; }
                public string Context { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.CryptoProviderCache CryptoProviderCache { get => throw null; set { } }
                protected SignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public void Dispose() => throw null;
                protected abstract void Dispose(bool disposing);
                public Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
                public abstract byte[] Sign(byte[] input);
                public virtual byte[] Sign(byte[] input, int offset, int count) => throw null;
                public virtual bool Sign(System.ReadOnlySpan<byte> data, System.Span<byte> destination, out int bytesWritten) => throw null;
                public abstract bool Verify(byte[] input, byte[] signature);
                public virtual bool Verify(byte[] input, int inputOffset, int inputLength, byte[] signature, int signatureOffset, int signatureLength) => throw null;
                public bool WillCreateSignatures { get => throw null; set { } }
            }
            public delegate Microsoft.IdentityModel.Tokens.SecurityToken SignatureValidator(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public delegate Microsoft.IdentityModel.Tokens.SecurityToken SignatureValidatorUsingConfiguration(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, Microsoft.IdentityModel.Tokens.BaseConfiguration configuration);
            public class SigningCredentials
            {
                public string Algorithm { get => throw null; }
                public Microsoft.IdentityModel.Tokens.CryptoProviderFactory CryptoProviderFactory { get => throw null; set { } }
                protected SigningCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                protected SigningCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, string algorithm) => throw null;
                public SigningCredentials(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public SigningCredentials(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, string digest) => throw null;
                public string Digest { get => throw null; }
                public Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
                public string Kid { get => throw null; }
            }
            public class SymmetricKeyWrapProvider : Microsoft.IdentityModel.Tokens.KeyWrapProvider
            {
                public override string Algorithm { get => throw null; }
                public override string Context { get => throw null; set { } }
                public SymmetricKeyWrapProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected virtual System.Security.Cryptography.SymmetricAlgorithm GetSymmetricAlgorithm(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                protected virtual bool IsSupportedAlgorithm(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) => throw null;
                public override Microsoft.IdentityModel.Tokens.SecurityKey Key { get => throw null; }
                public override byte[] UnwrapKey(byte[] keyBytes) => throw null;
                public override byte[] WrapKey(byte[] keyBytes) => throw null;
            }
            public class SymmetricSecurityKey : Microsoft.IdentityModel.Tokens.SecurityKey
            {
                public override bool CanComputeJwkThumbprint() => throw null;
                public override byte[] ComputeJwkThumbprint() => throw null;
                public SymmetricSecurityKey(byte[] key) => throw null;
                public virtual byte[] Key { get => throw null; }
                public override int KeySize { get => throw null; }
            }
            public class SymmetricSignatureProvider : Microsoft.IdentityModel.Tokens.SignatureProvider
            {
                public SymmetricSignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm) : base(default(Microsoft.IdentityModel.Tokens.SecurityKey), default(string)) => throw null;
                public SymmetricSignatureProvider(Microsoft.IdentityModel.Tokens.SecurityKey key, string algorithm, bool willCreateSignatures) : base(default(Microsoft.IdentityModel.Tokens.SecurityKey), default(string)) => throw null;
                public static readonly int DefaultMinimumSymmetricKeySizeInBits;
                protected override void Dispose(bool disposing) => throw null;
                protected virtual byte[] GetKeyBytes(Microsoft.IdentityModel.Tokens.SecurityKey key) => throw null;
                protected virtual System.Security.Cryptography.KeyedHashAlgorithm GetKeyedHashAlgorithm(byte[] keyBytes, string algorithm) => throw null;
                public int MinimumSymmetricKeySizeInBits { get => throw null; set { } }
                protected virtual void ReleaseKeyedHashAlgorithm(System.Security.Cryptography.KeyedHashAlgorithm keyedHashAlgorithm) => throw null;
                public override byte[] Sign(byte[] input) => throw null;
                public override bool Sign(System.ReadOnlySpan<byte> input, System.Span<byte> signature, out int bytesWritten) => throw null;
                public override byte[] Sign(byte[] input, int offset, int count) => throw null;
                public override bool Verify(byte[] input, byte[] signature) => throw null;
                public bool Verify(byte[] input, byte[] signature, int length) => throw null;
                public override bool Verify(byte[] input, int inputOffset, int inputLength, byte[] signature, int signatureOffset, int signatureLength) => throw null;
            }
            public class TokenContext : Microsoft.IdentityModel.Tokens.CallContext
            {
                public TokenContext() => throw null;
                public TokenContext(System.Guid activityId) => throw null;
            }
            public delegate System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> TokenDecryptionKeyResolver(string token, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, string kid, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public abstract class TokenHandler
            {
                protected TokenHandler() => throw null;
                public static readonly int DefaultTokenLifetimeInMinutes;
                public virtual int MaximumTokenSizeInBytes { get => throw null; set { } }
                public virtual Microsoft.IdentityModel.Tokens.SecurityToken ReadToken(string token) => throw null;
                public bool SetDefaultTimesOnTokenCreation { get => throw null; set { } }
                public int TokenLifetimeInMinutes { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidateTokenAsync(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidateTokenAsync(Microsoft.IdentityModel.Tokens.SecurityToken token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
            }
            public delegate Microsoft.IdentityModel.Tokens.SecurityToken TokenReader(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public delegate bool TokenReplayValidator(System.DateTime? expirationTime, string securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public class TokenValidationParameters
            {
                public Microsoft.IdentityModel.Tokens.TokenValidationParameters ActorValidationParameters { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.AlgorithmValidator AlgorithmValidator { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.AudienceValidator AudienceValidator { get => throw null; set { } }
                public string AuthenticationType { get => throw null; set { } }
                public System.TimeSpan ClockSkew { get => throw null; set { } }
                public virtual Microsoft.IdentityModel.Tokens.TokenValidationParameters Clone() => throw null;
                public Microsoft.IdentityModel.Tokens.BaseConfigurationManager ConfigurationManager { get => throw null; set { } }
                public virtual System.Security.Claims.ClaimsIdentity CreateClaimsIdentity(Microsoft.IdentityModel.Tokens.SecurityToken securityToken, string issuer) => throw null;
                public Microsoft.IdentityModel.Tokens.CryptoProviderFactory CryptoProviderFactory { get => throw null; set { } }
                protected TokenValidationParameters(Microsoft.IdentityModel.Tokens.TokenValidationParameters other) => throw null;
                public TokenValidationParameters() => throw null;
                public string DebugId { get => throw null; set { } }
                public static readonly string DefaultAuthenticationType;
                public static readonly System.TimeSpan DefaultClockSkew;
                public const int DefaultMaximumTokenSizeInBytes = 256000;
                public bool IgnoreTrailingSlashWhenValidatingAudience { get => throw null; set { } }
                public bool IncludeTokenOnFailedValidation { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> InstancePropertyBag { get => throw null; }
                public bool IsClone { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SecurityKey IssuerSigningKey { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.IssuerSigningKeyResolver IssuerSigningKeyResolver { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.IssuerSigningKeyResolverUsingConfiguration IssuerSigningKeyResolverUsingConfiguration { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> IssuerSigningKeys { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.IssuerSigningKeyValidator IssuerSigningKeyValidator { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.IssuerSigningKeyValidatorUsingConfiguration IssuerSigningKeyValidatorUsingConfiguration { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.IssuerValidator IssuerValidator { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.IssuerValidatorUsingConfiguration IssuerValidatorUsingConfiguration { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.LifetimeValidator LifetimeValidator { get => throw null; set { } }
                public bool LogTokenId { get => throw null; set { } }
                public bool LogValidationExceptions { get => throw null; set { } }
                public string NameClaimType { get => throw null; set { } }
                public System.Func<Microsoft.IdentityModel.Tokens.SecurityToken, string, string> NameClaimTypeRetriever { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; set { } }
                public bool RefreshBeforeValidation { get => throw null; set { } }
                public bool RequireAudience { get => throw null; set { } }
                public bool RequireExpirationTime { get => throw null; set { } }
                public bool RequireSignedTokens { get => throw null; set { } }
                public string RoleClaimType { get => throw null; set { } }
                public System.Func<Microsoft.IdentityModel.Tokens.SecurityToken, string, string> RoleClaimTypeRetriever { get => throw null; set { } }
                public bool SaveSigninToken { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SignatureValidator SignatureValidator { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SignatureValidatorUsingConfiguration SignatureValidatorUsingConfiguration { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SecurityKey TokenDecryptionKey { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TokenDecryptionKeyResolver TokenDecryptionKeyResolver { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> TokenDecryptionKeys { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TokenReader TokenReader { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.ITokenReplayCache TokenReplayCache { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TokenReplayValidator TokenReplayValidator { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TransformBeforeSignatureValidation TransformBeforeSignatureValidation { get => throw null; set { } }
                public bool TryAllIssuerSigningKeys { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TypeValidator TypeValidator { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ValidAlgorithms { get => throw null; set { } }
                public bool ValidateActor { get => throw null; set { } }
                public bool ValidateAudience { get => throw null; set { } }
                public bool ValidateIssuer { get => throw null; set { } }
                public bool ValidateIssuerSigningKey { get => throw null; set { } }
                public bool ValidateLifetime { get => throw null; set { } }
                public bool ValidateSignatureLast { get => throw null; set { } }
                public bool ValidateTokenReplay { get => throw null; set { } }
                public bool ValidateWithLKG { get => throw null; set { } }
                public string ValidAudience { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ValidAudiences { get => throw null; set { } }
                public string ValidIssuer { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ValidIssuers { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ValidTypes { get => throw null; set { } }
            }
            public class TokenValidationResult
            {
                public System.Collections.Generic.IDictionary<string, object> Claims { get => throw null; }
                public System.Security.Claims.ClaimsIdentity ClaimsIdentity { get => throw null; set { } }
                public TokenValidationResult() => throw null;
                public System.Exception Exception { get => throw null; set { } }
                public string Issuer { get => throw null; set { } }
                public bool IsValid { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; }
                public Microsoft.IdentityModel.Tokens.SecurityToken SecurityToken { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.CallContext TokenContext { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SecurityToken TokenOnFailedValidation { get => throw null; }
                public string TokenType { get => throw null; set { } }
            }
            public delegate Microsoft.IdentityModel.Tokens.SecurityToken TransformBeforeSignatureValidation(Microsoft.IdentityModel.Tokens.SecurityToken token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public delegate string TypeValidator(string type, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public static class UniqueId
            {
                public static string CreateRandomId() => throw null;
                public static string CreateRandomId(string prefix) => throw null;
                public static System.Uri CreateRandomUri() => throw null;
                public static string CreateUniqueId() => throw null;
                public static string CreateUniqueId(string prefix) => throw null;
            }
            public static class Utility
            {
                public static bool AreEqual(byte[] a, byte[] b) => throw null;
                public static byte[] CloneByteArray(this byte[] src) => throw null;
                public const string Empty = default;
                public static bool IsHttps(string address) => throw null;
                public static bool IsHttps(System.Uri uri) => throw null;
                public const string Null = default;
            }
            public enum ValidationFailure
            {
                None = 0,
                InvalidLifetime = 1,
                InvalidIssuer = 2,
            }
            public static class Validators
            {
                public static void ValidateAlgorithm(string algorithm, Microsoft.IdentityModel.Tokens.SecurityKey securityKey, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static void ValidateAudience(System.Collections.Generic.IEnumerable<string> audiences, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static string ValidateIssuer(string issuer, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static void ValidateIssuerSecurityKey(Microsoft.IdentityModel.Tokens.SecurityKey securityKey, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static void ValidateLifetime(System.DateTime? notBefore, System.DateTime? expires, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static void ValidateTokenReplay(System.DateTime? expirationTime, string securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static void ValidateTokenReplay(string securityToken, System.DateTime? expirationTime, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static string ValidateTokenType(string type, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
            }
            public class X509EncryptingCredentials : Microsoft.IdentityModel.Tokens.EncryptingCredentials
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                public X509EncryptingCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) : base(default(Microsoft.IdentityModel.Tokens.SymmetricSecurityKey), default(string)) => throw null;
                public X509EncryptingCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, string keyWrapAlgorithm, string dataEncryptionAlgorithm) : base(default(Microsoft.IdentityModel.Tokens.SymmetricSecurityKey), default(string)) => throw null;
            }
            public class X509SecurityKey : Microsoft.IdentityModel.Tokens.AsymmetricSecurityKey
            {
                public override bool CanComputeJwkThumbprint() => throw null;
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                public override byte[] ComputeJwkThumbprint() => throw null;
                public X509SecurityKey(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public X509SecurityKey(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, string keyId) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public override bool HasPrivateKey { get => throw null; }
                public override int KeySize { get => throw null; }
                public System.Security.Cryptography.AsymmetricAlgorithm PrivateKey { get => throw null; }
                public override Microsoft.IdentityModel.Tokens.PrivateKeyStatus PrivateKeyStatus { get => throw null; }
                public System.Security.Cryptography.AsymmetricAlgorithm PublicKey { get => throw null; }
                public string X5t { get => throw null; }
            }
            public class X509SigningCredentials : Microsoft.IdentityModel.Tokens.SigningCredentials
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                public X509SigningCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) : base(default(System.Security.Cryptography.X509Certificates.X509Certificate2)) => throw null;
                public X509SigningCredentials(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, string algorithm) : base(default(System.Security.Cryptography.X509Certificates.X509Certificate2)) => throw null;
            }
        }
    }
}
