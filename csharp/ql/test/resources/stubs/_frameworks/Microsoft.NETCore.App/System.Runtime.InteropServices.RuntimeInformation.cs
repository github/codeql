// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace InteropServices
        {
            // Generated from `System.Runtime.InteropServices.Architecture` in `System.Runtime.InteropServices.RuntimeInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum Architecture
            {
                Arm,
                Arm64,
                Wasm,
                X64,
                X86,
            }

            // Generated from `System.Runtime.InteropServices.OSPlatform` in `System.Runtime.InteropServices.RuntimeInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct OSPlatform : System.IEquatable<System.Runtime.InteropServices.OSPlatform>
            {
                public static bool operator !=(System.Runtime.InteropServices.OSPlatform left, System.Runtime.InteropServices.OSPlatform right) => throw null;
                public static bool operator ==(System.Runtime.InteropServices.OSPlatform left, System.Runtime.InteropServices.OSPlatform right) => throw null;
                public static System.Runtime.InteropServices.OSPlatform Create(string osPlatform) => throw null;
                public bool Equals(System.Runtime.InteropServices.OSPlatform other) => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Runtime.InteropServices.OSPlatform FreeBSD { get => throw null; }
                public override int GetHashCode() => throw null;
                public static System.Runtime.InteropServices.OSPlatform Linux { get => throw null; }
                // Stub generator skipped constructor 
                public static System.Runtime.InteropServices.OSPlatform OSX { get => throw null; }
                public override string ToString() => throw null;
                public static System.Runtime.InteropServices.OSPlatform Windows { get => throw null; }
            }

            // Generated from `System.Runtime.InteropServices.RuntimeInformation` in `System.Runtime.InteropServices.RuntimeInformation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class RuntimeInformation
            {
                public static string FrameworkDescription { get => throw null; }
                public static bool IsOSPlatform(System.Runtime.InteropServices.OSPlatform osPlatform) => throw null;
                public static System.Runtime.InteropServices.Architecture OSArchitecture { get => throw null; }
                public static string OSDescription { get => throw null; }
                public static System.Runtime.InteropServices.Architecture ProcessArchitecture { get => throw null; }
                public static string RuntimeIdentifier { get => throw null; }
            }

        }
    }
}
