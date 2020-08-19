using System.Collections.Generic;
using System.IO;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An event.
    /// </summary>
    interface IEvent : IExtractedEntity
    {
    }

    /// <summary>
    /// An event entity.
    /// </summary>
    sealed class Event : LabelledEntity, IEvent
    {
        readonly EventDefinitionHandle handle;
        readonly Type parent;
        readonly EventDefinition ed;

        public Event(Context cx, Type parent, EventDefinitionHandle handle) : base(cx)
        {
            this.handle = handle;
            this.parent = parent;
            ed = cx.mdReader.GetEventDefinition(handle);
        }

        public override void WriteId(TextWriter trapFile)
        {
            parent.WriteId(trapFile);
            trapFile.Write('.');
            trapFile.Write(cx.ShortName(ed.Name));
        }

        public override string IdSuffix => ";cil-event";

        public override bool Equals(object? obj)
        {
            return obj is Event e && handle.Equals(e.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

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
    }
}
