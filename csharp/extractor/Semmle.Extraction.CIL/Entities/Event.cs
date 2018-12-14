using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An event.
    /// </summary>
    interface IEvent : ILabelledEntity
    {
    }

    /// <summary>
    /// An event entity.
    /// </summary>
    class Event : LabelledEntity, IEvent
    {
        readonly Type parent;
        readonly EventDefinition ed;
        static readonly Id suffix = CIL.Id.Create(";cil-event");

        public Event(Context cx, Type parent, EventDefinitionHandle handle) : base(cx)
        {
            this.parent = parent;
            ed = cx.mdReader.GetEventDefinition(handle);
            ShortId = parent.ShortId + cx.Dot + cx.ShortName(ed.Name) + suffix;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var signature = (Type)cx.CreateGeneric(parent, ed.Type);
                yield return signature;

                yield return Tuples.cil_event(this, parent, cx.ShortName(ed.Name), signature);

                var accessors = ed.GetAccessors();
                if (!accessors.Adder.IsNil)
                {
                    var adder = (Method)cx.CreateGeneric(parent, accessors.Adder);
                    yield return adder;
                    yield return Tuples.cil_adder(this, adder);
                }

                if (!accessors.Remover.IsNil)
                {
                    var remover = (Method)cx.CreateGeneric(parent, accessors.Remover);
                    yield return remover;
                    yield return Tuples.cil_remover(this, remover);
                }

                if (!accessors.Raiser.IsNil)
                {
                    var raiser = (Method)cx.CreateGeneric(parent, accessors.Raiser);
                    yield return raiser;
                    yield return Tuples.cil_raiser(this, raiser);
                }

                foreach (var c in Attribute.Populate(cx, this, ed.GetCustomAttributes()))
                    yield return c;
            }
        }

        public override Id IdSuffix => suffix;
    }
}
