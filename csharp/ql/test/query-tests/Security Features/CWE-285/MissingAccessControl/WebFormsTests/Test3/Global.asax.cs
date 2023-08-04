using System;
using System.Web;
using System.Web.Routing;

public class Global : System.Web.HttpApplication {

    void Application_Start(object sender, EventArgs e) {
        RegisterRoutes(RouteTable.Routes);
    }

    void Application_End(object sender, EventArgs e) { }

    void Application_Error(object sender, EventArgs e) { }

    void Session_Start(object sender, EventArgs e) { }

    void Session_End(object sender, EventArgs e) { }

    static void RegisterRoutes(RouteCollection routes) {
        routes.MapPageRoute("VirtualEditProfile",
            "Virtual/Edit",
            "~/C/EditProfile.aspx",
            false
            );
    }
}