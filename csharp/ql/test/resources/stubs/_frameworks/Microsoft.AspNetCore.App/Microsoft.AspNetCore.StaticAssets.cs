// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.StaticAssets, Version=9.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class StaticAssetsEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.StaticAssets.StaticAssetsEndpointConventionBuilder MapStaticAssets(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string staticAssetsManifestPath = default(string)) => throw null;
            }
        }
        namespace StaticAssets
        {
            namespace Infrastructure
            {
                public static class StaticAssetsEndpointDataSourceHelper
                {
                    public static bool HasStaticAssetsDataSource(Microsoft.AspNetCore.Routing.IEndpointRouteBuilder builder, string staticAssetsManifestPath = default(string)) => throw null;
                    public static System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.StaticAssets.StaticAssetDescriptor> ResolveStaticAssetDescriptors(Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpointRouteBuilder, string manifestPath) => throw null;
                }
            }
            public sealed class StaticAssetDescriptor
            {
                public string AssetPath { get => throw null; set { } }
                public StaticAssetDescriptor() => throw null;
                public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.StaticAssets.StaticAssetProperty> Properties { get => throw null; set { } }
                public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.StaticAssets.StaticAssetResponseHeader> ResponseHeaders { get => throw null; set { } }
                public string Route { get => throw null; set { } }
                public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.StaticAssets.StaticAssetSelector> Selectors { get => throw null; set { } }
            }
            public sealed class StaticAssetProperty
            {
                public StaticAssetProperty(string name, string value) => throw null;
                public string Name { get => throw null; }
                public string Value { get => throw null; }
            }
            public sealed class StaticAssetResponseHeader
            {
                public StaticAssetResponseHeader(string name, string value) => throw null;
                public string Name { get => throw null; }
                public string Value { get => throw null; }
            }
            public sealed class StaticAssetSelector
            {
                public StaticAssetSelector(string name, string value, string quality) => throw null;
                public string Name { get => throw null; }
                public string Quality { get => throw null; }
                public string Value { get => throw null; }
            }
            public sealed class StaticAssetsEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
            }
        }
    }
}
