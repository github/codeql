using System;
using System.Collections.Generic;
using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An entity representing a field.
    /// </summary>
    internal abstract class Field : LabelledEntity, IGenericContext, IMember, ICustomModifierReceiver
    {
        protected Field(Context cx) : base(cx)
        {
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(DeclaringType);
            trapFile.Write('.');
            trapFile.Write(Name);
            trapFile.Write(";cil-field");
        }

        public abstract string Name { get; }

        public abstract Type DeclaringType { get; }

        public abstract Type Type { get; }

        public override IEnumerable<IExtractionProduct> Contents
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

        public abstract IEnumerable<Type> TypeParameters { get; }

        public abstract IEnumerable<Type> MethodParameters { get; }
    }
}
