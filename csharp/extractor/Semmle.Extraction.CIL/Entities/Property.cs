using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A property.
    /// </summary>
    interface IProperty : IExtractedEntity
    {
    }

    /// <summary>
    /// A property.
    /// </summary>
    sealed class Property : LabelledEntity, IProperty
    {
        readonly Handle handle;
        readonly Type type;
        readonly PropertyDefinition pd;
        public override string IdSuffix => ";cil-property";
        readonly GenericContext gc;

        public Property(GenericContext gc, Type type, PropertyDefinitionHandle handle) : base(gc.cx)
        {
            this.gc = gc;
            this.handle = handle;
            pd = cx.mdReader.GetPropertyDefinition(handle);
            this.type = type;
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(type);
            trapFile.Write('.');
            trapFile.Write(cx.GetString(pd.Name));
            trapFile.Write("(");
            int index = 0;
            var signature = pd.DecodeSignature(new SignatureDecoder(), gc);
            foreach (var param in signature.ParameterTypes)
            {
                trapFile.WriteSeparator(",", ref index);
                param.WriteId(trapFile, gc);
            }
            trapFile.Write(")");
        }

        public override bool Equals(object? obj)
        {
            return obj is Property property && Equals(handle, property.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.metadata_handle(this, cx.assembly, MetadataTokens.GetToken(handle));
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
    }
}
