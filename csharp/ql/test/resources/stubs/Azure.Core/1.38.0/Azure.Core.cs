// This file contains auto-generated code.
// Generated from `Azure.Core, Version=1.38.0.0, Culture=neutral, PublicKeyToken=92742159e12e44c8`.
namespace Azure
{
    public abstract class AsyncPageable<T> : System.Collections.Generic.IAsyncEnumerable<T>
    {
        public abstract System.Collections.Generic.IAsyncEnumerable<Azure.Page<T>> AsPages(string continuationToken = default(string), int? pageSizeHint = default(int?));
        protected virtual System.Threading.CancellationToken CancellationToken { get => throw null; }
        protected AsyncPageable() => throw null;
        protected AsyncPageable(System.Threading.CancellationToken cancellationToken) => throw null;
        public override bool Equals(object obj) => throw null;
        public static Azure.AsyncPageable<T> FromPages(System.Collections.Generic.IEnumerable<Azure.Page<T>> pages) => throw null;
        public virtual System.Collections.Generic.IAsyncEnumerator<T> GetAsyncEnumerator(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public override int GetHashCode() => throw null;
        public override string ToString() => throw null;
    }
    public static partial class AzureCoreExtensions
    {
        public static dynamic ToDynamicFromJson(this System.BinaryData utf8Json) => throw null;
        public static dynamic ToDynamicFromJson(this System.BinaryData utf8Json, Azure.Core.Serialization.JsonPropertyNames propertyNameFormat, string dateTimeFormat = default(string)) => throw null;
        public static T ToObject<T>(this System.BinaryData data, Azure.Core.Serialization.ObjectSerializer serializer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.ValueTask<T> ToObjectAsync<T>(this System.BinaryData data, Azure.Core.Serialization.ObjectSerializer serializer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public static object ToObjectFromJson(this System.BinaryData data) => throw null;
    }
    public class AzureKeyCredential
    {
        public AzureKeyCredential(string key) => throw null;
        public string Key { get => throw null; }
        public void Update(string key) => throw null;
    }
    public class AzureNamedKeyCredential
    {
        public AzureNamedKeyCredential(string name, string key) => throw null;
        public void Deconstruct(out string name, out string key) => throw null;
        public string Name { get => throw null; }
        public void Update(string name, string key) => throw null;
    }
    public class AzureSasCredential
    {
        public AzureSasCredential(string signature) => throw null;
        public string Signature { get => throw null; }
        public void Update(string signature) => throw null;
    }
    namespace Core
    {
        public struct AccessToken
        {
            public AccessToken(string accessToken, System.DateTimeOffset expiresOn) => throw null;
            public override bool Equals(object obj) => throw null;
            public System.DateTimeOffset ExpiresOn { get => throw null; }
            public override int GetHashCode() => throw null;
            public string Token { get => throw null; }
        }
        public struct AzureLocation : System.IEquatable<Azure.Core.AzureLocation>
        {
            public static Azure.Core.AzureLocation AustraliaCentral { get => throw null; }
            public static Azure.Core.AzureLocation AustraliaCentral2 { get => throw null; }
            public static Azure.Core.AzureLocation AustraliaEast { get => throw null; }
            public static Azure.Core.AzureLocation AustraliaSoutheast { get => throw null; }
            public static Azure.Core.AzureLocation BrazilSouth { get => throw null; }
            public static Azure.Core.AzureLocation BrazilSoutheast { get => throw null; }
            public static Azure.Core.AzureLocation CanadaCentral { get => throw null; }
            public static Azure.Core.AzureLocation CanadaEast { get => throw null; }
            public static Azure.Core.AzureLocation CentralIndia { get => throw null; }
            public static Azure.Core.AzureLocation CentralUS { get => throw null; }
            public static Azure.Core.AzureLocation ChinaEast { get => throw null; }
            public static Azure.Core.AzureLocation ChinaEast2 { get => throw null; }
            public static Azure.Core.AzureLocation ChinaEast3 { get => throw null; }
            public static Azure.Core.AzureLocation ChinaNorth { get => throw null; }
            public static Azure.Core.AzureLocation ChinaNorth2 { get => throw null; }
            public static Azure.Core.AzureLocation ChinaNorth3 { get => throw null; }
            public AzureLocation(string location) => throw null;
            public AzureLocation(string name, string displayName) => throw null;
            public string DisplayName { get => throw null; }
            public static Azure.Core.AzureLocation EastAsia { get => throw null; }
            public static Azure.Core.AzureLocation EastUS { get => throw null; }
            public static Azure.Core.AzureLocation EastUS2 { get => throw null; }
            public bool Equals(Azure.Core.AzureLocation other) => throw null;
            public override bool Equals(object obj) => throw null;
            public static Azure.Core.AzureLocation FranceCentral { get => throw null; }
            public static Azure.Core.AzureLocation FranceSouth { get => throw null; }
            public static Azure.Core.AzureLocation GermanyCentral { get => throw null; }
            public static Azure.Core.AzureLocation GermanyNorth { get => throw null; }
            public static Azure.Core.AzureLocation GermanyNorthEast { get => throw null; }
            public static Azure.Core.AzureLocation GermanyWestCentral { get => throw null; }
            public override int GetHashCode() => throw null;
            public static Azure.Core.AzureLocation IsraelCentral { get => throw null; }
            public static Azure.Core.AzureLocation ItalyNorth { get => throw null; }
            public static Azure.Core.AzureLocation JapanEast { get => throw null; }
            public static Azure.Core.AzureLocation JapanWest { get => throw null; }
            public static Azure.Core.AzureLocation KoreaCentral { get => throw null; }
            public static Azure.Core.AzureLocation KoreaSouth { get => throw null; }
            public string Name { get => throw null; }
            public static Azure.Core.AzureLocation NorthCentralUS { get => throw null; }
            public static Azure.Core.AzureLocation NorthEurope { get => throw null; }
            public static Azure.Core.AzureLocation NorwayEast { get => throw null; }
            public static Azure.Core.AzureLocation NorwayWest { get => throw null; }
            public static bool operator ==(Azure.Core.AzureLocation left, Azure.Core.AzureLocation right) => throw null;
            public static implicit operator Azure.Core.AzureLocation(string location) => throw null;
            public static implicit operator string(Azure.Core.AzureLocation location) => throw null;
            public static bool operator !=(Azure.Core.AzureLocation left, Azure.Core.AzureLocation right) => throw null;
            public static Azure.Core.AzureLocation PolandCentral { get => throw null; }
            public static Azure.Core.AzureLocation QatarCentral { get => throw null; }
            public static Azure.Core.AzureLocation SouthAfricaNorth { get => throw null; }
            public static Azure.Core.AzureLocation SouthAfricaWest { get => throw null; }
            public static Azure.Core.AzureLocation SouthCentralUS { get => throw null; }
            public static Azure.Core.AzureLocation SoutheastAsia { get => throw null; }
            public static Azure.Core.AzureLocation SouthIndia { get => throw null; }
            public static Azure.Core.AzureLocation SwedenCentral { get => throw null; }
            public static Azure.Core.AzureLocation SwedenSouth { get => throw null; }
            public static Azure.Core.AzureLocation SwitzerlandNorth { get => throw null; }
            public static Azure.Core.AzureLocation SwitzerlandWest { get => throw null; }
            public override string ToString() => throw null;
            public static Azure.Core.AzureLocation UAECentral { get => throw null; }
            public static Azure.Core.AzureLocation UAENorth { get => throw null; }
            public static Azure.Core.AzureLocation UKSouth { get => throw null; }
            public static Azure.Core.AzureLocation UKWest { get => throw null; }
            public static Azure.Core.AzureLocation USDoDCentral { get => throw null; }
            public static Azure.Core.AzureLocation USDoDEast { get => throw null; }
            public static Azure.Core.AzureLocation USGovArizona { get => throw null; }
            public static Azure.Core.AzureLocation USGovIowa { get => throw null; }
            public static Azure.Core.AzureLocation USGovTexas { get => throw null; }
            public static Azure.Core.AzureLocation USGovVirginia { get => throw null; }
            public static Azure.Core.AzureLocation WestCentralUS { get => throw null; }
            public static Azure.Core.AzureLocation WestEurope { get => throw null; }
            public static Azure.Core.AzureLocation WestIndia { get => throw null; }
            public static Azure.Core.AzureLocation WestUS { get => throw null; }
            public static Azure.Core.AzureLocation WestUS2 { get => throw null; }
            public static Azure.Core.AzureLocation WestUS3 { get => throw null; }
        }
        public abstract class ClientOptions
        {
            public void AddPolicy(Azure.Core.Pipeline.HttpPipelinePolicy policy, Azure.Core.HttpPipelinePosition position) => throw null;
            protected ClientOptions() => throw null;
            protected ClientOptions(Azure.Core.DiagnosticsOptions diagnostics) => throw null;
            public static Azure.Core.ClientOptions Default { get => throw null; }
            public Azure.Core.DiagnosticsOptions Diagnostics { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public Azure.Core.RetryOptions Retry { get => throw null; }
            public Azure.Core.Pipeline.HttpPipelinePolicy RetryPolicy { get => throw null; set { } }
            public override string ToString() => throw null;
            public Azure.Core.Pipeline.HttpPipelineTransport Transport { get => throw null; set { } }
        }
        public struct ContentType : System.IEquatable<Azure.Core.ContentType>, System.IEquatable<string>
        {
            public static Azure.Core.ContentType ApplicationJson { get => throw null; }
            public static Azure.Core.ContentType ApplicationOctetStream { get => throw null; }
            public ContentType(string contentType) => throw null;
            public bool Equals(Azure.Core.ContentType other) => throw null;
            public bool Equals(string other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Azure.Core.ContentType left, Azure.Core.ContentType right) => throw null;
            public static implicit operator Azure.Core.ContentType(string contentType) => throw null;
            public static bool operator !=(Azure.Core.ContentType left, Azure.Core.ContentType right) => throw null;
            public static Azure.Core.ContentType TextPlain { get => throw null; }
            public override string ToString() => throw null;
        }
        namespace Cryptography
        {
            public interface IKeyEncryptionKey
            {
                string KeyId { get; }
                byte[] UnwrapKey(string algorithm, System.ReadOnlyMemory<byte> encryptedKey, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<byte[]> UnwrapKeyAsync(string algorithm, System.ReadOnlyMemory<byte> encryptedKey, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                byte[] WrapKey(string algorithm, System.ReadOnlyMemory<byte> key, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<byte[]> WrapKeyAsync(string algorithm, System.ReadOnlyMemory<byte> key, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IKeyEncryptionKeyResolver
            {
                Azure.Core.Cryptography.IKeyEncryptionKey Resolve(string keyId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<Azure.Core.Cryptography.IKeyEncryptionKey> ResolveAsync(string keyId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
        }
        public abstract class DelayStrategy
        {
            public static Azure.Core.DelayStrategy CreateExponentialDelayStrategy(System.TimeSpan? initialDelay = default(System.TimeSpan?), System.TimeSpan? maxDelay = default(System.TimeSpan?)) => throw null;
            public static Azure.Core.DelayStrategy CreateFixedDelayStrategy(System.TimeSpan? delay = default(System.TimeSpan?)) => throw null;
            protected DelayStrategy(System.TimeSpan? maxDelay = default(System.TimeSpan?), double jitterFactor = default(double)) => throw null;
            public System.TimeSpan GetNextDelay(Azure.Response response, int retryNumber) => throw null;
            protected abstract System.TimeSpan GetNextDelayCore(Azure.Response response, int retryNumber);
            protected static System.TimeSpan Max(System.TimeSpan val1, System.TimeSpan val2) => throw null;
            protected static System.TimeSpan Min(System.TimeSpan val1, System.TimeSpan val2) => throw null;
        }
        public static class DelegatedTokenCredential
        {
            public static Azure.Core.TokenCredential Create(System.Func<Azure.Core.TokenRequestContext, System.Threading.CancellationToken, Azure.Core.AccessToken> getToken, System.Func<Azure.Core.TokenRequestContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<Azure.Core.AccessToken>> getTokenAsync) => throw null;
            public static Azure.Core.TokenCredential Create(System.Func<Azure.Core.TokenRequestContext, System.Threading.CancellationToken, Azure.Core.AccessToken> getToken) => throw null;
        }
        namespace Diagnostics
        {
            public class AzureEventSourceListener : System.Diagnostics.Tracing.EventListener
            {
                public static Azure.Core.Diagnostics.AzureEventSourceListener CreateConsoleLogger(System.Diagnostics.Tracing.EventLevel level = default(System.Diagnostics.Tracing.EventLevel)) => throw null;
                public static Azure.Core.Diagnostics.AzureEventSourceListener CreateTraceLogger(System.Diagnostics.Tracing.EventLevel level = default(System.Diagnostics.Tracing.EventLevel)) => throw null;
                public AzureEventSourceListener(System.Action<System.Diagnostics.Tracing.EventWrittenEventArgs, string> log, System.Diagnostics.Tracing.EventLevel level) => throw null;
                protected override sealed void OnEventSourceCreated(System.Diagnostics.Tracing.EventSource eventSource) => throw null;
                protected override sealed void OnEventWritten(System.Diagnostics.Tracing.EventWrittenEventArgs eventData) => throw null;
                public const string TraitName = default;
                public const string TraitValue = default;
            }
        }
        public class DiagnosticsOptions
        {
            public string ApplicationId { get => throw null; set { } }
            protected DiagnosticsOptions() => throw null;
            public static string DefaultApplicationId { get => throw null; set { } }
            public bool IsDistributedTracingEnabled { get => throw null; set { } }
            public bool IsLoggingContentEnabled { get => throw null; set { } }
            public bool IsLoggingEnabled { get => throw null; set { } }
            public bool IsTelemetryEnabled { get => throw null; set { } }
            public int LoggedContentSizeLimit { get => throw null; set { } }
            public System.Collections.Generic.IList<string> LoggedHeaderNames { get => throw null; }
            public System.Collections.Generic.IList<string> LoggedQueryParameters { get => throw null; }
        }
        namespace Extensions
        {
            public interface IAzureClientBuilder<TClient, TOptions> where TOptions : class
            {
            }
            public interface IAzureClientFactoryBuilder
            {
                Azure.Core.Extensions.IAzureClientBuilder<TClient, TOptions> RegisterClientFactory<TClient, TOptions>(System.Func<TOptions, TClient> clientFactory) where TOptions : class;
            }
            public interface IAzureClientFactoryBuilderWithConfiguration<TConfiguration> : Azure.Core.Extensions.IAzureClientFactoryBuilder
            {
                Azure.Core.Extensions.IAzureClientBuilder<TClient, TOptions> RegisterClientFactory<TClient, TOptions>(TConfiguration configuration) where TOptions : class;
            }
            public interface IAzureClientFactoryBuilderWithCredential
            {
                Azure.Core.Extensions.IAzureClientBuilder<TClient, TOptions> RegisterClientFactory<TClient, TOptions>(System.Func<TOptions, Azure.Core.TokenCredential, TClient> clientFactory, bool requiresCredential = default(bool)) where TOptions : class;
            }
        }
        namespace GeoJson
        {
            public struct GeoArray<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T>
            {
                public int Count { get => throw null; }
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                {
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public T Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                }
                public Azure.Core.GeoJson.GeoArray<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                public T this[int index] { get => throw null; }
            }
            public sealed class GeoBoundingBox : System.IEquatable<Azure.Core.GeoJson.GeoBoundingBox>
            {
                public GeoBoundingBox(double west, double south, double east, double north) => throw null;
                public GeoBoundingBox(double west, double south, double east, double north, double? minAltitude, double? maxAltitude) => throw null;
                public double East { get => throw null; }
                public bool Equals(Azure.Core.GeoJson.GeoBoundingBox other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public double? MaxAltitude { get => throw null; }
                public double? MinAltitude { get => throw null; }
                public double North { get => throw null; }
                public double South { get => throw null; }
                public double this[int index] { get => throw null; }
                public override string ToString() => throw null;
                public double West { get => throw null; }
            }
            public sealed class GeoCollection : Azure.Core.GeoJson.GeoObject, System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoObject>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<Azure.Core.GeoJson.GeoObject>, System.Collections.Generic.IReadOnlyList<Azure.Core.GeoJson.GeoObject>
            {
                public int Count { get => throw null; }
                public GeoCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoObject> geometries) => throw null;
                public GeoCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoObject> geometries, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public System.Collections.Generic.IEnumerator<Azure.Core.GeoJson.GeoObject> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public Azure.Core.GeoJson.GeoObject this[int index] { get => throw null; }
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public sealed class GeoLinearRing
            {
                public Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoPosition> Coordinates { get => throw null; }
                public GeoLinearRing(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPosition> coordinates) => throw null;
            }
            public sealed class GeoLineString : Azure.Core.GeoJson.GeoObject
            {
                public Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoPosition> Coordinates { get => throw null; }
                public GeoLineString(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPosition> coordinates) => throw null;
                public GeoLineString(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPosition> coordinates, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public sealed class GeoLineStringCollection : Azure.Core.GeoJson.GeoObject, System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoLineString>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<Azure.Core.GeoJson.GeoLineString>, System.Collections.Generic.IReadOnlyList<Azure.Core.GeoJson.GeoLineString>
            {
                public Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoPosition>> Coordinates { get => throw null; }
                public int Count { get => throw null; }
                public GeoLineStringCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoLineString> lines) => throw null;
                public GeoLineStringCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoLineString> lines, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public System.Collections.Generic.IEnumerator<Azure.Core.GeoJson.GeoLineString> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public Azure.Core.GeoJson.GeoLineString this[int index] { get => throw null; }
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public abstract class GeoObject
            {
                public Azure.Core.GeoJson.GeoBoundingBox BoundingBox { get => throw null; }
                public static Azure.Core.GeoJson.GeoObject Parse(string json) => throw null;
                public override string ToString() => throw null;
                public bool TryGetCustomProperty(string name, out object value) => throw null;
                public abstract Azure.Core.GeoJson.GeoObjectType Type { get; }
            }
            public enum GeoObjectType
            {
                Point = 0,
                MultiPoint = 1,
                Polygon = 2,
                MultiPolygon = 3,
                LineString = 4,
                MultiLineString = 5,
                GeometryCollection = 6,
            }
            public sealed class GeoPoint : Azure.Core.GeoJson.GeoObject
            {
                public Azure.Core.GeoJson.GeoPosition Coordinates { get => throw null; }
                public GeoPoint(double longitude, double latitude) => throw null;
                public GeoPoint(double longitude, double latitude, double? altitude) => throw null;
                public GeoPoint(Azure.Core.GeoJson.GeoPosition position) => throw null;
                public GeoPoint(Azure.Core.GeoJson.GeoPosition position, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public sealed class GeoPointCollection : Azure.Core.GeoJson.GeoObject, System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPoint>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<Azure.Core.GeoJson.GeoPoint>, System.Collections.Generic.IReadOnlyList<Azure.Core.GeoJson.GeoPoint>
            {
                public Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoPosition> Coordinates { get => throw null; }
                public int Count { get => throw null; }
                public GeoPointCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPoint> points) => throw null;
                public GeoPointCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPoint> points, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public System.Collections.Generic.IEnumerator<Azure.Core.GeoJson.GeoPoint> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public Azure.Core.GeoJson.GeoPoint this[int index] { get => throw null; }
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public sealed class GeoPolygon : Azure.Core.GeoJson.GeoObject
            {
                public Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoPosition>> Coordinates { get => throw null; }
                public GeoPolygon(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPosition> positions) => throw null;
                public GeoPolygon(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoLinearRing> rings) => throw null;
                public GeoPolygon(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoLinearRing> rings, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public Azure.Core.GeoJson.GeoLinearRing OuterRing { get => throw null; }
                public System.Collections.Generic.IReadOnlyList<Azure.Core.GeoJson.GeoLinearRing> Rings { get => throw null; }
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public sealed class GeoPolygonCollection : Azure.Core.GeoJson.GeoObject, System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPolygon>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<Azure.Core.GeoJson.GeoPolygon>, System.Collections.Generic.IReadOnlyList<Azure.Core.GeoJson.GeoPolygon>
            {
                public Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoArray<Azure.Core.GeoJson.GeoPosition>>> Coordinates { get => throw null; }
                public int Count { get => throw null; }
                public GeoPolygonCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPolygon> polygons) => throw null;
                public GeoPolygonCollection(System.Collections.Generic.IEnumerable<Azure.Core.GeoJson.GeoPolygon> polygons, Azure.Core.GeoJson.GeoBoundingBox boundingBox, System.Collections.Generic.IReadOnlyDictionary<string, object> customProperties) => throw null;
                public System.Collections.Generic.IEnumerator<Azure.Core.GeoJson.GeoPolygon> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public Azure.Core.GeoJson.GeoPolygon this[int index] { get => throw null; }
                public override Azure.Core.GeoJson.GeoObjectType Type { get => throw null; }
            }
            public struct GeoPosition : System.IEquatable<Azure.Core.GeoJson.GeoPosition>
            {
                public double? Altitude { get => throw null; }
                public int Count { get => throw null; }
                public GeoPosition(double longitude, double latitude) => throw null;
                public GeoPosition(double longitude, double latitude, double? altitude) => throw null;
                public bool Equals(Azure.Core.GeoJson.GeoPosition other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public double Latitude { get => throw null; }
                public double Longitude { get => throw null; }
                public static bool operator ==(Azure.Core.GeoJson.GeoPosition left, Azure.Core.GeoJson.GeoPosition right) => throw null;
                public static bool operator !=(Azure.Core.GeoJson.GeoPosition left, Azure.Core.GeoJson.GeoPosition right) => throw null;
                public double this[int index] { get => throw null; }
                public override string ToString() => throw null;
            }
        }
        public struct HttpHeader : System.IEquatable<Azure.Core.HttpHeader>
        {
            public static class Common
            {
                public static readonly Azure.Core.HttpHeader FormUrlEncodedContentType;
                public static readonly Azure.Core.HttpHeader JsonAccept;
                public static readonly Azure.Core.HttpHeader JsonContentType;
                public static readonly Azure.Core.HttpHeader OctetStreamContentType;
            }
            public HttpHeader(string name, string value) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Azure.Core.HttpHeader other) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
            public static class Names
            {
                public static string Accept { get => throw null; }
                public static string Authorization { get => throw null; }
                public static string ContentDisposition { get => throw null; }
                public static string ContentLength { get => throw null; }
                public static string ContentType { get => throw null; }
                public static string Date { get => throw null; }
                public static string ETag { get => throw null; }
                public static string Host { get => throw null; }
                public static string IfMatch { get => throw null; }
                public static string IfModifiedSince { get => throw null; }
                public static string IfNoneMatch { get => throw null; }
                public static string IfUnmodifiedSince { get => throw null; }
                public static string Prefer { get => throw null; }
                public static string Range { get => throw null; }
                public static string Referer { get => throw null; }
                public static string UserAgent { get => throw null; }
                public static string WwwAuthenticate { get => throw null; }
                public static string XMsDate { get => throw null; }
                public static string XMsRange { get => throw null; }
                public static string XMsRequestId { get => throw null; }
            }
            public override string ToString() => throw null;
            public string Value { get => throw null; }
        }
        public sealed class HttpMessage : System.IDisposable
        {
            public bool BufferResponse { get => throw null; set { } }
            public System.Threading.CancellationToken CancellationToken { get => throw null; }
            public HttpMessage(Azure.Core.Request request, Azure.Core.ResponseClassifier responseClassifier) => throw null;
            public void Dispose() => throw null;
            public System.IO.Stream ExtractResponseContent() => throw null;
            public bool HasResponse { get => throw null; }
            public System.TimeSpan? NetworkTimeout { get => throw null; set { } }
            public Azure.Core.MessageProcessingContext ProcessingContext { get => throw null; }
            public Azure.Core.Request Request { get => throw null; }
            public Azure.Response Response { get => throw null; set { } }
            public Azure.Core.ResponseClassifier ResponseClassifier { get => throw null; set { } }
            public void SetProperty(string name, object value) => throw null;
            public void SetProperty(System.Type type, object value) => throw null;
            public bool TryGetProperty(string name, out object value) => throw null;
            public bool TryGetProperty(System.Type type, out object value) => throw null;
        }
        public enum HttpPipelinePosition
        {
            PerCall = 0,
            PerRetry = 1,
            BeforeTransport = 2,
        }
        public struct MessageProcessingContext
        {
            public int RetryNumber { get => throw null; set { } }
            public System.DateTimeOffset StartTime { get => throw null; }
        }
        public static class MultipartResponse
        {
            public static Azure.Response[] Parse(Azure.Response response, bool expectCrLf, System.Threading.CancellationToken cancellationToken) => throw null;
            public static System.Threading.Tasks.Task<Azure.Response[]> ParseAsync(Azure.Response response, bool expectCrLf, System.Threading.CancellationToken cancellationToken) => throw null;
        }
        namespace Pipeline
        {
            public class BearerTokenAuthenticationPolicy : Azure.Core.Pipeline.HttpPipelinePolicy
            {
                protected void AuthenticateAndAuthorizeRequest(Azure.Core.HttpMessage message, Azure.Core.TokenRequestContext context) => throw null;
                protected System.Threading.Tasks.ValueTask AuthenticateAndAuthorizeRequestAsync(Azure.Core.HttpMessage message, Azure.Core.TokenRequestContext context) => throw null;
                protected virtual void AuthorizeRequest(Azure.Core.HttpMessage message) => throw null;
                protected virtual System.Threading.Tasks.ValueTask AuthorizeRequestAsync(Azure.Core.HttpMessage message) => throw null;
                protected virtual bool AuthorizeRequestOnChallenge(Azure.Core.HttpMessage message) => throw null;
                protected virtual System.Threading.Tasks.ValueTask<bool> AuthorizeRequestOnChallengeAsync(Azure.Core.HttpMessage message) => throw null;
                public BearerTokenAuthenticationPolicy(Azure.Core.TokenCredential credential, string scope) => throw null;
                public BearerTokenAuthenticationPolicy(Azure.Core.TokenCredential credential, System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public override void Process(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                public override System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
            }
            public sealed class DisposableHttpPipeline : Azure.Core.Pipeline.HttpPipeline, System.IDisposable
            {
                public void Dispose() => throw null;
                internal DisposableHttpPipeline() : base(default(Azure.Core.Pipeline.HttpPipelineTransport), default(Azure.Core.Pipeline.HttpPipelinePolicy[]), default(Azure.Core.ResponseClassifier)) { }
            }
            public class HttpClientTransport : Azure.Core.Pipeline.HttpPipelineTransport, System.IDisposable
            {
                public override sealed Azure.Core.Request CreateRequest() => throw null;
                public HttpClientTransport() => throw null;
                public HttpClientTransport(System.Net.Http.HttpMessageHandler messageHandler) => throw null;
                public HttpClientTransport(System.Net.Http.HttpClient client) => throw null;
                public void Dispose() => throw null;
                public override void Process(Azure.Core.HttpMessage message) => throw null;
                public override System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message) => throw null;
                public static readonly Azure.Core.Pipeline.HttpClientTransport Shared;
            }
            public class HttpPipeline
            {
                public static System.IDisposable CreateClientRequestIdScope(string clientRequestId) => throw null;
                public static System.IDisposable CreateHttpMessagePropertiesScope(System.Collections.Generic.IDictionary<string, object> messageProperties) => throw null;
                public Azure.Core.HttpMessage CreateMessage() => throw null;
                public Azure.Core.HttpMessage CreateMessage(Azure.RequestContext context) => throw null;
                public Azure.Core.HttpMessage CreateMessage(Azure.RequestContext context, Azure.Core.ResponseClassifier classifier = default(Azure.Core.ResponseClassifier)) => throw null;
                public Azure.Core.Request CreateRequest() => throw null;
                public HttpPipeline(Azure.Core.Pipeline.HttpPipelineTransport transport, Azure.Core.Pipeline.HttpPipelinePolicy[] policies = default(Azure.Core.Pipeline.HttpPipelinePolicy[]), Azure.Core.ResponseClassifier responseClassifier = default(Azure.Core.ResponseClassifier)) => throw null;
                public Azure.Core.ResponseClassifier ResponseClassifier { get => throw null; }
                public void Send(Azure.Core.HttpMessage message, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.ValueTask SendAsync(Azure.Core.HttpMessage message, System.Threading.CancellationToken cancellationToken) => throw null;
                public Azure.Response SendRequest(Azure.Core.Request request, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.ValueTask<Azure.Response> SendRequestAsync(Azure.Core.Request request, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public static class HttpPipelineBuilder
            {
                public static Azure.Core.Pipeline.HttpPipeline Build(Azure.Core.ClientOptions options, params Azure.Core.Pipeline.HttpPipelinePolicy[] perRetryPolicies) => throw null;
                public static Azure.Core.Pipeline.HttpPipeline Build(Azure.Core.ClientOptions options, Azure.Core.Pipeline.HttpPipelinePolicy[] perCallPolicies, Azure.Core.Pipeline.HttpPipelinePolicy[] perRetryPolicies, Azure.Core.ResponseClassifier responseClassifier) => throw null;
                public static Azure.Core.Pipeline.DisposableHttpPipeline Build(Azure.Core.ClientOptions options, Azure.Core.Pipeline.HttpPipelinePolicy[] perCallPolicies, Azure.Core.Pipeline.HttpPipelinePolicy[] perRetryPolicies, Azure.Core.Pipeline.HttpPipelineTransportOptions transportOptions, Azure.Core.ResponseClassifier responseClassifier) => throw null;
                public static Azure.Core.Pipeline.HttpPipeline Build(Azure.Core.Pipeline.HttpPipelineOptions options) => throw null;
                public static Azure.Core.Pipeline.DisposableHttpPipeline Build(Azure.Core.Pipeline.HttpPipelineOptions options, Azure.Core.Pipeline.HttpPipelineTransportOptions transportOptions) => throw null;
            }
            public class HttpPipelineOptions
            {
                public Azure.Core.ClientOptions ClientOptions { get => throw null; }
                public HttpPipelineOptions(Azure.Core.ClientOptions options) => throw null;
                public System.Collections.Generic.IList<Azure.Core.Pipeline.HttpPipelinePolicy> PerCallPolicies { get => throw null; }
                public System.Collections.Generic.IList<Azure.Core.Pipeline.HttpPipelinePolicy> PerRetryPolicies { get => throw null; }
                public Azure.Core.RequestFailedDetailsParser RequestFailedDetailsParser { get => throw null; set { } }
                public Azure.Core.ResponseClassifier ResponseClassifier { get => throw null; set { } }
            }
            public abstract class HttpPipelinePolicy
            {
                protected HttpPipelinePolicy() => throw null;
                public abstract void Process(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline);
                public abstract System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline);
                protected static void ProcessNext(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                protected static System.Threading.Tasks.ValueTask ProcessNextAsync(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
            }
            public abstract class HttpPipelineSynchronousPolicy : Azure.Core.Pipeline.HttpPipelinePolicy
            {
                protected HttpPipelineSynchronousPolicy() => throw null;
                public virtual void OnReceivedResponse(Azure.Core.HttpMessage message) => throw null;
                public virtual void OnSendingRequest(Azure.Core.HttpMessage message) => throw null;
                public override void Process(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                public override System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
            }
            public abstract class HttpPipelineTransport
            {
                public abstract Azure.Core.Request CreateRequest();
                protected HttpPipelineTransport() => throw null;
                public abstract void Process(Azure.Core.HttpMessage message);
                public abstract System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message);
            }
            public class HttpPipelineTransportOptions
            {
                public System.Collections.Generic.IList<System.Security.Cryptography.X509Certificates.X509Certificate2> ClientCertificates { get => throw null; }
                public HttpPipelineTransportOptions() => throw null;
                public bool IsClientRedirectEnabled { get => throw null; set { } }
                public System.Func<Azure.Core.Pipeline.ServerCertificateCustomValidationArgs, bool> ServerCertificateCustomValidationCallback { get => throw null; set { } }
            }
            public sealed class RedirectPolicy : Azure.Core.Pipeline.HttpPipelinePolicy
            {
                public override void Process(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                public override System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                public static void SetAllowAutoRedirect(Azure.Core.HttpMessage message, bool allowAutoRedirect) => throw null;
            }
            public class RetryPolicy : Azure.Core.Pipeline.HttpPipelinePolicy
            {
                public RetryPolicy(int maxRetries = default(int), Azure.Core.DelayStrategy delayStrategy = default(Azure.Core.DelayStrategy)) => throw null;
                protected virtual void OnRequestSent(Azure.Core.HttpMessage message) => throw null;
                protected virtual System.Threading.Tasks.ValueTask OnRequestSentAsync(Azure.Core.HttpMessage message) => throw null;
                protected virtual void OnSendingRequest(Azure.Core.HttpMessage message) => throw null;
                protected virtual System.Threading.Tasks.ValueTask OnSendingRequestAsync(Azure.Core.HttpMessage message) => throw null;
                public override void Process(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                public override System.Threading.Tasks.ValueTask ProcessAsync(Azure.Core.HttpMessage message, System.ReadOnlyMemory<Azure.Core.Pipeline.HttpPipelinePolicy> pipeline) => throw null;
                protected virtual bool ShouldRetry(Azure.Core.HttpMessage message, System.Exception exception) => throw null;
                protected virtual System.Threading.Tasks.ValueTask<bool> ShouldRetryAsync(Azure.Core.HttpMessage message, System.Exception exception) => throw null;
            }
            public class ServerCertificateCustomValidationArgs
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                public System.Security.Cryptography.X509Certificates.X509Chain CertificateAuthorityChain { get => throw null; }
                public ServerCertificateCustomValidationArgs(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Security.Cryptography.X509Certificates.X509Chain certificateAuthorityChain, System.Net.Security.SslPolicyErrors sslPolicyErrors) => throw null;
                public System.Net.Security.SslPolicyErrors SslPolicyErrors { get => throw null; }
            }
        }
        public struct RehydrationToken : System.ClientModel.Primitives.IJsonModel<Azure.Core.RehydrationToken>, System.ClientModel.Primitives.IJsonModel<object>, System.ClientModel.Primitives.IPersistableModel<Azure.Core.RehydrationToken>, System.ClientModel.Primitives.IPersistableModel<object>
        {
            Azure.Core.RehydrationToken System.ClientModel.Primitives.IJsonModel<Azure.Core.RehydrationToken>.Create(ref System.Text.Json.Utf8JsonReader reader, System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            Azure.Core.RehydrationToken System.ClientModel.Primitives.IPersistableModel<Azure.Core.RehydrationToken>.Create(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            object System.ClientModel.Primitives.IPersistableModel<object>.Create(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            object System.ClientModel.Primitives.IJsonModel<object>.Create(ref System.Text.Json.Utf8JsonReader reader, System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            string System.ClientModel.Primitives.IPersistableModel<Azure.Core.RehydrationToken>.GetFormatFromOptions(System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            string System.ClientModel.Primitives.IPersistableModel<object>.GetFormatFromOptions(System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            public string Id { get => throw null; }
            void System.ClientModel.Primitives.IJsonModel<Azure.Core.RehydrationToken>.Write(System.Text.Json.Utf8JsonWriter writer, System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            System.BinaryData System.ClientModel.Primitives.IPersistableModel<Azure.Core.RehydrationToken>.Write(System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            System.BinaryData System.ClientModel.Primitives.IPersistableModel<object>.Write(System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
            void System.ClientModel.Primitives.IJsonModel<object>.Write(System.Text.Json.Utf8JsonWriter writer, System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
        }
        public abstract class Request : System.IDisposable
        {
            protected abstract void AddHeader(string name, string value);
            public abstract string ClientRequestId { get; set; }
            protected abstract bool ContainsHeader(string name);
            public virtual Azure.Core.RequestContent Content { get => throw null; set { } }
            protected Request() => throw null;
            public abstract void Dispose();
            protected abstract System.Collections.Generic.IEnumerable<Azure.Core.HttpHeader> EnumerateHeaders();
            public Azure.Core.RequestHeaders Headers { get => throw null; }
            public virtual Azure.Core.RequestMethod Method { get => throw null; set { } }
            protected abstract bool RemoveHeader(string name);
            protected virtual void SetHeader(string name, string value) => throw null;
            protected abstract bool TryGetHeader(string name, out string value);
            protected abstract bool TryGetHeaderValues(string name, out System.Collections.Generic.IEnumerable<string> values);
            public virtual Azure.Core.RequestUriBuilder Uri { get => throw null; set { } }
        }
        public abstract class RequestContent : System.IDisposable
        {
            public static Azure.Core.RequestContent Create(System.IO.Stream stream) => throw null;
            public static Azure.Core.RequestContent Create(byte[] bytes) => throw null;
            public static Azure.Core.RequestContent Create(byte[] bytes, int index, int length) => throw null;
            public static Azure.Core.RequestContent Create(System.ReadOnlyMemory<byte> bytes) => throw null;
            public static Azure.Core.RequestContent Create(System.Buffers.ReadOnlySequence<byte> bytes) => throw null;
            public static Azure.Core.RequestContent Create(string content) => throw null;
            public static Azure.Core.RequestContent Create(System.BinaryData content) => throw null;
            public static Azure.Core.RequestContent Create(Azure.Core.Serialization.DynamicData content) => throw null;
            public static Azure.Core.RequestContent Create(object serializable) => throw null;
            public static Azure.Core.RequestContent Create(object serializable, Azure.Core.Serialization.ObjectSerializer serializer) => throw null;
            public static Azure.Core.RequestContent Create(object serializable, Azure.Core.Serialization.JsonPropertyNames propertyNameFormat, string dateTimeFormat = default(string)) => throw null;
            protected RequestContent() => throw null;
            public abstract void Dispose();
            public static implicit operator Azure.Core.RequestContent(string content) => throw null;
            public static implicit operator Azure.Core.RequestContent(System.BinaryData content) => throw null;
            public static implicit operator Azure.Core.RequestContent(Azure.Core.Serialization.DynamicData content) => throw null;
            public abstract bool TryComputeLength(out long length);
            public abstract void WriteTo(System.IO.Stream stream, System.Threading.CancellationToken cancellation);
            public abstract System.Threading.Tasks.Task WriteToAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellation);
        }
        public abstract class RequestFailedDetailsParser
        {
            protected RequestFailedDetailsParser() => throw null;
            public abstract bool TryParse(Azure.Response response, out Azure.ResponseError error, out System.Collections.Generic.IDictionary<string, string> data);
        }
        public struct RequestHeaders : System.Collections.Generic.IEnumerable<Azure.Core.HttpHeader>, System.Collections.IEnumerable
        {
            public void Add(Azure.Core.HttpHeader header) => throw null;
            public void Add(string name, string value) => throw null;
            public bool Contains(string name) => throw null;
            public System.Collections.Generic.IEnumerator<Azure.Core.HttpHeader> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public bool Remove(string name) => throw null;
            public void SetValue(string name, string value) => throw null;
            public bool TryGetValue(string name, out string value) => throw null;
            public bool TryGetValues(string name, out System.Collections.Generic.IEnumerable<string> values) => throw null;
        }
        public struct RequestMethod : System.IEquatable<Azure.Core.RequestMethod>
        {
            public RequestMethod(string method) => throw null;
            public static Azure.Core.RequestMethod Delete { get => throw null; }
            public bool Equals(Azure.Core.RequestMethod other) => throw null;
            public override bool Equals(object obj) => throw null;
            public static Azure.Core.RequestMethod Get { get => throw null; }
            public override int GetHashCode() => throw null;
            public static Azure.Core.RequestMethod Head { get => throw null; }
            public string Method { get => throw null; }
            public static bool operator ==(Azure.Core.RequestMethod left, Azure.Core.RequestMethod right) => throw null;
            public static bool operator !=(Azure.Core.RequestMethod left, Azure.Core.RequestMethod right) => throw null;
            public static Azure.Core.RequestMethod Options { get => throw null; }
            public static Azure.Core.RequestMethod Parse(string method) => throw null;
            public static Azure.Core.RequestMethod Patch { get => throw null; }
            public static Azure.Core.RequestMethod Post { get => throw null; }
            public static Azure.Core.RequestMethod Put { get => throw null; }
            public override string ToString() => throw null;
            public static Azure.Core.RequestMethod Trace { get => throw null; }
        }
        public class RequestUriBuilder
        {
            public void AppendPath(string value) => throw null;
            public void AppendPath(string value, bool escape) => throw null;
            public void AppendPath(System.ReadOnlySpan<char> value, bool escape) => throw null;
            public void AppendQuery(string name, string value) => throw null;
            public void AppendQuery(string name, string value, bool escapeValue) => throw null;
            public void AppendQuery(System.ReadOnlySpan<char> name, System.ReadOnlySpan<char> value, bool escapeValue) => throw null;
            public RequestUriBuilder() => throw null;
            protected bool HasPath { get => throw null; }
            protected bool HasQuery { get => throw null; }
            public string Host { get => throw null; set { } }
            public string Path { get => throw null; set { } }
            public string PathAndQuery { get => throw null; }
            public int Port { get => throw null; set { } }
            public string Query { get => throw null; set { } }
            public void Reset(System.Uri value) => throw null;
            public string Scheme { get => throw null; set { } }
            public override string ToString() => throw null;
            public System.Uri ToUri() => throw null;
        }
        public sealed class ResourceIdentifier : System.IComparable<Azure.Core.ResourceIdentifier>, System.IEquatable<Azure.Core.ResourceIdentifier>
        {
            public Azure.Core.ResourceIdentifier AppendChildResource(string childResourceType, string childResourceName) => throw null;
            public Azure.Core.ResourceIdentifier AppendProviderResource(string providerNamespace, string resourceType, string resourceName) => throw null;
            public int CompareTo(Azure.Core.ResourceIdentifier other) => throw null;
            public ResourceIdentifier(string resourceId) => throw null;
            public bool Equals(Azure.Core.ResourceIdentifier other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public Azure.Core.AzureLocation? Location { get => throw null; }
            public string Name { get => throw null; }
            public static bool operator ==(Azure.Core.ResourceIdentifier left, Azure.Core.ResourceIdentifier right) => throw null;
            public static bool operator >(Azure.Core.ResourceIdentifier left, Azure.Core.ResourceIdentifier right) => throw null;
            public static bool operator >=(Azure.Core.ResourceIdentifier left, Azure.Core.ResourceIdentifier right) => throw null;
            public static implicit operator string(Azure.Core.ResourceIdentifier id) => throw null;
            public static bool operator !=(Azure.Core.ResourceIdentifier left, Azure.Core.ResourceIdentifier right) => throw null;
            public static bool operator <(Azure.Core.ResourceIdentifier left, Azure.Core.ResourceIdentifier right) => throw null;
            public static bool operator <=(Azure.Core.ResourceIdentifier left, Azure.Core.ResourceIdentifier right) => throw null;
            public Azure.Core.ResourceIdentifier Parent { get => throw null; }
            public static Azure.Core.ResourceIdentifier Parse(string input) => throw null;
            public string Provider { get => throw null; }
            public string ResourceGroupName { get => throw null; }
            public Azure.Core.ResourceType ResourceType { get => throw null; }
            public static readonly Azure.Core.ResourceIdentifier Root;
            public string SubscriptionId { get => throw null; }
            public override string ToString() => throw null;
            public static bool TryParse(string input, out Azure.Core.ResourceIdentifier result) => throw null;
        }
        public struct ResourceType : System.IEquatable<Azure.Core.ResourceType>
        {
            public ResourceType(string resourceType) => throw null;
            public bool Equals(Azure.Core.ResourceType other) => throw null;
            public override bool Equals(object other) => throw null;
            public override int GetHashCode() => throw null;
            public string GetLastType() => throw null;
            public string Namespace { get => throw null; }
            public static bool operator ==(Azure.Core.ResourceType left, Azure.Core.ResourceType right) => throw null;
            public static implicit operator Azure.Core.ResourceType(string resourceType) => throw null;
            public static implicit operator string(Azure.Core.ResourceType resourceType) => throw null;
            public static bool operator !=(Azure.Core.ResourceType left, Azure.Core.ResourceType right) => throw null;
            public override string ToString() => throw null;
            public string Type { get => throw null; }
        }
        public abstract class ResponseClassificationHandler
        {
            protected ResponseClassificationHandler() => throw null;
            public abstract bool TryClassify(Azure.Core.HttpMessage message, out bool isError);
        }
        public class ResponseClassifier
        {
            public ResponseClassifier() => throw null;
            public virtual bool IsErrorResponse(Azure.Core.HttpMessage message) => throw null;
            public virtual bool IsRetriable(Azure.Core.HttpMessage message, System.Exception exception) => throw null;
            public virtual bool IsRetriableException(System.Exception exception) => throw null;
            public virtual bool IsRetriableResponse(Azure.Core.HttpMessage message) => throw null;
        }
        public struct ResponseHeaders : System.Collections.Generic.IEnumerable<Azure.Core.HttpHeader>, System.Collections.IEnumerable
        {
            public bool Contains(string name) => throw null;
            public int? ContentLength { get => throw null; }
            public long? ContentLengthLong { get => throw null; }
            public string ContentType { get => throw null; }
            public System.DateTimeOffset? Date { get => throw null; }
            public Azure.ETag? ETag { get => throw null; }
            public System.Collections.Generic.IEnumerator<Azure.Core.HttpHeader> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public string RequestId { get => throw null; }
            public bool TryGetValue(string name, out string value) => throw null;
            public bool TryGetValues(string name, out System.Collections.Generic.IEnumerable<string> values) => throw null;
        }
        public enum RetryMode
        {
            Fixed = 0,
            Exponential = 1,
        }
        public class RetryOptions
        {
            public System.TimeSpan Delay { get => throw null; set { } }
            public System.TimeSpan MaxDelay { get => throw null; set { } }
            public int MaxRetries { get => throw null; set { } }
            public Azure.Core.RetryMode Mode { get => throw null; set { } }
            public System.TimeSpan NetworkTimeout { get => throw null; set { } }
        }
        namespace Serialization
        {
            public sealed class DynamicData : System.IDisposable, System.Dynamic.IDynamicMetaObjectProvider
            {
                public void Dispose() => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                System.Dynamic.DynamicMetaObject System.Dynamic.IDynamicMetaObjectProvider.GetMetaObject(System.Linq.Expressions.Expression parameter) => throw null;
                public static bool operator ==(Azure.Core.Serialization.DynamicData left, object right) => throw null;
                public static explicit operator System.DateTime(Azure.Core.Serialization.DynamicData value) => throw null;
                public static explicit operator System.DateTimeOffset(Azure.Core.Serialization.DynamicData value) => throw null;
                public static explicit operator System.Guid(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator bool(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator string(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator byte(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator sbyte(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator short(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator ushort(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator int(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator uint(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator long(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator ulong(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator float(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator double(Azure.Core.Serialization.DynamicData value) => throw null;
                public static implicit operator decimal(Azure.Core.Serialization.DynamicData value) => throw null;
                public static bool operator !=(Azure.Core.Serialization.DynamicData left, object right) => throw null;
                public override string ToString() => throw null;
            }
            public interface IMemberNameConverter
            {
                string ConvertMemberName(System.Reflection.MemberInfo member);
            }
            public class JsonObjectSerializer : Azure.Core.Serialization.ObjectSerializer, Azure.Core.Serialization.IMemberNameConverter
            {
                string Azure.Core.Serialization.IMemberNameConverter.ConvertMemberName(System.Reflection.MemberInfo member) => throw null;
                public JsonObjectSerializer() => throw null;
                public JsonObjectSerializer(System.Text.Json.JsonSerializerOptions options) => throw null;
                public static Azure.Core.Serialization.JsonObjectSerializer Default { get => throw null; }
                public override object Deserialize(System.IO.Stream stream, System.Type returnType, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream stream, System.Type returnType, System.Threading.CancellationToken cancellationToken) => throw null;
                public override void Serialize(System.IO.Stream stream, object value, System.Type inputType, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.BinaryData Serialize(object value, System.Type inputType = default(System.Type), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override System.Threading.Tasks.ValueTask SerializeAsync(System.IO.Stream stream, object value, System.Type inputType, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<System.BinaryData> SerializeAsync(object value, System.Type inputType = default(System.Type), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public enum JsonPropertyNames
            {
                UseExact = 0,
                CamelCase = 1,
            }
            public abstract class ObjectSerializer
            {
                protected ObjectSerializer() => throw null;
                public abstract object Deserialize(System.IO.Stream stream, System.Type returnType, System.Threading.CancellationToken cancellationToken);
                public abstract System.Threading.Tasks.ValueTask<object> DeserializeAsync(System.IO.Stream stream, System.Type returnType, System.Threading.CancellationToken cancellationToken);
                public abstract void Serialize(System.IO.Stream stream, object value, System.Type inputType, System.Threading.CancellationToken cancellationToken);
                public virtual System.BinaryData Serialize(object value, System.Type inputType = default(System.Type), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract System.Threading.Tasks.ValueTask SerializeAsync(System.IO.Stream stream, object value, System.Type inputType, System.Threading.CancellationToken cancellationToken);
                public virtual System.Threading.Tasks.ValueTask<System.BinaryData> SerializeAsync(object value, System.Type inputType = default(System.Type), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
        }
        public class StatusCodeClassifier : Azure.Core.ResponseClassifier
        {
            public StatusCodeClassifier(System.ReadOnlySpan<ushort> successStatusCodes) => throw null;
            public override bool IsErrorResponse(Azure.Core.HttpMessage message) => throw null;
        }
        public delegate System.Threading.Tasks.Task SyncAsyncEventHandler<T>(T e) where T : Azure.SyncAsyncEventArgs;
        public class TelemetryDetails
        {
            public string ApplicationId { get => throw null; }
            public void Apply(Azure.Core.HttpMessage message) => throw null;
            public System.Reflection.Assembly Assembly { get => throw null; }
            public TelemetryDetails(System.Reflection.Assembly assembly, string applicationId = default(string)) => throw null;
            public override string ToString() => throw null;
        }
        public abstract class TokenCredential
        {
            protected TokenCredential() => throw null;
            public abstract Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken);
            public abstract System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken);
        }
        public struct TokenRequestContext
        {
            public string Claims { get => throw null; }
            public TokenRequestContext(string[] scopes, string parentRequestId) => throw null;
            public TokenRequestContext(string[] scopes, string parentRequestId, string claims) => throw null;
            public TokenRequestContext(string[] scopes, string parentRequestId, string claims, string tenantId) => throw null;
            public TokenRequestContext(string[] scopes, string parentRequestId = default(string), string claims = default(string), string tenantId = default(string), bool isCaeEnabled = default(bool)) => throw null;
            public bool IsCaeEnabled { get => throw null; }
            public string ParentRequestId { get => throw null; }
            public string[] Scopes { get => throw null; }
            public string TenantId { get => throw null; }
        }
    }
    [System.Flags]
    public enum ErrorOptions
    {
        Default = 0,
        NoThrow = 1,
    }
    public struct ETag : System.IEquatable<Azure.ETag>
    {
        public static readonly Azure.ETag All;
        public ETag(string etag) => throw null;
        public bool Equals(Azure.ETag other) => throw null;
        public bool Equals(string other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public static bool operator ==(Azure.ETag left, Azure.ETag right) => throw null;
        public static bool operator !=(Azure.ETag left, Azure.ETag right) => throw null;
        public override string ToString() => throw null;
        public string ToString(string format) => throw null;
    }
    public class HttpAuthorization
    {
        public HttpAuthorization(string scheme, string parameter) => throw null;
        public string Parameter { get => throw null; }
        public string Scheme { get => throw null; }
        public override string ToString() => throw null;
    }
    public struct HttpRange : System.IEquatable<Azure.HttpRange>
    {
        public HttpRange(long offset = default(long), long? length = default(long?)) => throw null;
        public bool Equals(Azure.HttpRange other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public long? Length { get => throw null; }
        public long Offset { get => throw null; }
        public static bool operator ==(Azure.HttpRange left, Azure.HttpRange right) => throw null;
        public static bool operator !=(Azure.HttpRange left, Azure.HttpRange right) => throw null;
        public override string ToString() => throw null;
    }
    public class JsonPatchDocument
    {
        public void AppendAdd<T>(string path, T value) => throw null;
        public void AppendAddRaw(string path, string rawJsonValue) => throw null;
        public void AppendCopy(string from, string path) => throw null;
        public void AppendMove(string from, string path) => throw null;
        public void AppendRemove(string path) => throw null;
        public void AppendReplace<T>(string path, T value) => throw null;
        public void AppendReplaceRaw(string path, string rawJsonValue) => throw null;
        public void AppendTest<T>(string path, T value) => throw null;
        public void AppendTestRaw(string path, string rawJsonValue) => throw null;
        public JsonPatchDocument() => throw null;
        public JsonPatchDocument(Azure.Core.Serialization.ObjectSerializer serializer) => throw null;
        public JsonPatchDocument(System.ReadOnlyMemory<byte> rawDocument) => throw null;
        public JsonPatchDocument(System.ReadOnlyMemory<byte> rawDocument, Azure.Core.Serialization.ObjectSerializer serializer) => throw null;
        public System.ReadOnlyMemory<byte> ToBytes() => throw null;
        public override string ToString() => throw null;
    }
    public class MatchConditions
    {
        public MatchConditions() => throw null;
        public Azure.ETag? IfMatch { get => throw null; set { } }
        public Azure.ETag? IfNoneMatch { get => throw null; set { } }
    }
    namespace Messaging
    {
        public class CloudEvent
        {
            public CloudEvent(string source, string type, object jsonSerializableData, System.Type dataSerializationType = default(System.Type)) => throw null;
            public CloudEvent(string source, string type, System.BinaryData data, string dataContentType, Azure.Messaging.CloudEventDataFormat dataFormat = default(Azure.Messaging.CloudEventDataFormat)) => throw null;
            public System.BinaryData Data { get => throw null; set { } }
            public string DataContentType { get => throw null; set { } }
            public string DataSchema { get => throw null; set { } }
            public System.Collections.Generic.IDictionary<string, object> ExtensionAttributes { get => throw null; }
            public string Id { get => throw null; set { } }
            public static Azure.Messaging.CloudEvent Parse(System.BinaryData json, bool skipValidation = default(bool)) => throw null;
            public static Azure.Messaging.CloudEvent[] ParseMany(System.BinaryData json, bool skipValidation = default(bool)) => throw null;
            public string Source { get => throw null; set { } }
            public string Subject { get => throw null; set { } }
            public System.DateTimeOffset? Time { get => throw null; set { } }
            public string Type { get => throw null; set { } }
        }
        public enum CloudEventDataFormat
        {
            Binary = 0,
            Json = 1,
        }
        public class MessageContent
        {
            public virtual Azure.Core.ContentType? ContentType { get => throw null; set { } }
            protected virtual Azure.Core.ContentType? ContentTypeCore { get => throw null; set { } }
            public MessageContent() => throw null;
            public virtual System.BinaryData Data { get => throw null; set { } }
            public virtual bool IsReadOnly { get => throw null; }
        }
    }
    public abstract class NullableResponse<T>
    {
        protected NullableResponse() => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public abstract Azure.Response GetRawResponse();
        public abstract bool HasValue { get; }
        public override string ToString() => throw null;
        public abstract T Value { get; }
    }
    public abstract class Operation
    {
        protected Operation() => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public abstract Azure.Response GetRawResponse();
        public virtual Azure.Core.RehydrationToken? GetRehydrationToken() => throw null;
        public abstract bool HasCompleted { get; }
        public abstract string Id { get; }
        public override string ToString() => throw null;
        public abstract Azure.Response UpdateStatus(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        public abstract System.Threading.Tasks.ValueTask<Azure.Response> UpdateStatusAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        public virtual Azure.Response WaitForCompletionResponse(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual Azure.Response WaitForCompletionResponse(System.TimeSpan pollingInterval, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual Azure.Response WaitForCompletionResponse(Azure.Core.DelayStrategy delayStrategy, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.ValueTask<Azure.Response> WaitForCompletionResponseAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.ValueTask<Azure.Response> WaitForCompletionResponseAsync(System.TimeSpan pollingInterval, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.ValueTask<Azure.Response> WaitForCompletionResponseAsync(Azure.Core.DelayStrategy delayStrategy, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
    }
    public abstract class Operation<T> : Azure.Operation
    {
        protected Operation() => throw null;
        public abstract bool HasValue { get; }
        public abstract T Value { get; }
        public virtual Azure.Response<T> WaitForCompletion(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual Azure.Response<T> WaitForCompletion(System.TimeSpan pollingInterval, System.Threading.CancellationToken cancellationToken) => throw null;
        public virtual Azure.Response<T> WaitForCompletion(Azure.Core.DelayStrategy delayStrategy, System.Threading.CancellationToken cancellationToken) => throw null;
        public virtual System.Threading.Tasks.ValueTask<Azure.Response<T>> WaitForCompletionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.ValueTask<Azure.Response<T>> WaitForCompletionAsync(System.TimeSpan pollingInterval, System.Threading.CancellationToken cancellationToken) => throw null;
        public virtual System.Threading.Tasks.ValueTask<Azure.Response<T>> WaitForCompletionAsync(Azure.Core.DelayStrategy delayStrategy, System.Threading.CancellationToken cancellationToken) => throw null;
        public override System.Threading.Tasks.ValueTask<Azure.Response> WaitForCompletionResponseAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public override System.Threading.Tasks.ValueTask<Azure.Response> WaitForCompletionResponseAsync(System.TimeSpan pollingInterval, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
    }
    public abstract class Page<T>
    {
        public abstract string ContinuationToken { get; }
        protected Page() => throw null;
        public override bool Equals(object obj) => throw null;
        public static Azure.Page<T> FromValues(System.Collections.Generic.IReadOnlyList<T> values, string continuationToken, Azure.Response response) => throw null;
        public override int GetHashCode() => throw null;
        public abstract Azure.Response GetRawResponse();
        public override string ToString() => throw null;
        public abstract System.Collections.Generic.IReadOnlyList<T> Values { get; }
    }
    public abstract class Pageable<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
    {
        public abstract System.Collections.Generic.IEnumerable<Azure.Page<T>> AsPages(string continuationToken = default(string), int? pageSizeHint = default(int?));
        protected virtual System.Threading.CancellationToken CancellationToken { get => throw null; }
        protected Pageable() => throw null;
        protected Pageable(System.Threading.CancellationToken cancellationToken) => throw null;
        public override bool Equals(object obj) => throw null;
        public static Azure.Pageable<T> FromPages(System.Collections.Generic.IEnumerable<Azure.Page<T>> pages) => throw null;
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
        public virtual System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
        public override int GetHashCode() => throw null;
        public override string ToString() => throw null;
    }
    public abstract class PageableOperation<T> : Azure.Operation<Azure.AsyncPageable<T>>
    {
        protected PageableOperation() => throw null;
        public abstract Azure.Pageable<T> GetValues(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        public abstract Azure.AsyncPageable<T> GetValuesAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        public override Azure.AsyncPageable<T> Value { get => throw null; }
    }
    public class RequestConditions : Azure.MatchConditions
    {
        public RequestConditions() => throw null;
        public System.DateTimeOffset? IfModifiedSince { get => throw null; set { } }
        public System.DateTimeOffset? IfUnmodifiedSince { get => throw null; set { } }
    }
    public class RequestContext
    {
        public void AddClassifier(int statusCode, bool isError) => throw null;
        public void AddClassifier(Azure.Core.ResponseClassificationHandler classifier) => throw null;
        public void AddPolicy(Azure.Core.Pipeline.HttpPipelinePolicy policy, Azure.Core.HttpPipelinePosition position) => throw null;
        public System.Threading.CancellationToken CancellationToken { get => throw null; set { } }
        public RequestContext() => throw null;
        public Azure.ErrorOptions ErrorOptions { get => throw null; set { } }
        public static implicit operator Azure.RequestContext(Azure.ErrorOptions options) => throw null;
    }
    public class RequestFailedException : System.Exception, System.Runtime.Serialization.ISerializable
    {
        public RequestFailedException(string message) => throw null;
        public RequestFailedException(string message, System.Exception innerException) => throw null;
        public RequestFailedException(int status, string message) => throw null;
        public RequestFailedException(int status, string message, System.Exception innerException) => throw null;
        public RequestFailedException(int status, string message, string errorCode, System.Exception innerException) => throw null;
        public RequestFailedException(Azure.Response response) => throw null;
        public RequestFailedException(Azure.Response response, System.Exception innerException) => throw null;
        public RequestFailedException(Azure.Response response, System.Exception innerException, Azure.Core.RequestFailedDetailsParser detailsParser) => throw null;
        protected RequestFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public string ErrorCode { get => throw null; }
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public Azure.Response GetRawResponse() => throw null;
        public int Status { get => throw null; }
    }
    public abstract class Response : System.IDisposable
    {
        public abstract string ClientRequestId { get; set; }
        protected abstract bool ContainsHeader(string name);
        public virtual System.BinaryData Content { get => throw null; }
        public abstract System.IO.Stream ContentStream { get; set; }
        protected Response() => throw null;
        public abstract void Dispose();
        protected abstract System.Collections.Generic.IEnumerable<Azure.Core.HttpHeader> EnumerateHeaders();
        public static Azure.Response<T> FromValue<T>(T value, Azure.Response response) => throw null;
        public virtual Azure.Core.ResponseHeaders Headers { get => throw null; }
        public virtual bool IsError { get => throw null; set { } }
        public abstract string ReasonPhrase { get; }
        public abstract int Status { get; }
        public override string ToString() => throw null;
        protected abstract bool TryGetHeader(string name, out string value);
        protected abstract bool TryGetHeaderValues(string name, out System.Collections.Generic.IEnumerable<string> values);
    }
    public abstract class Response<T> : Azure.NullableResponse<T>
    {
        protected Response() => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public override bool HasValue { get => throw null; }
        public static implicit operator T(Azure.Response<T> response) => throw null;
        public override T Value { get => throw null; }
    }
    public sealed class ResponseError
    {
        public string Code { get => throw null; }
        public ResponseError(string code, string message) => throw null;
        public string Message { get => throw null; }
        public override string ToString() => throw null;
    }
    public class SyncAsyncEventArgs : System.EventArgs
    {
        public System.Threading.CancellationToken CancellationToken { get => throw null; }
        public SyncAsyncEventArgs(bool isRunningSynchronously, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        public bool IsRunningSynchronously { get => throw null; }
    }
    public enum WaitUntil
    {
        Completed = 0,
        Started = 1,
    }
}
