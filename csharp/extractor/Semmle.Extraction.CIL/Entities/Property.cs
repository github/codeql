using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A property.
    /// </summary>
    internal interface IProperty : IExtractedEntity
    {
    }

    /// <summary>
    /// A property.
    /// </summary>
    internal sealed class Property : LabelledEntity, IProperty
    {
        private readonly Handle handle;
        private readonly Type type;
        private readonly PropertyDefinition pd;
        public override string IdSuffix => ";cil-property";
        private readonly GenericContext gc;

        public Property(GenericContext gc, Type type, PropertyDefinitionHandle handle) : base(gc.Cx)
        {
            this.gc = gc;
            this.handle = handle;
            pd = Cx.MdReader.GetPropertyDefinition(handle);
            this.type = type;
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(type);
            trapFile.Write('.');
            trapFile.Write(Cx.GetString(pd.Name));
            trapFile.Write("(");
            var index = 0;
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
                yield return Tuples.metadata_handle(this, Cx.Assembly, MetadataTokens.GetToken(handle));
                var sig = pd.DecodeSignature(Cx.TypeSignatureDecoder, type);

                yield return Tuples.cil_property(this, type, Cx.ShortName(pd.Name), sig.ReturnType);

                var accessors = pd.GetAccessors();
                if (!accessors.Getter.IsNil)
                {
                    var getter = (Method)Cx.CreateGeneric(type, accessors.Getter);
                    yield return getter;
                    yield return Tuples.cil_getter(this, getter);
                }

                if (!accessors.Setter.IsNil)
                {
                    var setter = (Method)Cx.CreateGeneric(type, accessors.Setter);
                    yield return setter;
                    yield return Tuples.cil_setter(this, setter);
                }

                foreach (var c in Attribute.Populate(Cx, this, pd.GetCustomAttributes()))
                    yield return c;
            }
        }
    }
}
