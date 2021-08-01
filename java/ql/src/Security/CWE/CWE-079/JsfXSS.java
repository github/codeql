@FacesRenderer(componentFamily = "", rendererType = "")
public class JsfXSS extends Renderer
{
    @Override
    public void encodeBegin(FacesContext facesContext, UIComponent component) throws IOException
    {
        super.encodeBegin(facesContext, component);

        Map<String, String> requestParameters = facesContext.getExternalContext().getRequestParameterMap();
        String windowId = requestParameters.get("window_id");

        ResponseWriter writer = facesContext.getResponseWriter();
        writer.write("<script type=\"text/javascript\">");
        writer.write("(function(){");
        {
            // BAD: directly output user input.
            writer.write("dswh.init('" + windowId + "','"
                + "......" + "',"
                + -1 + ",{");
        }
        {
            // GOOD: use the method `writeText` that performs escaping appropriate for the markup language being rendered.
            writer.write("dswh.init('");
            writer.writeText(windowId, null);
            writer.write("','"
                    + "......" + "',"
                    + -1 + ",{");
        }
        writer.write("});");
        writer.write("})();");
        writer.write("</script>");
    }
}
