using System;
using System.IO;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Web.UI.WebControls;

public class InappropriateEncoding
{
    public void Sql(string value)
    {
        var encodedValue = Encode(value); // $ Source=r2
        using (var connection = new SqlConnection(""))
        {
            var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + encodedValue + "' ORDER BY PRICE";
            // BAD
            var adapter = new SqlDataAdapter(query1, connection); // $ Alert=r2 Alert=r3

            var query2 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY=@category ORDER BY PRICE";
            // GOOD
            adapter = new SqlDataAdapter(query2, connection);
            var parameter = new SqlParameter("category", encodedValue);
            adapter.SelectCommand.Parameters.Add(parameter);
        }
    }

    public void Html(string value, Label label, System.Windows.Forms.HtmlElement html)
    {
        // BAD
        label.Text = Encode(value); // $ Alert=r4 Alert=r4
        label.Text = HttpUtility.UrlEncode(value); // $ Alert=r5 Alert=r5
        label.Text = HttpUtility.UrlEncode(HttpUtility.HtmlEncode(value)); // $ Alert=r6 Alert=r6
        var encodedValue = HttpUtility.UrlEncode(value); // $ Source=r7 Source=r8 Source=r9
        html.SetAttribute("a", encodedValue); // $ Alert=r7 Alert=r8 Alert=r9
        label.Text = "<img src=\"" + encodedValue + "\" />"; // $ Alert=r8 Alert=r7 Alert=r9
        label.Text = string.Format("<img src=\"{0}\" />", encodedValue); // $ Alert=r9 Alert=r7 Alert=r8

        // GOOD
        label.Text = HttpUtility.HtmlEncode(value);
        label.Text = HttpUtility.HtmlEncode(HttpUtility.UrlEncode(value));
        encodedValue = HttpUtility.HtmlAttributeEncode(encodedValue);
        html.SetAttribute("a", encodedValue);
        label.Text = "<img src=\"" + encodedValue + "\" />";
        label.Text = string.Format("<img src=\"{0}\" />", encodedValue);
        encodedValue = HttpUtility.HtmlEncode(encodedValue);
        html.SetAttribute("a", encodedValue);
        label.Text = "<img src=\"" + encodedValue + "\" />";
        label.Text = string.Format("<img src=\"{0}\" />", encodedValue);
    }

    public void Url(string value, HttpServerUtility util, HttpContext ctx)
    {
        // BAD
        var encodedValue = HttpUtility.HtmlEncode(value); // $ Source=r10
        ctx.Response.Redirect(encodedValue); // $ Alert=r10

        // GOOD
        ctx.Response.Redirect(HttpUtility.UrlEncode(encodedValue));
        ctx.Response.Redirect(util.UrlEncode(encodedValue));
        ctx.Response.Redirect(WebUtility.UrlEncode(encodedValue));
    }

    static string Encode(string value)
    {
        return value.Replace("\"", "\\\""); // $ Source=r3
    }
}
