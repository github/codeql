// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

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
