namespace Types
{
    abstract class Class
    {
        public abstract bool BoolType();
        public abstract char CharType();
        public abstract decimal DecimalType();
        public abstract sbyte SByteType();
        public abstract short ShortType();
        public abstract int IntType();
        public abstract long LongType();
        public abstract byte ByteType();
        public abstract ushort UShortType();
        public abstract uint UIntType();
        public abstract ulong ULongType();
        public abstract float FloatType();
        public abstract double DoubleType();
        public abstract Struct? NullableType();
        public abstract void VoidType();
        public abstract Class[] ArrayType();
        public abstract Class[][] ArrayArrayType();
        public abstract GenericClass<Class> ConstructedClassType();
        public abstract GenericInterface<Class> ConstructedInterfaceType();
        public abstract GenericStruct<Class> ConstructedStructType();
        public abstract Delegate DelegateType();
        unsafe public abstract byte* PointerType();
        unsafe public abstract byte** PointerPointerType();
        unsafe public abstract byte*[][] PointerArrayArrayType();
        public abstract byte?[] NullableArrayType();
        public abstract byte?[][] NullableArrayArrayType();
#nullable enable
        public abstract byte[]?[] ArrayNullArrayType1();
        public abstract object[]?[] ArrayNullArrayType2();
        public abstract object?[] ArrayNullableRefType();
        public abstract object? NullableRefType();
#nullable restore
        public abstract System.Nullable<byte>[][] NullableArrayArrayType2();
        public abstract Map<string, Class> Map();
        Class Null()
        {
            return null;
        }
    }
    enum Enum
    {
    }
    struct Struct
    {
    }
    interface Interface
    {
    }
    delegate void Delegate();
    class GenericClass<T> { }
    interface GenericInterface<T> { }
    struct GenericStruct<T> { }
    class Map<U, V> { }

}
