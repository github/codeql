namespace System.Web.Http.OData
{
    public class ODataActionParameters : System.Collections.Generic.Dictionary<string, object>
    {
    }

    public class Delta<TEntityType> where TEntityType : class
    {
        public TEntityType GetEntity() => throw null;
        public void Patch(TEntityType original) { }
        public void Put(TEntityType original) { }
        public void CopyChangedValues(TEntityType original) { }
        public void CopyUnchangedValues(TEntityType original) { }
    }
}
