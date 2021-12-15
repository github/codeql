using System;
using System.Web.UI.HtmlControls;

namespace UseOfFileUpload
{
    class Main
    {

        public void Foo()
        {
            HtmlInputFile FileUpload = new HtmlInputFile();
            HttpPostedFile posted = FileUpload.PostedFile; // BAD
        }

    }

}
