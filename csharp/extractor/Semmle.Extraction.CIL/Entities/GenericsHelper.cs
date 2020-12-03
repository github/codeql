using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    internal class GenericsHelper
    {
        public static TypeTypeParameter[] MakeTypeParameters(Type container, int count)
        {
            var newTypeParams = new TypeTypeParameter[count];
            for (var i = 0; i < newTypeParams.Length; ++i)
            {
                newTypeParams[i] = new TypeTypeParameter(container, container, i);
            }
            return newTypeParams;
        }

        public static string GetNonGenericName(StringHandle name, MetadataReader reader)
        {
            var n = reader.GetString(name);
            return GetNonGenericName(n);
        }

        public static string GetNonGenericName(string name)
        {
            var tick = name.IndexOf('`');
            return tick == -1
                ? name
                : name.Substring(0, tick);
        }

        public static int GetGenericTypeParameterCount(StringHandle name, MetadataReader reader)
        {
            var n = reader.GetString(name);
            return GetGenericTypeParameterCount(n);
        }

        public static int GetGenericTypeParameterCount(string name)
        {
            var tick = name.IndexOf('`');
            return tick == -1
                ? 0
                : int.Parse(name.Substring(tick + 1));
        }
    }
}
