using System.Collections.Generic;
using System.IO;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// An ID fragment which is designed to be shared, reused
    /// and composed using the + operator.
    /// </summary>
    public abstract class Id : IId
    {
        public void AppendTo(System.IO.TextWriter tb)
        {
            tb.Write("@\"");
            BuildParts(tb);
            tb.Write("\"");
        }

        public abstract void BuildParts(System.IO.TextWriter tb);

        public static Id operator +(Id l1, Id l2) => Create(l1, l2);

        public static Id operator +(Id l1, string l2) => Create(l1, Create(l2));

        public static Id operator +(Id l1, int l2) => Create(l1, Create(l2));

        public static Id operator +(string l1, Id l2) => Create(Create(l1), l2);

        public static Id operator +(int l1, Id l2) => Create(Create(l1), l2);

        public static Id Create(string s) => s == null ? null : new StringId(s);

        public static Id Create(int i) => new IntId(i);

        static readonly Id openCurly = Create("{#");
        static readonly Id closeCurly = Create("}");

        public static Id Create(Label l) => openCurly + l.Value + closeCurly;

        static readonly Id comma = Id.Create(",");

        public static Id CommaSeparatedList(IEnumerable<Id> items)
        {
            Id result = null;
            bool first = true;
            foreach (var i in items)
            {
                if (first) first = false; else result += comma;
                result += i;
            }
            return result;
        }

        public static Id Create(Id l1, Id l2)
        {
            return l1 == null ? l2 : l2 == null ? l1 : new ConsId(l1, l2);
        }

        public abstract string Value { get; }

        public override string ToString() => Value;
    }

    /// <summary>
    /// An ID concatenating two other IDs.
    /// </summary>
    public sealed class ConsId : Id
    {
        readonly Id left, right;
        readonly int hash;

        public ConsId(Id l1, Id l2)
        {
            left = l1;
            right = l2;
            hash = unchecked(12 + 3 * (left.GetHashCode() + 51 * right.GetHashCode()));
        }

        public override void BuildParts(System.IO.TextWriter tb)
        {
            left.BuildParts(tb);
            right.BuildParts(tb);
        }

        public override bool Equals(object other)
        {
            return other is ConsId && Equals((ConsId)other);
        }

        public bool Equals(ConsId other)
        {
            return this == other ||
                (hash == other.hash && left.Equals(other.left) && right.Equals(other.right));
        }

        public override int GetHashCode() => hash;

        public override string Value => left.Value + right.Value;

    }

    /// <summary>
    /// A leaf ID storing a string.
    /// </summary>
    public sealed class StringId : Id
    {
        readonly string value;
        public override string Value => value;

        public StringId(string s)
        {
            value = s;
        }

        public override void BuildParts(System.IO.TextWriter tw)
        {
            tw.Write(value);
        }

        public override bool Equals(object obj)
        {
            return obj is StringId && ((StringId)obj).value == value;
        }

        public override int GetHashCode() => Value.GetHashCode() * 31 + 9;
    }

    /// <summary>
    /// A leaf ID storing an integer.
    /// </summary>
    public sealed class IntId : Id
    {
        readonly int value;
        public override string Value => value.ToString();

        public IntId(int i)
        {
            value = i;
        }

        public override void BuildParts(System.IO.TextWriter tw)
        {
            tw.Write(value);
        }

        public override bool Equals(object obj)
        {
            return obj is IntId && ((IntId)obj).value == value;
        }

        public override int GetHashCode() => unchecked(12 + value * 17);
    }

    /// <summary>
    /// Some predefined IDs.
    /// </summary>
    public static class IdUtils
    {
        public static StringId boolId = new StringId("Boolean");
        public static StringId byteId = new StringId("Byte");
        public static StringId charId = new StringId("Char");
        public static StringId doubleId = new StringId("Double");
        public static StringId shortId = new StringId("Int16");
        public static StringId intId = new StringId("Int32");
        public static StringId longId = new StringId("Int64");
        public static StringId intptrId = new StringId("IntPtr");
        public static StringId objectId = new StringId("Object");
        public static StringId sbyteId = new StringId("SByte");
        public static StringId floatId = new StringId("Single");
        public static StringId stringId = new StringId("String");
        public static StringId ushortId = new StringId("UInt16");
        public static StringId uintId = new StringId("UInt32");
        public static StringId ulongId = new StringId("UInt64");
        public static StringId uintptrId = new StringId("UIntPtr");
        public static StringId voidId = new StringId("Void");
        public static StringId typedReferenceId = new StringId("TypedReference");

        public static StringId Id(this PrimitiveTypeCode typeCode)
        {
            switch (typeCode)
            {
                case PrimitiveTypeCode.Boolean: return boolId;
                case PrimitiveTypeCode.Byte: return byteId;
                case PrimitiveTypeCode.Char: return charId;
                case PrimitiveTypeCode.Double: return doubleId;
                case PrimitiveTypeCode.Int16: return shortId;
                case PrimitiveTypeCode.Int32: return intId;
                case PrimitiveTypeCode.Int64: return longId;
                case PrimitiveTypeCode.IntPtr: return intptrId;
                case PrimitiveTypeCode.Object: return objectId;
                case PrimitiveTypeCode.SByte: return sbyteId;
                case PrimitiveTypeCode.Single: return floatId;
                case PrimitiveTypeCode.String: return stringId;
                case PrimitiveTypeCode.UInt16: return ushortId;
                case PrimitiveTypeCode.UInt32: return uintId;
                case PrimitiveTypeCode.UInt64: return ulongId;
                case PrimitiveTypeCode.UIntPtr: return uintptrId;
                case PrimitiveTypeCode.Void: return voidId;
                case PrimitiveTypeCode.TypedReference: return typedReferenceId;
                default: throw new InternalError($"Unhandled type code {typeCode}");
            }
        }
    }
}
