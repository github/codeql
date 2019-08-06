using Semmle.Extraction.CommentProcessing;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    class CommentBlock : CachedEntity<ICommentBlock>
    {
        CommentBlock(Context cx, ICommentBlock init)
            : base(cx, init) { }

        public override void Populate()
        {
            Context.Emit(Tuples.commentblock(this));
            int child = 0;
            Context.Emit(Tuples.commentblock_location(this, Context.Create(symbol.Location)));
            foreach (var l in symbol.CommentLines)
            {
                Context.Emit(Tuples.commentblock_child(this, (CommentLine)l, child++));
            }
        }

        public override bool NeedsPopulation => true;

        public override IId Id
        {
            get
            {
                var loc = Context.Create(symbol.Location);
                return new Key(loc, ";commentblock");
            }
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => symbol.Location;

        public void BindTo(Label entity, CommentBinding binding)
        {
            Context.Emit(Tuples.commentblock_binding(this, entity, binding));
        }

        public static CommentBlock Create(Context cx, ICommentBlock block) => CommentBlockFactory.Instance.CreateEntity(cx, block);

        class CommentBlockFactory : ICachedEntityFactory<ICommentBlock, CommentBlock>
        {
            public static readonly CommentBlockFactory Instance = new CommentBlockFactory();

            public CommentBlock Create(Context cx, ICommentBlock init) => new CommentBlock(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
