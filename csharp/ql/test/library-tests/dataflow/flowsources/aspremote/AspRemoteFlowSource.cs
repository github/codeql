using Microsoft.AspNetCore.Mvc;

namespace Testing
{

    public class ViewModel
    {
        public string RequestId { get; set; }

        public object Query;
    }

    public class TestController : Controller
    {
        public object MyAction(ViewModel viewModel)
        {
            throw null;
        }
    }
}