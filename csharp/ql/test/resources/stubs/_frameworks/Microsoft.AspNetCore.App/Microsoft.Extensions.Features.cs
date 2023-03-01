// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            namespace Features
            {
                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureCollection` in `Microsoft.Extensions.Features, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FeatureCollection : Microsoft.AspNetCore.Http.Features.IFeatureCollection, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.Type, object>>, System.Collections.IEnumerable
                {
                    public FeatureCollection() => throw null;
                    public FeatureCollection(Microsoft.AspNetCore.Http.Features.IFeatureCollection defaults) => throw null;
                    public FeatureCollection(int initialCapacity) => throw null;
                    public TFeature Get<TFeature>() => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<System.Type, object>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public object this[System.Type key] { get => throw null; set => throw null; }
                    public virtual int Revision { get => throw null; }
                    public void Set<TFeature>(TFeature instance) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureCollectionExtensions` in `Microsoft.Extensions.Features, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class FeatureCollectionExtensions
                {
                    public static object GetRequiredFeature(this Microsoft.AspNetCore.Http.Features.IFeatureCollection featureCollection, System.Type key) => throw null;
                    public static TFeature GetRequiredFeature<TFeature>(this Microsoft.AspNetCore.Http.Features.IFeatureCollection featureCollection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureReference<>` in `Microsoft.Extensions.Features, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct FeatureReference<T>
                {
                    public static Microsoft.AspNetCore.Http.Features.FeatureReference<T> Default;
                    // Stub generator skipped constructor 
                    public T Fetch(Microsoft.AspNetCore.Http.Features.IFeatureCollection features) => throw null;
                    public T Update(Microsoft.AspNetCore.Http.Features.IFeatureCollection features, T feature) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.FeatureReferences<>` in `Microsoft.Extensions.Features, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct FeatureReferences<TCache>
                {
                    public TCache Cache;
                    public Microsoft.AspNetCore.Http.Features.IFeatureCollection Collection { get => throw null; }
                    // Stub generator skipped constructor 
                    public FeatureReferences(Microsoft.AspNetCore.Http.Features.IFeatureCollection collection) => throw null;
                    public TFeature Fetch<TFeature, TState>(ref TFeature cached, TState state, System.Func<TState, TFeature> factory) where TFeature : class => throw null;
                    public TFeature Fetch<TFeature>(ref TFeature cached, System.Func<Microsoft.AspNetCore.Http.Features.IFeatureCollection, TFeature> factory) where TFeature : class => throw null;
                    public void Initalize(Microsoft.AspNetCore.Http.Features.IFeatureCollection collection) => throw null;
                    public void Initalize(Microsoft.AspNetCore.Http.Features.IFeatureCollection collection, int revision) => throw null;
                    public int Revision { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Features.IFeatureCollection` in `Microsoft.Extensions.Features, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFeatureCollection : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.Type, object>>, System.Collections.IEnumerable
                {
                    TFeature Get<TFeature>();
                    bool IsReadOnly { get; }
                    object this[System.Type key] { get; set; }
                    int Revision { get; }
                    void Set<TFeature>(TFeature instance);
                }

            }
        }
    }
}
