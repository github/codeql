using Semmle.Extraction.CommentProcessing;
using System;

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
                    Action a = () =>
                    {
                        commentBlock.BindTo(entity, binding);
                    };
                    // When the duplication guard key exists, it means that the entity is guarded against
                    // trap duplication (<see cref = "Context.BindComments(IEntity, Location)" />).
                    // We must therefore also guard comment construction.
                    if (duplicationGuardKey != null)
                        cx.WithDuplicationGuard(duplicationGuardKey, a);
                    else
                        a();
                });
            });
        }
    }
}
