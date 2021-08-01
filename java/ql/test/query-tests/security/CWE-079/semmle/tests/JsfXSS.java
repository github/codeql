import java.io.IOException;
import java.util.Map;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;
import javax.faces.render.FacesRenderer;
import javax.faces.render.Renderer;

@FacesRenderer(componentFamily = "", rendererType = "")
public class JsfXSS extends Renderer
{
    @Override
    // BAD: directly output user input.
    public void encodeBegin(FacesContext facesContext, UIComponent component) throws IOException
    {
        super.encodeBegin(facesContext, component);

        Map<String, String> requestParameters = facesContext.getExternalContext().getRequestParameterMap();
        String windowId = requestParameters.get("window_id");

        ResponseWriter writer = facesContext.getResponseWriter();
        writer.write("<script type=\"text/javascript\">");
        writer.write("(function(){");
        writer.write("dswh.init('" + windowId + "','" // $xss
                + "......" + "',"
                + -1 + ",{");
        writer.write("});");
        writer.write("})();");
        writer.write("</script>");
    }

    // GOOD: use the method `writeText` that performs escaping appropriate for the markup language being rendered.
    public void encodeBegin2(FacesContext facesContext, UIComponent component) throws IOException
    {
        super.encodeBegin(facesContext, component);

        Map<String, String> requestParameters = facesContext.getExternalContext().getRequestParameterMap();
        String windowId = requestParameters.get("window_id");

        ResponseWriter writer = facesContext.getResponseWriter();
        writer.write("<script type=\"text/javascript\">");
        writer.write("(function(){");
        writer.write("dswh.init('");
        writer.writeText(windowId, null);
        writer.write("','"
                + "......" + "',"
                + -1 + ",{");
        writer.write("});");
        writer.write("})();");
        writer.write("</script>");
    }
}
