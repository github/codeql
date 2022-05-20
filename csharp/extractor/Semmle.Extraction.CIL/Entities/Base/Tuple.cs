namespace Semmle.Extraction.CIL
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

        public void Extract(Context cx)
        {
            cx.TrapWriter.Emit(tuple);
        }

        public override string ToString() => tuple.ToString();
    }
}
