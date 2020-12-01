using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Linq;

namespace Semmle.Extraction.PDB
{
    internal class Method : IMethod
    {
        public IEnumerable<SequencePoint> SequencePoints { get; }

        public Method(IEnumerable<SequencePoint> sequencePoints)
        {
            SequencePoints = sequencePoints;
        }

        public Location Location => SequencePoints.First().Location;
    }
}
