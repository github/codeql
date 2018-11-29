using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Linq;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A property.
    /// </summary>
    interface IProperty : ILabelledEntity
    {
    }

    /// <summary>
    /// A property.
    /// </summary>
    class Property : LabelledEntity, IProperty
    {
        readonly Handle handle;
        readonly Type type;
        readonly PropertyDefinition pd;
        static readonly Id suffix = CIL.Id.Create(";cil-property");

        public Property(GenericContext gc, Type type, PropertyDefinitionHandle handle) : base(gc.cx)
        {
            this.handle = handle;
            pd = cx.mdReader.GetPropertyDefinition(handle);
            this.type = type;

            var id = type.ShortId + gc.cx.Dot + cx.ShortName(pd.Name);
            var signature = pd.DecodeSignature(new SignatureDecoder(), gc);
            id += "(" + CIL.Id.CommaSeparatedList(signature.ParameterTypes.Select(p => p.MakeId(gc))) + ")";
            ShortId = id;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.metadata_handle(this, cx.assembly, handle.GetHashCode());
                var sig = pd.DecodeSignature(cx.TypeSignatureDecoder, type);

                yield return Tuples.cil_property(this, type, cx.ShortName(pd.Name), sig.ReturnType);

                var accessors = pd.GetAccessors();
                if (!accessors.Getter.IsNil)
                {
                    var getter = (Method)cx.CreateGeneric(type, accessors.Getter);
                    yield return getter;
                    yield return Tuples.cil_getter(this, getter);
                }

                if (!accessors.Setter.IsNil)
                {
                    var setter = (Method)cx.CreateGeneric(type, accessors.Setter);
                    yield return setter;
                    yield return Tuples.cil_setter(this, setter);
                }

                foreach (var c in Attribute.Populate(cx, this, pd.GetCustomAttributes()))
                    yield return c;
            }
        }

        public override Id IdSuffix => suffix;
    }
}
