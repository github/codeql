using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.PDB
{
    public class Method
    {
        public IEnumerable<SequencePoint> SequencePoints { get; }

        public Method(IEnumerable<SequencePoint> sequencePoints)
        {
            SequencePoints = sequencePoints;
        }

        public Location Location => SequencePoints.First().Location;
    }
}
