using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System.Security;
using System.Text;
using System.Text.RegularExpressions;

public class MyHttpHandler
{
    public async Task ProcessAsync(HttpContext ctx)
    {
        string provided = ctx.Request.Query["input"];
        string escaped = SecurityElement.Escape(provided);
        string normalizedKC = escaped.Normalize(NormalizationForm.FormKC); // $result=BAD                    
        await ctx.Response.WriteAsync(normalizedKC);

        string provided2 = ctx.Request.Query["input"];
        string escaped2 = SecurityElement.Escape(provided2);
        string normalizedC = escaped2.Normalize(NormalizationForm.FormC); // $result=BAD
        await ctx.Response.WriteAsync(normalizedC);

        string provided3 = ctx.Request.Query["input"];
        string pattern = @"^<.*>*$";
        Match m = Regex.Match(provided3, pattern, RegexOptions.IgnoreCase);
        if (!m.Success)
        {
            string normalized3 = provided3.Normalize(NormalizationForm.FormKC); // $result=BAD
            await ctx.Response.WriteAsync(normalized3);
        }
        else
        {
            await ctx.Response.WriteAsync("XSS");
        }

        string provided4 = ctx.Request.Query["input"];
        string escaped4 = Regex.Escape(provided4);
        string normalized4 = escaped4.Normalize(NormalizationForm.FormKC); // $result=BAD
        await ctx.Response.WriteAsync(normalized4);

        string provided5 = ctx.Request.Query["input"];
        bool result1 = provided5.StartsWith("abc");
        if (!result1)
        {
            string normalized5 = provided5.Normalize(NormalizationForm.FormKC); // $result=BAD
            await ctx.Response.WriteAsync(normalized5);
        }
        else
        {
            await ctx.Response.WriteAsync("Does start with");
        }
    }
}

public class Program
{
    public static async Task Main(string[] args)
    {
        // Builder
    }
}
