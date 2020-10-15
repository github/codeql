using Semmle.Extraction.CommentProcessing;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class CommentBlock : CachedEntity<ICommentBlock>
    {
        private CommentBlock(Context cx, ICommentBlock init)
            : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.commentblock(this);
            var child = 0;
            trapFile.commentblock_location(this, Context.Create(symbol.Location));
            foreach (var l in symbol.CommentLines)
            {
                trapFile.commentblock_child(this, (CommentLine)l, child++);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Context.Create(symbol.Location));
            trapFile.Write(";commentblock");
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => symbol.Location;

        public void BindTo(Label entity, CommentBinding binding)
        {
            Context.TrapWriter.Writer.commentblock_binding(this, entity, binding);
        }

        public static CommentBlock Create(Context cx, ICommentBlock block) => CommentBlockFactory.Instance.CreateEntity(cx, block, block);

        private class CommentBlockFactory : ICachedEntityFactory<ICommentBlock, CommentBlock>
        {
            public static CommentBlockFactory Instance { get; } = new CommentBlockFactory();

            public CommentBlock Create(Context cx, ICommentBlock init) => new CommentBlock(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
