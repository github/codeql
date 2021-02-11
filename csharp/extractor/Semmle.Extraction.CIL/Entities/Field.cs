using System;
using System.Collections.Generic;
using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An entity representing a field.
    /// </summary>
    internal abstract class Field : IGenericContext, IMember, ICustomModifierReceiver
    {
        protected Field(Context cx)
        {
            Cx = cx;
        }

        public Label Label { get; set; }

        public void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(DeclaringType);
            trapFile.Write('.');
            trapFile.Write(Name);
        }

        public void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write(idSuffix);
            trapFile.Write('\"');
        }

        private const string idSuffix = ";cil-field";

        public abstract string Name { get; }

        public abstract Type DeclaringType { get; }

        public Location ReportingLocation => throw new NotImplementedException();

        public abstract Type Type { get; }

        public virtual IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var t = Type;
                if (t is ModifiedType mt)
                {
                    t = mt.Unmodified;
                    yield return Tuples.cil_custom_modifiers(this, mt.Modifier, mt.IsRequired);
                }
                yield return Tuples.cil_field(this, DeclaringType, Name, t);
            }
        }

        public void Extract(Context cx2)
        {
            cx2.Populate(this);
        }

        TrapStackBehaviour IEntity.TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public abstract IEnumerable<Type> TypeParameters { get; }

        public abstract IEnumerable<Type> MethodParameters { get; }

        public Context Cx { get; }
    }
}
