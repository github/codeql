using System;

namespace Semmle.Extraction.CIL.Entities
{
    [Flags]
    public enum TypeAnnotation
    {
        None = 0,
        Ref = 32
    }
}
