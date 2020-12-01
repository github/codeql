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
        private readonly IEntity @object;

        public Attribute(Context cx, IEntity @object, CustomAttributeHandle handle) : base(cx)
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
                var constructor = (Method)Cx.Create(attrib.Constructor);
                yield return constructor;

                yield return Tuples.cil_attribute(this, @object, constructor);

                CustomAttributeValue<Type> decoded;

                try
                {
                    decoded = attrib.DecodeValue(new CustomAttributeDecoder(Cx));
                }
                catch (NotImplementedException)
                {
                    // Attribute decoding is only partial at this stage.
                    yield break;
                }

                for (var index = 0; index < decoded.FixedArguments.Length; ++index)
                {
                    var value = decoded.FixedArguments[index].Value;
                    var stringValue = GetStringValue(value);
                    yield return Tuples.cil_attribute_positional_argument(this, index, stringValue);
                }

                foreach (var p in decoded.NamedArguments)
                {
                    var value = p.Value;
                    var stringValue = GetStringValue(value);
                    yield return Tuples.cil_attribute_named_argument(this, p.Name, stringValue);
                }
            }
        }

        private static string GetStringValue(object? value)
        {
            if (value is System.Collections.Immutable.ImmutableArray<CustomAttributeTypedArgument<Type>> values)
            {
                return "[" + string.Join(",", values.Select(v => v.Value?.ToString() ?? "null")) + "]";
            }

            return value?.ToString() ?? "null";
        }

        public static IEnumerable<IExtractionProduct> Populate(Context cx, IEntity @object, CustomAttributeHandleCollection attributes)
        {
            foreach (var attrib in attributes)
            {
                yield return new Attribute(cx, @object, attrib);
            }
        }
    }
}
