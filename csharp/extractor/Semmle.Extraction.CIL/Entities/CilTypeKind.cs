namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// The CIL database type-kind.
    /// </summary>
    public enum CilTypeKind
    {
        ValueOrRefType,
        TypeParameter,
        Array,
        Pointer,
        FunctionPointer
    }
}
