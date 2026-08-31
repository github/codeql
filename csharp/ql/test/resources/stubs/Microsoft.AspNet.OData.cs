namespace Microsoft.AspNet.OData
{
    public class ODataActionParameters : System.Collections.Generic.Dictionary<string, object>
    {
        public ODataActionParameters() => throw null;
    }

    public class Delta<TStructuralType> where TStructuralType : class
    {
        public Delta() => throw null;
        public TStructuralType GetInstance() => throw null;
        public void Patch(TStructuralType original) => throw null;
        public void Put(TStructuralType original) => throw null;
        public void CopyChangedValues(TStructuralType original) => throw null;
        public void CopyUnchangedValues(TStructuralType original) => throw null;
    }
}
