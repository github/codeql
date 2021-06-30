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
