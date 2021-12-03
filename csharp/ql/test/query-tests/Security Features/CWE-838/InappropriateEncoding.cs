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
        var encodedValue = Encode(value);
        using (var connection = new SqlConnection(""))
        {
            var query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='" + encodedValue + "' ORDER BY PRICE";
            // BAD
            var adapter = new SqlDataAdapter(query1, connection);

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
        label.Text = Encode(value);
        label.Text = HttpUtility.UrlEncode(value);
        label.Text = HttpUtility.UrlEncode(HttpUtility.HtmlEncode(value));
        var encodedValue = HttpUtility.UrlEncode(value);
        html.SetAttribute("a", encodedValue);
        label.Text = "<img src=\"" + encodedValue + "\" />";
        label.Text = string.Format("<img src=\"{0}\" />", encodedValue);

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
        var encodedValue = HttpUtility.HtmlEncode(value);
        ctx.Response.Redirect(encodedValue);

        // GOOD
        ctx.Response.Redirect(HttpUtility.UrlEncode(encodedValue));
        ctx.Response.Redirect(util.UrlEncode(encodedValue));
        ctx.Response.Redirect(WebUtility.UrlEncode(encodedValue));
    }

    static string Encode(string value)
    {
        return value.Replace("\"", "\\\"");
    }
}
