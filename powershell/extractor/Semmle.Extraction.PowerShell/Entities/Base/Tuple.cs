using Semmle.Extraction.PowerShell.Entities;

namespace Semmle.Extraction.PowerShell
{
    /// <summary>
    /// A tuple that is an extraction product.
    /// </summary>
    internal class Tuple : IExtractionProduct
    {
        private readonly Extraction.Tuple tuple;

        public Tuple(string name, params object[] args)
        {
            tuple = new Extraction.Tuple(name, args);
        }

        public void Extract(PowerShellContext cx)
        {
            cx.TrapWriter.Emit(tuple);
        }

        public override string ToString() => tuple.ToString();
    }
}
