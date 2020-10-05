using System.Collections.Generic;

namespace Semmle.Extraction.CIL.Entities
{
    internal interface IExceptionRegion : IExtractedEntity
    {
    }

    /// <summary>
    /// An exception region entity.
    /// </summary>
    internal class ExceptionRegion : UnlabelledEntity, IExceptionRegion
    {
        private readonly GenericContext gc;
        private readonly MethodImplementation method;
        private readonly int index;
        private readonly System.Reflection.Metadata.ExceptionRegion r;
        private readonly Dictionary<int, IInstruction> jump_table;

        public ExceptionRegion(GenericContext gc, MethodImplementation method, int index, System.Reflection.Metadata.ExceptionRegion r, Dictionary<int, IInstruction> jump_table) : base(gc.Cx)
        {
            this.gc = gc;
            this.method = method;
            this.index = index;
            this.r = r;
            this.jump_table = jump_table;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {

                if (!jump_table.TryGetValue(r.TryOffset, out var try_start))
                    throw new InternalError("Failed  to retrieve handler");
                if (!jump_table.TryGetValue(r.TryOffset + r.TryLength, out var try_end))
                    throw new InternalError("Failed  to retrieve handler");
                if (!jump_table.TryGetValue(r.HandlerOffset, out var handler_start))
                    throw new InternalError("Failed  to retrieve handler");

                yield return Tuples.cil_handler(this, method, index, (int)r.Kind, try_start, try_end, handler_start);

                if (r.FilterOffset != -1)
                {
                    if (!jump_table.TryGetValue(r.FilterOffset, out var filter_start))
                        throw new InternalError("ExceptionRegion filter clause");

                    yield return Tuples.cil_handler_filter(this, filter_start);
                }

                if (!r.CatchType.IsNil)
                {
                    var catchType = (Type)Cx.CreateGeneric(gc, r.CatchType);
                    yield return catchType;
                    yield return Tuples.cil_handler_type(this, catchType);
                }
            }
        }
    }
}
