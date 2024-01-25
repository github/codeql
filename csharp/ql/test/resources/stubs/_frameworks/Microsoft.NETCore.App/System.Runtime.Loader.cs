// This file contains auto-generated code.
// Generated from `System.Runtime.Loader, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Reflection
    {
        namespace Metadata
        {
            public static partial class AssemblyExtensions
            {
                public static unsafe bool TryGetRawMetadata(this System.Reflection.Assembly assembly, out byte* blob, out int length) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = true)]
            public sealed class MetadataUpdateHandlerAttribute : System.Attribute
            {
                public MetadataUpdateHandlerAttribute(System.Type handlerType) => throw null;
                public System.Type HandlerType { get => throw null; }
            }
            public static class MetadataUpdater
            {
                public static void ApplyUpdate(System.Reflection.Assembly assembly, System.ReadOnlySpan<byte> metadataDelta, System.ReadOnlySpan<byte> ilDelta, System.ReadOnlySpan<byte> pdbDelta) => throw null;
                public static bool IsSupported { get => throw null; }
            }
        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = false)]
            public sealed class CreateNewOnMetadataUpdateAttribute : System.Attribute
            {
                public CreateNewOnMetadataUpdateAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = false, Inherited = false)]
            public class MetadataUpdateOriginalTypeAttribute : System.Attribute
            {
                public MetadataUpdateOriginalTypeAttribute(System.Type originalType) => throw null;
                public System.Type OriginalType { get => throw null; }
            }
        }
        namespace Loader
        {
            public sealed class AssemblyDependencyResolver
            {
                public AssemblyDependencyResolver(string componentAssemblyPath) => throw null;
                public string ResolveAssemblyToPath(System.Reflection.AssemblyName assemblyName) => throw null;
                public string ResolveUnmanagedDllToPath(string unmanagedDllName) => throw null;
            }
            public class AssemblyLoadContext
            {
                public static System.Collections.Generic.IEnumerable<System.Runtime.Loader.AssemblyLoadContext> All { get => throw null; }
                public System.Collections.Generic.IEnumerable<System.Reflection.Assembly> Assemblies { get => throw null; }
                public struct ContextualReflectionScope : System.IDisposable
                {
                    public void Dispose() => throw null;
                }
                protected AssemblyLoadContext() => throw null;
                protected AssemblyLoadContext(bool isCollectible) => throw null;
                public AssemblyLoadContext(string name, bool isCollectible = default(bool)) => throw null;
                public static System.Runtime.Loader.AssemblyLoadContext CurrentContextualReflectionContext { get => throw null; }
                public static System.Runtime.Loader.AssemblyLoadContext Default { get => throw null; }
                public System.Runtime.Loader.AssemblyLoadContext.ContextualReflectionScope EnterContextualReflection() => throw null;
                public static System.Runtime.Loader.AssemblyLoadContext.ContextualReflectionScope EnterContextualReflection(System.Reflection.Assembly activating) => throw null;
                public static System.Reflection.AssemblyName GetAssemblyName(string assemblyPath) => throw null;
                public static System.Runtime.Loader.AssemblyLoadContext GetLoadContext(System.Reflection.Assembly assembly) => throw null;
                public bool IsCollectible { get => throw null; }
                protected virtual System.Reflection.Assembly Load(System.Reflection.AssemblyName assemblyName) => throw null;
                public System.Reflection.Assembly LoadFromAssemblyName(System.Reflection.AssemblyName assemblyName) => throw null;
                public System.Reflection.Assembly LoadFromAssemblyPath(string assemblyPath) => throw null;
                public System.Reflection.Assembly LoadFromNativeImagePath(string nativeImagePath, string assemblyPath) => throw null;
                public System.Reflection.Assembly LoadFromStream(System.IO.Stream assembly) => throw null;
                public System.Reflection.Assembly LoadFromStream(System.IO.Stream assembly, System.IO.Stream assemblySymbols) => throw null;
                protected virtual nint LoadUnmanagedDll(string unmanagedDllName) => throw null;
                protected nint LoadUnmanagedDllFromPath(string unmanagedDllPath) => throw null;
                public string Name { get => throw null; }
                public event System.Func<System.Runtime.Loader.AssemblyLoadContext, System.Reflection.AssemblyName, System.Reflection.Assembly> Resolving;
                public event System.Func<System.Reflection.Assembly, string, nint> ResolvingUnmanagedDll;
                public void SetProfileOptimizationRoot(string directoryPath) => throw null;
                public void StartProfileOptimization(string profile) => throw null;
                public override string ToString() => throw null;
                public void Unload() => throw null;
                public event System.Action<System.Runtime.Loader.AssemblyLoadContext> Unloading;
            }
        }
    }
}
