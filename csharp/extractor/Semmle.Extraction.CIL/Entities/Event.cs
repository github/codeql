using System.Collections.Generic;
using System.IO;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An event entity.
    /// </summary>
    internal sealed class Event : LabelledEntity
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

        public override void WriteId(EscapingTextWriter trapFile)
        {
            parent.WriteId(trapFile);
            trapFile.Write('.');
            trapFile.Write(Context.ShortName(ed.Name));
            trapFile.Write(";cil-event");
        }

        public override bool Equals(object? obj)
        {
            return obj is Event e && handle.Equals(e.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var signature = (Type)Context.CreateGeneric(parent, ed.Type);
                yield return signature;

                yield return Tuples.cil_event(this, parent, Context.ShortName(ed.Name), signature);

                var accessors = ed.GetAccessors();
                if (!accessors.Adder.IsNil)
                {
                    var adder = (Method)Context.CreateGeneric(parent, accessors.Adder);
                    yield return adder;
                    yield return Tuples.cil_adder(this, adder);
                }

                if (!accessors.Remover.IsNil)
                {
                    var remover = (Method)Context.CreateGeneric(parent, accessors.Remover);
                    yield return remover;
                    yield return Tuples.cil_remover(this, remover);
                }

                if (!accessors.Raiser.IsNil)
                {
                    var raiser = (Method)Context.CreateGeneric(parent, accessors.Raiser);
                    yield return raiser;
                    yield return Tuples.cil_raiser(this, raiser);
                }

                foreach (var c in Attribute.Populate(Context, this, ed.GetCustomAttributes()))
                    yield return c;
            }
        }
    }
}
