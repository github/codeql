using System.IO;

namespace Semmle.Extraction
{
    public abstract class LabelledEntity : Entity
    {
        protected LabelledEntity(Context cx) : base(cx)
        {
        }

        public override void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write('\"');
        }
    }
}
