using System;

namespace Semmle.Extraction.Kinds
{
    [Flags]
    public enum TypeAnnotation
    {
        None = 0,
        NotAnnotated = 4,
        Annotated = 8,
        ReadonlyRef = 16,
        Ref = 32,
        Out = 64
    }
}
