using System.IO;

namespace Semmle.Extraction
{
    public abstract class LabelledEntity : Entity
    {
        protected LabelledEntity(Context cx) : base(cx)
        {
        }
    }
}
