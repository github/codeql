using System;
using System.Web;

namespace Sinks;

public class NewSinks
{
    private string tainted;

    // New sink
    public void WrapResponseWrite(object o)
    {
        var response = new HttpResponse();
        response.Write(o);
    }

    // NOT new sink as method is private
    private void PrivateWrapResponseWrite(object o)
    {
        var response = new HttpResponse();
        response.Write(o);
    }

    // New sink
    public void WrapResponseWriteFile(string s)
    {
        var response = new HttpResponse();
        response.WriteFile(s);
    }

    // New sink
    public void WrapFieldResponseWriteFile()
    {
        var response = new HttpResponse();
        response.WriteFile(tainted);
    }

}