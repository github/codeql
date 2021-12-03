// This file contains auto-generated code.

namespace System
{
    namespace Reflection
    {
        namespace Metadata
        {
            // Generated from `System.Reflection.Metadata.AssemblyExtensions` in `System.Runtime.Loader, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class AssemblyExtensions
            {
                unsafe public static bool TryGetRawMetadata(this System.Reflection.Assembly assembly, out System.Byte* blob, out int length) => throw null;
            }

        }
    }
    namespace Runtime
    {
        namespace Loader
        {
            // Generated from `System.Runtime.Loader.AssemblyDependencyResolver` in `System.Runtime.Loader, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AssemblyDependencyResolver
            {
                public AssemblyDependencyResolver(string componentAssemblyPath) => throw null;
                public string ResolveAssemblyToPath(System.Reflection.AssemblyName assemblyName) => throw null;
                public string ResolveUnmanagedDllToPath(string unmanagedDllName) => throw null;
            }

            // Generated from `System.Runtime.Loader.AssemblyLoadContext` in `System.Runtime.Loader, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AssemblyLoadContext
            {
                // Generated from `System.Runtime.Loader.AssemblyLoadContext+ContextualReflectionScope` in `System.Runtime.Loader, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct ContextualReflectionScope : System.IDisposable
                {
                    // Stub generator skipped constructor 
                    public void Dispose() => throw null;
                }


                public static System.Collections.Generic.IEnumerable<System.Runtime.Loader.AssemblyLoadContext> All { get => throw null; }
                public System.Collections.Generic.IEnumerable<System.Reflection.Assembly> Assemblies { get => throw null; }
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
                protected virtual System.IntPtr LoadUnmanagedDll(string unmanagedDllName) => throw null;
                protected System.IntPtr LoadUnmanagedDllFromPath(string unmanagedDllPath) => throw null;
                public string Name { get => throw null; }
                public event System.Func<System.Runtime.Loader.AssemblyLoadContext, System.Reflection.AssemblyName, System.Reflection.Assembly> Resolving;
                public event System.Func<System.Reflection.Assembly, string, System.IntPtr> ResolvingUnmanagedDll;
                public void SetProfileOptimizationRoot(string directoryPath) => throw null;
                public void StartProfileOptimization(string profile) => throw null;
                public override string ToString() => throw null;
                public void Unload() => throw null;
                public event System.Action<System.Runtime.Loader.AssemblyLoadContext> Unloading;
                // ERR: Stub generator didn't handle member: ~AssemblyLoadContext
            }

        }
    }
}
