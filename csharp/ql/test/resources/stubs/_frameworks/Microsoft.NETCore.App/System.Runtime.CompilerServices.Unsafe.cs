// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace CompilerServices
        {
            // Generated from `System.Runtime.CompilerServices.Unsafe` in `System.Runtime.CompilerServices.Unsafe, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class Unsafe
            {
                unsafe public static void* Add<T>(void* source, int elementOffset) => throw null;
                public static T Add<T>(ref T source, System.IntPtr elementOffset) => throw null;
                public static T Add<T>(ref T source, int elementOffset) => throw null;
                public static T AddByteOffset<T>(ref T source, System.IntPtr byteOffset) => throw null;
                public static bool AreSame<T>(ref T left, ref T right) => throw null;
                public static T As<T>(object o) where T : class => throw null;
                public static TTo As<TFrom, TTo>(ref TFrom source) => throw null;
                unsafe public static void* AsPointer<T>(ref T value) => throw null;
                public static T AsRef<T>(T source) => throw null;
                unsafe public static T AsRef<T>(void* source) => throw null;
                public static System.IntPtr ByteOffset<T>(ref T origin, ref T target) => throw null;
                unsafe public static void Copy<T>(void* destination, ref T source) => throw null;
                unsafe public static void Copy<T>(ref T destination, void* source) => throw null;
                unsafe public static void CopyBlock(void* destination, void* source, System.UInt32 byteCount) => throw null;
                public static void CopyBlock(ref System.Byte destination, ref System.Byte source, System.UInt32 byteCount) => throw null;
                unsafe public static void CopyBlockUnaligned(void* destination, void* source, System.UInt32 byteCount) => throw null;
                public static void CopyBlockUnaligned(ref System.Byte destination, ref System.Byte source, System.UInt32 byteCount) => throw null;
                unsafe public static void InitBlock(void* startAddress, System.Byte value, System.UInt32 byteCount) => throw null;
                public static void InitBlock(ref System.Byte startAddress, System.Byte value, System.UInt32 byteCount) => throw null;
                unsafe public static void InitBlockUnaligned(void* startAddress, System.Byte value, System.UInt32 byteCount) => throw null;
                public static void InitBlockUnaligned(ref System.Byte startAddress, System.Byte value, System.UInt32 byteCount) => throw null;
                public static bool IsAddressGreaterThan<T>(ref T left, ref T right) => throw null;
                public static bool IsAddressLessThan<T>(ref T left, ref T right) => throw null;
                public static bool IsNullRef<T>(ref T source) => throw null;
                public static T NullRef<T>() => throw null;
                unsafe public static T Read<T>(void* source) => throw null;
                unsafe public static T ReadUnaligned<T>(void* source) => throw null;
                public static T ReadUnaligned<T>(ref System.Byte source) => throw null;
                public static int SizeOf<T>() => throw null;
                public static void SkipInit<T>(out T value) => throw null;
                unsafe public static void* Subtract<T>(void* source, int elementOffset) => throw null;
                public static T Subtract<T>(ref T source, System.IntPtr elementOffset) => throw null;
                public static T Subtract<T>(ref T source, int elementOffset) => throw null;
                public static T SubtractByteOffset<T>(ref T source, System.IntPtr byteOffset) => throw null;
                public static T Unbox<T>(object box) where T : struct => throw null;
                unsafe public static void Write<T>(void* destination, T value) => throw null;
                unsafe public static void WriteUnaligned<T>(void* destination, T value) => throw null;
                public static void WriteUnaligned<T>(ref System.Byte destination, T value) => throw null;
            }

        }
    }
}
