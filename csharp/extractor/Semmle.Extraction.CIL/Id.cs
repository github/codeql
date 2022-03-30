using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL
{
    public static class IdUtils
    {
        public static string Id(this PrimitiveTypeCode typeCode)
        {
            switch (typeCode)
            {
                case PrimitiveTypeCode.Boolean: return "Boolean";
                case PrimitiveTypeCode.Byte: return "Byte";
                case PrimitiveTypeCode.Char: return "Char";
                case PrimitiveTypeCode.Double: return "Double";
                case PrimitiveTypeCode.Int16: return "Int16";
                case PrimitiveTypeCode.Int32: return "Int32";
                case PrimitiveTypeCode.Int64: return "Int64";
                case PrimitiveTypeCode.IntPtr: return "IntPtr";
                case PrimitiveTypeCode.Object: return "Object";
                case PrimitiveTypeCode.SByte: return "SByte";
                case PrimitiveTypeCode.Single: return "Single";
                case PrimitiveTypeCode.String: return "String";
                case PrimitiveTypeCode.UInt16: return "UInt16";
                case PrimitiveTypeCode.UInt32: return "UInt32";
                case PrimitiveTypeCode.UInt64: return "UInt64";
                case PrimitiveTypeCode.UIntPtr: return "UIntPtr";
                case PrimitiveTypeCode.Void: return "Void";
                case PrimitiveTypeCode.TypedReference: return "TypedReference";
                default: throw new InternalError($"Unhandled type code {typeCode}");
            }
        }
    }
}
