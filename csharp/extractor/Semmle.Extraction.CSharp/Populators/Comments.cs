using Semmle.Extraction.CommentProcessing;

namespace Semmle.Extraction.CSharp.Populators
{
    /// <summary>
    /// Populators for comments.
    /// </summary>
    public static class Comments
    {
        public static void ExtractComments(this Context cx, ICommentGenerator gen)
        {
            cx.Try(null, null, () =>
            {
                gen.GenerateBindings((entity, duplicationGuardKey, block, binding) =>
                {
                    var commentBlock = Entities.CommentBlock.Create(cx, block);
                    void A()
                    {
                        commentBlock.BindTo(entity, binding);
                    }
                    // When the duplication guard key exists, it means that the entity is guarded against
                    // trap duplication (<see cref = "Context.BindComments(IEntity, Location)" />).
                    // We must therefore also guard comment construction.
                    if (duplicationGuardKey != null)
                        cx.WithDuplicationGuard(duplicationGuardKey, A);
                    else
                        A();
                });
            });
        }
    }
}
