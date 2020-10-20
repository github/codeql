using System.Collections.Generic;
using System.IO;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An event.
    /// </summary>
    internal interface IEvent : IExtractedEntity
    {
    }

    /// <summary>
    /// An event entity.
    /// </summary>
    internal sealed class Event : LabelledEntity, IEvent
    {
        private readonly EventDefinitionHandle handle;
        private readonly Type parent;
        private readonly EventDefinition ed;

        public Event(Context cx, Type parent, EventDefinitionHandle handle) : base(cx)
        {
            this.handle = handle;
            this.parent = parent;
            ed = cx.MdReader.GetEventDefinition(handle);
        }

        public override void WriteId(TextWriter trapFile)
        {
            parent.WriteId(trapFile);
            trapFile.Write('.');
            trapFile.Write(Cx.ShortName(ed.Name));
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
                var signature = (Type)Cx.CreateGeneric(parent, ed.Type);
                yield return signature;

                yield return Tuples.cil_event(this, parent, Cx.ShortName(ed.Name), signature);

                var accessors = ed.GetAccessors();
                if (!accessors.Adder.IsNil)
                {
                    var adder = (Method)Cx.CreateGeneric(parent, accessors.Adder);
                    yield return adder;
                    yield return Tuples.cil_adder(this, adder);
                }

                if (!accessors.Remover.IsNil)
                {
                    var remover = (Method)Cx.CreateGeneric(parent, accessors.Remover);
                    yield return remover;
                    yield return Tuples.cil_remover(this, remover);
                }

                if (!accessors.Raiser.IsNil)
                {
                    var raiser = (Method)Cx.CreateGeneric(parent, accessors.Raiser);
                    yield return raiser;
                    yield return Tuples.cil_raiser(this, raiser);
                }

                foreach (var c in Attribute.Populate(Cx, this, ed.GetCustomAttributes()))
                    yield return c;
            }
        }
    }
}
