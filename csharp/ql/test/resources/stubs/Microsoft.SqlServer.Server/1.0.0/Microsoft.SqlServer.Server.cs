// This file contains auto-generated code.
// Generated from `Microsoft.SqlServer.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=23ec7fc2d6eaa4a5`.
namespace Microsoft
{
    namespace SqlServer
    {
        namespace Server
        {
            public enum DataAccessKind
            {
                None = 0,
                Read = 1,
            }
            public enum Format
            {
                Unknown = 0,
                Native = 1,
                UserDefined = 2,
            }
            public interface IBinarySerialize
            {
                void Read(System.IO.BinaryReader r);
                void Write(System.IO.BinaryWriter w);
            }
            public sealed class InvalidUdtException : System.SystemException
            {
                public static Microsoft.SqlServer.Server.InvalidUdtException Create(System.Type udtType, string resourceReason = default(string)) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo si, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)10624, AllowMultiple = false, Inherited = false)]
            public class SqlFacetAttribute : System.Attribute
            {
                public SqlFacetAttribute() => throw null;
                public bool IsFixedLength { get => throw null; set { } }
                public bool IsNullable { get => throw null; set { } }
                public int MaxSize { get => throw null; set { } }
                public int Precision { get => throw null; set { } }
                public int Scale { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
            public class SqlFunctionAttribute : System.Attribute
            {
                public SqlFunctionAttribute() => throw null;
                public Microsoft.SqlServer.Server.DataAccessKind DataAccess { get => throw null; set { } }
                public string FillRowMethodName { get => throw null; set { } }
                public bool IsDeterministic { get => throw null; set { } }
                public bool IsPrecise { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public Microsoft.SqlServer.Server.SystemDataAccessKind SystemDataAccess { get => throw null; set { } }
                public string TableDefinition { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
            public sealed class SqlMethodAttribute : Microsoft.SqlServer.Server.SqlFunctionAttribute
            {
                public SqlMethodAttribute() => throw null;
                public bool InvokeIfReceiverIsNull { get => throw null; set { } }
                public bool IsMutator { get => throw null; set { } }
                public bool OnNullCall { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = false, Inherited = false)]
            public sealed class SqlUserDefinedAggregateAttribute : System.Attribute
            {
                public SqlUserDefinedAggregateAttribute(Microsoft.SqlServer.Server.Format format) => throw null;
                public Microsoft.SqlServer.Server.Format Format { get => throw null; }
                public bool IsInvariantToDuplicates { get => throw null; set { } }
                public bool IsInvariantToNulls { get => throw null; set { } }
                public bool IsInvariantToOrder { get => throw null; set { } }
                public bool IsNullIfEmpty { get => throw null; set { } }
                public int MaxByteSize { get => throw null; set { } }
                public const int MaxByteSizeValue = 8000;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = false, Inherited = true)]
            public sealed class SqlUserDefinedTypeAttribute : System.Attribute
            {
                public SqlUserDefinedTypeAttribute(Microsoft.SqlServer.Server.Format format) => throw null;
                public Microsoft.SqlServer.Server.Format Format { get => throw null; }
                public bool IsByteOrdered { get => throw null; set { } }
                public bool IsFixedLength { get => throw null; set { } }
                public int MaxByteSize { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public string ValidationMethodName { get => throw null; set { } }
            }
            public enum SystemDataAccessKind
            {
                None = 0,
                Read = 1,
            }
        }
    }
}
