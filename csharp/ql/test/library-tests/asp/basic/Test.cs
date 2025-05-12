// semmle-extractor-options: /nostdlib /noconfig
// semmle-extractor-options: --load-sources-from-project:${testdir}/../../../resources/stubs/_frameworks/Microsoft.AspNetCore.App/Microsoft.AspNetCore.App.csproj
// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs

using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Test
{

    class CodeBehindPage : Page
    {
        public string chooseImage()
        {
            return "some url";
        }
    }
}
