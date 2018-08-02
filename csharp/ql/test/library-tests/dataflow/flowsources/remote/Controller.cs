// semmle-extractor-options: /r:System.Net.dll /r:System.Web.dll /r:System.Net.HttpListener.dll /r:System.Collections.Specialized.dll /r:System.Private.Uri.dll /r:System.Security.Cryptography.X509Certificates.dll ${testdir}/../../../../resources/stubs/System.Web.cs

using System.Web.Http;
using System.Web.Mvc;

public class SampleData
{
    public string Tainted;
}

class MyMvcController : Controller
{
    public string ActionMethod(SampleData sampleData, string taint) => sampleData + taint;
}

class MyHttpController : ApiController
{
    public string ActionMethod(SampleData sampleData, string taint) => sampleData + taint;
}
