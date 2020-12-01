using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.PDB
{
    public interface IMethod
    {
        IEnumerable<SequencePoint> SequencePoints { get; }
        Location Location { get; }
    }
}
