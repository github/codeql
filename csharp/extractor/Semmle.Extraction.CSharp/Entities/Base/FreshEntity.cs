using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// An entity which has a default "*" ID assigned to it.
    /// </summary>
    public abstract class FreshEntity : CSharp.UnlabelledEntity
    {
        protected FreshEntity(Context cx) : base(cx)
        {
        }

        protected abstract void Populate(TextWriter trapFile);

        public void TryPopulate()
        {
            Context.Try(null, null, () => Populate(Context.TrapWriter.Writer));
        }

        /// <summary>
        /// For debugging.
        /// </summary>
        public string DebugContents
        {
            get
            {
                using var writer = new StringWriter();
                Populate(writer);
                return writer.ToString();
            }
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        public override CSharp.TrapStackBehaviour TrapStackBehaviour => CSharp.TrapStackBehaviour.NoLabel;
    }
}
