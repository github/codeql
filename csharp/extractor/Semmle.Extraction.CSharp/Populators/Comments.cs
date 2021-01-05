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
                gen.GenerateBindings((entity, block, binding) =>
                {
                    var commentBlock = Entities.CommentBlock.Create(cx, block);
                    commentBlock.BindTo(entity, binding);
                });
            });
        }
    }
}
