using System;
using System.Web.UI.HtmlControls;

namespace UseOfHtmlInputHidden
{
    class Main
    {

        public void Foo()
        {
            HtmlInputHidden field = new HtmlInputHidden(); // BAD
        }

    }

}
