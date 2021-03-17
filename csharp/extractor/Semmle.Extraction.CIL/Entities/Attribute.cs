using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Entity representing a CIL attribute.
    /// </summary>
    internal sealed class Attribute : UnlabelledEntity
    {
        private readonly CustomAttributeHandle handle;
        private readonly CustomAttribute attrib;
        private readonly IExtractedEntity @object;

        public Attribute(Context cx, IExtractedEntity @object, CustomAttributeHandle handle) : base(cx)
        {
            attrib = cx.MdReader.GetCustomAttribute(handle);
            this.handle = handle;
            this.@object = @object;
        }

        public override bool Equals(object? obj)
        {
            return obj is Attribute attribute && handle.Equals(attribute.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var constructor = (Method)Context.Create(attrib.Constructor);
                yield return constructor;

                yield return Tuples.cil_attribute(this, @object, constructor);

                CustomAttributeValue<Type> decoded;

                try
                {
                    decoded = attrib.DecodeValue(new CustomAttributeDecoder(Context));
                }
                catch
                {
                    Context.Extractor.Logger.Log(Util.Logging.Severity.Info,
                        $"Attribute decoding is partial. Decoding attribute {constructor.DeclaringType.GetQualifiedName()} failed on {@object}.");
                    yield break;
                }

                for (var index = 0; index < decoded.FixedArguments.Length; ++index)
                {
                    var stringValue = GetStringValue(decoded.FixedArguments[index].Type, decoded.FixedArguments[index].Value);
                    yield return Tuples.cil_attribute_positional_argument(this, index, stringValue);
                }

                foreach (var p in decoded.NamedArguments)
                {
                    var stringValue = GetStringValue(p.Type, p.Value);
                    yield return Tuples.cil_attribute_named_argument(this, p.Name!, stringValue);
                }
            }
        }

        private static string GetStringValue(Type type, object? value)
        {
            if (value is System.Collections.Immutable.ImmutableArray<CustomAttributeTypedArgument<Type>> values)
            {
                return "[" + string.Join(",", values.Select(v => GetStringValue(v.Type, v.Value))) + "]";
            }

            if (type.GetQualifiedName() == "System.Type" &&
                value is Type t)
            {
                return t.GetQualifiedName();
            }

            return value?.ToString() ?? "null";
        }

        public static IEnumerable<IExtractionProduct> Populate(Context cx, IExtractedEntity @object, CustomAttributeHandleCollection attributes)
        {
            foreach (var attrib in attributes)
            {
                yield return new Attribute(cx, @object, attrib);
            }
        }
    }
}
