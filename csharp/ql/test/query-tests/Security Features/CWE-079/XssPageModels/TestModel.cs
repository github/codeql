using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Threading.Tasks;
namespace test;

class TestModel : PageModel {
    public string Name { get; set; } = "abc";

    private string source() { return "x"; }

    public async Task<IActionResult> OnPostAsync() {
        this.Name = source();
        return Page();
    }

    public void OnGet() { 
        Name = source();
    }
}