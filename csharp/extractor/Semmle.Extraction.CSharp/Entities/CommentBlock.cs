using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class CommentBlock : CachedEntity<Comments.CommentBlock>
    {
        private CommentBlock(Context cx, Comments.CommentBlock init)
            : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.commentblock(this);
            var child = 0;
            trapFile.commentblock_location(this, Context.CreateLocation(Symbol.Location));
            foreach (var l in Symbol.CommentLines)
            {
                trapFile.commentblock_child(this, (CommentLine)l, child++);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Context.CreateLocation(Symbol.Location));
            trapFile.Write(";commentblock");
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Symbol.Location;

        public void BindTo(Label entity, CommentBinding binding)
        {
            Context.TrapWriter.Writer.commentblock_binding(this, entity, binding);
        }

        public static CommentBlock Create(Context cx, Comments.CommentBlock block) => CommentBlockFactory.Instance.CreateEntity(cx, block, block);

        private class CommentBlockFactory : CachedEntityFactory<Comments.CommentBlock, CommentBlock>
        {
            public static CommentBlockFactory Instance { get; } = new CommentBlockFactory();

            public override CommentBlock Create(Context cx, Comments.CommentBlock init) => new CommentBlock(cx, init);
        }
    }
}
