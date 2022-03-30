// This file contains auto-generated code.

namespace Microsoft
{
    namespace Net
    {
        namespace Http
        {
            namespace Headers
            {
                // Generated from `Microsoft.Net.Http.Headers.CacheControlHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CacheControlHeaderValue
                {
                    public CacheControlHeaderValue() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> Extensions { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public System.TimeSpan? MaxAge { get => throw null; set => throw null; }
                    public static string MaxAgeString;
                    public bool MaxStale { get => throw null; set => throw null; }
                    public System.TimeSpan? MaxStaleLimit { get => throw null; set => throw null; }
                    public static string MaxStaleString;
                    public System.TimeSpan? MinFresh { get => throw null; set => throw null; }
                    public static string MinFreshString;
                    public bool MustRevalidate { get => throw null; set => throw null; }
                    public static string MustRevalidateString;
                    public bool NoCache { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<Microsoft.Extensions.Primitives.StringSegment> NoCacheHeaders { get => throw null; }
                    public static string NoCacheString;
                    public bool NoStore { get => throw null; set => throw null; }
                    public static string NoStoreString;
                    public bool NoTransform { get => throw null; set => throw null; }
                    public static string NoTransformString;
                    public bool OnlyIfCached { get => throw null; set => throw null; }
                    public static string OnlyIfCachedString;
                    public static Microsoft.Net.Http.Headers.CacheControlHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public bool Private { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<Microsoft.Extensions.Primitives.StringSegment> PrivateHeaders { get => throw null; }
                    public static string PrivateString;
                    public bool ProxyRevalidate { get => throw null; set => throw null; }
                    public static string ProxyRevalidateString;
                    public bool Public { get => throw null; set => throw null; }
                    public static string PublicString;
                    public System.TimeSpan? SharedMaxAge { get => throw null; set => throw null; }
                    public static string SharedMaxAgeString;
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.CacheControlHeaderValue parsedValue) => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.ContentDispositionHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ContentDispositionHeaderValue
                {
                    public ContentDispositionHeaderValue(Microsoft.Extensions.Primitives.StringSegment dispositionType) => throw null;
                    public System.DateTimeOffset? CreationDate { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment DispositionType { get => throw null; set => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment FileName { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment FileNameStar { get => throw null; set => throw null; }
                    public override int GetHashCode() => throw null;
                    public System.DateTimeOffset? ModificationDate { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Name { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> Parameters { get => throw null; }
                    public static Microsoft.Net.Http.Headers.ContentDispositionHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public System.DateTimeOffset? ReadDate { get => throw null; set => throw null; }
                    public void SetHttpFileName(Microsoft.Extensions.Primitives.StringSegment fileName) => throw null;
                    public void SetMimeFileName(Microsoft.Extensions.Primitives.StringSegment fileName) => throw null;
                    public System.Int64? Size { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.ContentDispositionHeaderValue parsedValue) => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.ContentDispositionHeaderValueIdentityExtensions` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ContentDispositionHeaderValueIdentityExtensions
                {
                    public static bool IsFileDisposition(this Microsoft.Net.Http.Headers.ContentDispositionHeaderValue header) => throw null;
                    public static bool IsFormDisposition(this Microsoft.Net.Http.Headers.ContentDispositionHeaderValue header) => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.ContentRangeHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ContentRangeHeaderValue
                {
                    public ContentRangeHeaderValue(System.Int64 length) => throw null;
                    public ContentRangeHeaderValue(System.Int64 from, System.Int64 to, System.Int64 length) => throw null;
                    public ContentRangeHeaderValue(System.Int64 from, System.Int64 to) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Int64? From { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public bool HasLength { get => throw null; }
                    public bool HasRange { get => throw null; }
                    public System.Int64? Length { get => throw null; }
                    public static Microsoft.Net.Http.Headers.ContentRangeHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public System.Int64? To { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.ContentRangeHeaderValue parsedValue) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Unit { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.CookieHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieHeaderValue
                {
                    public CookieHeaderValue(Microsoft.Extensions.Primitives.StringSegment name, Microsoft.Extensions.Primitives.StringSegment value) => throw null;
                    public CookieHeaderValue(Microsoft.Extensions.Primitives.StringSegment name) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Name { get => throw null; set => throw null; }
                    public static Microsoft.Net.Http.Headers.CookieHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.CookieHeaderValue> ParseList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.CookieHeaderValue> ParseStrictList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.CookieHeaderValue parsedValue) => throw null;
                    public static bool TryParseList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.CookieHeaderValue> parsedValues) => throw null;
                    public static bool TryParseStrictList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.CookieHeaderValue> parsedValues) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Value { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.EntityTagHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EntityTagHeaderValue
                {
                    public static Microsoft.Net.Http.Headers.EntityTagHeaderValue Any { get => throw null; }
                    public bool Compare(Microsoft.Net.Http.Headers.EntityTagHeaderValue other, bool useStrongComparison) => throw null;
                    public EntityTagHeaderValue(Microsoft.Extensions.Primitives.StringSegment tag, bool isWeak) => throw null;
                    public EntityTagHeaderValue(Microsoft.Extensions.Primitives.StringSegment tag) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsWeak { get => throw null; }
                    public static Microsoft.Net.Http.Headers.EntityTagHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> ParseList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> ParseStrictList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Tag { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.EntityTagHeaderValue parsedValue) => throw null;
                    public static bool TryParseList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> parsedValues) => throw null;
                    public static bool TryParseStrictList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.EntityTagHeaderValue> parsedValues) => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.HeaderNames` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HeaderNames
                {
                    public static string Accept;
                    public static string AcceptCharset;
                    public static string AcceptEncoding;
                    public static string AcceptLanguage;
                    public static string AcceptRanges;
                    public static string AccessControlAllowCredentials;
                    public static string AccessControlAllowHeaders;
                    public static string AccessControlAllowMethods;
                    public static string AccessControlAllowOrigin;
                    public static string AccessControlExposeHeaders;
                    public static string AccessControlMaxAge;
                    public static string AccessControlRequestHeaders;
                    public static string AccessControlRequestMethod;
                    public static string Age;
                    public static string Allow;
                    public static string AltSvc;
                    public static string Authority;
                    public static string Authorization;
                    public static string CacheControl;
                    public static string Connection;
                    public static string ContentDisposition;
                    public static string ContentEncoding;
                    public static string ContentLanguage;
                    public static string ContentLength;
                    public static string ContentLocation;
                    public static string ContentMD5;
                    public static string ContentRange;
                    public static string ContentSecurityPolicy;
                    public static string ContentSecurityPolicyReportOnly;
                    public static string ContentType;
                    public static string Cookie;
                    public static string CorrelationContext;
                    public static string DNT;
                    public static string Date;
                    public static string ETag;
                    public static string Expect;
                    public static string Expires;
                    public static string From;
                    public static string GrpcAcceptEncoding;
                    public static string GrpcEncoding;
                    public static string GrpcMessage;
                    public static string GrpcStatus;
                    public static string GrpcTimeout;
                    public static string Host;
                    public static string IfMatch;
                    public static string IfModifiedSince;
                    public static string IfNoneMatch;
                    public static string IfRange;
                    public static string IfUnmodifiedSince;
                    public static string KeepAlive;
                    public static string LastModified;
                    public static string Location;
                    public static string MaxForwards;
                    public static string Method;
                    public static string Origin;
                    public static string Path;
                    public static string Pragma;
                    public static string ProxyAuthenticate;
                    public static string ProxyAuthorization;
                    public static string Range;
                    public static string Referer;
                    public static string RequestId;
                    public static string RetryAfter;
                    public static string Scheme;
                    public static string SecWebSocketAccept;
                    public static string SecWebSocketKey;
                    public static string SecWebSocketProtocol;
                    public static string SecWebSocketVersion;
                    public static string Server;
                    public static string SetCookie;
                    public static string Status;
                    public static string StrictTransportSecurity;
                    public static string TE;
                    public static string TraceParent;
                    public static string TraceState;
                    public static string Trailer;
                    public static string TransferEncoding;
                    public static string Translate;
                    public static string Upgrade;
                    public static string UpgradeInsecureRequests;
                    public static string UserAgent;
                    public static string Vary;
                    public static string Via;
                    public static string WWWAuthenticate;
                    public static string Warning;
                    public static string WebSocketSubProtocols;
                    public static string XFrameOptions;
                    public static string XRequestedWith;
                }

                // Generated from `Microsoft.Net.Http.Headers.HeaderQuality` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HeaderQuality
                {
                    public const double Match = default;
                    public const double NoMatch = default;
                }

                // Generated from `Microsoft.Net.Http.Headers.HeaderUtilities` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HeaderUtilities
                {
                    public static bool ContainsCacheDirective(Microsoft.Extensions.Primitives.StringValues cacheControlDirectives, string targetDirectives) => throw null;
                    public static Microsoft.Extensions.Primitives.StringSegment EscapeAsQuotedString(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static string FormatDate(System.DateTimeOffset dateTime, bool quoted) => throw null;
                    public static string FormatDate(System.DateTimeOffset dateTime) => throw null;
                    public static string FormatNonNegativeInt64(System.Int64 value) => throw null;
                    public static bool IsQuoted(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static Microsoft.Extensions.Primitives.StringSegment RemoveQuotes(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static bool TryParseDate(Microsoft.Extensions.Primitives.StringSegment input, out System.DateTimeOffset result) => throw null;
                    public static bool TryParseNonNegativeInt32(Microsoft.Extensions.Primitives.StringSegment value, out int result) => throw null;
                    public static bool TryParseNonNegativeInt64(Microsoft.Extensions.Primitives.StringSegment value, out System.Int64 result) => throw null;
                    public static bool TryParseSeconds(Microsoft.Extensions.Primitives.StringValues headerValues, string targetValue, out System.TimeSpan? value) => throw null;
                    public static Microsoft.Extensions.Primitives.StringSegment UnescapeAsQuotedString(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.MediaTypeHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MediaTypeHeaderValue
                {
                    public Microsoft.Extensions.Primitives.StringSegment Boundary { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Charset { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.MediaTypeHeaderValue Copy() => throw null;
                    public Microsoft.Net.Http.Headers.MediaTypeHeaderValue CopyAsReadOnly() => throw null;
                    public System.Text.Encoding Encoding { get => throw null; set => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Primitives.StringSegment> Facets { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public bool IsSubsetOf(Microsoft.Net.Http.Headers.MediaTypeHeaderValue otherMediaType) => throw null;
                    public bool MatchesAllSubTypes { get => throw null; }
                    public bool MatchesAllSubTypesWithoutSuffix { get => throw null; }
                    public bool MatchesAllTypes { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment MediaType { get => throw null; set => throw null; }
                    public MediaTypeHeaderValue(Microsoft.Extensions.Primitives.StringSegment mediaType, double quality) => throw null;
                    public MediaTypeHeaderValue(Microsoft.Extensions.Primitives.StringSegment mediaType) => throw null;
                    public System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> Parameters { get => throw null; }
                    public static Microsoft.Net.Http.Headers.MediaTypeHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.MediaTypeHeaderValue> ParseList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.MediaTypeHeaderValue> ParseStrictList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public double? Quality { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment SubType { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment SubTypeWithoutSuffix { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Suffix { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.MediaTypeHeaderValue parsedValue) => throw null;
                    public static bool TryParseList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.MediaTypeHeaderValue> parsedValues) => throw null;
                    public static bool TryParseStrictList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.MediaTypeHeaderValue> parsedValues) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Type { get => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.MediaTypeHeaderValueComparer` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MediaTypeHeaderValueComparer : System.Collections.Generic.IComparer<Microsoft.Net.Http.Headers.MediaTypeHeaderValue>
                {
                    public int Compare(Microsoft.Net.Http.Headers.MediaTypeHeaderValue mediaType1, Microsoft.Net.Http.Headers.MediaTypeHeaderValue mediaType2) => throw null;
                    public static Microsoft.Net.Http.Headers.MediaTypeHeaderValueComparer QualityComparer { get => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.NameValueHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NameValueHeaderValue
                {
                    public Microsoft.Net.Http.Headers.NameValueHeaderValue Copy() => throw null;
                    public Microsoft.Net.Http.Headers.NameValueHeaderValue CopyAsReadOnly() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public static Microsoft.Net.Http.Headers.NameValueHeaderValue Find(System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> values, Microsoft.Extensions.Primitives.StringSegment name) => throw null;
                    public override int GetHashCode() => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment GetUnescapedValue() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Name { get => throw null; }
                    public NameValueHeaderValue(Microsoft.Extensions.Primitives.StringSegment name, Microsoft.Extensions.Primitives.StringSegment value) => throw null;
                    public NameValueHeaderValue(Microsoft.Extensions.Primitives.StringSegment name) => throw null;
                    public static Microsoft.Net.Http.Headers.NameValueHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> ParseList(System.Collections.Generic.IList<string> input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> ParseStrictList(System.Collections.Generic.IList<string> input) => throw null;
                    public void SetAndEscapeValue(Microsoft.Extensions.Primitives.StringSegment value) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.NameValueHeaderValue parsedValue) => throw null;
                    public static bool TryParseList(System.Collections.Generic.IList<string> input, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> parsedValues) => throw null;
                    public static bool TryParseStrictList(System.Collections.Generic.IList<string> input, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.NameValueHeaderValue> parsedValues) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Value { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.RangeConditionHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RangeConditionHeaderValue
                {
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.DateTimeOffset? LastModified { get => throw null; }
                    public static Microsoft.Net.Http.Headers.RangeConditionHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public RangeConditionHeaderValue(string entityTag) => throw null;
                    public RangeConditionHeaderValue(System.DateTimeOffset lastModified) => throw null;
                    public RangeConditionHeaderValue(Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.RangeConditionHeaderValue parsedValue) => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.RangeHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RangeHeaderValue
                {
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static Microsoft.Net.Http.Headers.RangeHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public RangeHeaderValue(System.Int64? from, System.Int64? to) => throw null;
                    public RangeHeaderValue() => throw null;
                    public System.Collections.Generic.ICollection<Microsoft.Net.Http.Headers.RangeItemHeaderValue> Ranges { get => throw null; }
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.RangeHeaderValue parsedValue) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Unit { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.RangeItemHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RangeItemHeaderValue
                {
                    public override bool Equals(object obj) => throw null;
                    public System.Int64? From { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public RangeItemHeaderValue(System.Int64? from, System.Int64? to) => throw null;
                    public System.Int64? To { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.Net.Http.Headers.SameSiteMode` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum SameSiteMode
                {
                    Lax,
                    None,
                    Strict,
                    Unspecified,
                }

                // Generated from `Microsoft.Net.Http.Headers.SetCookieHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class SetCookieHeaderValue
                {
                    public void AppendToStringBuilder(System.Text.StringBuilder builder) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Domain { get => throw null; set => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public System.DateTimeOffset? Expires { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> Extensions { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public bool HttpOnly { get => throw null; set => throw null; }
                    public System.TimeSpan? MaxAge { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Name { get => throw null; set => throw null; }
                    public static Microsoft.Net.Http.Headers.SetCookieHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.SetCookieHeaderValue> ParseList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.SetCookieHeaderValue> ParseStrictList(System.Collections.Generic.IList<string> inputs) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Path { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.SameSiteMode SameSite { get => throw null; set => throw null; }
                    public bool Secure { get => throw null; set => throw null; }
                    public SetCookieHeaderValue(Microsoft.Extensions.Primitives.StringSegment name, Microsoft.Extensions.Primitives.StringSegment value) => throw null;
                    public SetCookieHeaderValue(Microsoft.Extensions.Primitives.StringSegment name) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.SetCookieHeaderValue parsedValue) => throw null;
                    public static bool TryParseList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.SetCookieHeaderValue> parsedValues) => throw null;
                    public static bool TryParseStrictList(System.Collections.Generic.IList<string> inputs, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.SetCookieHeaderValue> parsedValues) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Value { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.StringWithQualityHeaderValue` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class StringWithQualityHeaderValue
                {
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public static Microsoft.Net.Http.Headers.StringWithQualityHeaderValue Parse(Microsoft.Extensions.Primitives.StringSegment input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> ParseList(System.Collections.Generic.IList<string> input) => throw null;
                    public static System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> ParseStrictList(System.Collections.Generic.IList<string> input) => throw null;
                    public double? Quality { get => throw null; }
                    public StringWithQualityHeaderValue(Microsoft.Extensions.Primitives.StringSegment value, double quality) => throw null;
                    public StringWithQualityHeaderValue(Microsoft.Extensions.Primitives.StringSegment value) => throw null;
                    public override string ToString() => throw null;
                    public static bool TryParse(Microsoft.Extensions.Primitives.StringSegment input, out Microsoft.Net.Http.Headers.StringWithQualityHeaderValue parsedValue) => throw null;
                    public static bool TryParseList(System.Collections.Generic.IList<string> input, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> parsedValues) => throw null;
                    public static bool TryParseStrictList(System.Collections.Generic.IList<string> input, out System.Collections.Generic.IList<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue> parsedValues) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment Value { get => throw null; }
                }

                // Generated from `Microsoft.Net.Http.Headers.StringWithQualityHeaderValueComparer` in `Microsoft.Net.Http.Headers, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class StringWithQualityHeaderValueComparer : System.Collections.Generic.IComparer<Microsoft.Net.Http.Headers.StringWithQualityHeaderValue>
                {
                    public int Compare(Microsoft.Net.Http.Headers.StringWithQualityHeaderValue stringWithQuality1, Microsoft.Net.Http.Headers.StringWithQualityHeaderValue stringWithQuality2) => throw null;
                    public static Microsoft.Net.Http.Headers.StringWithQualityHeaderValueComparer QualityComparer { get => throw null; }
                }

            }
        }
    }
}
