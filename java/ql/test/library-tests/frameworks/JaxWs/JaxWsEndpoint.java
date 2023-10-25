import java.io.File;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceProvider;

@WebService
class WebServiceClass { // $ JaxWsEndpoint

  @WebMethod
  public void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  public void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
  }

  public String acceptableTypes(String param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

  public String unacceptableParamType(File param) { // not an endpoint
    return null;
  }

  public File unacceptableReturnType() { // not an endpoint
    return null;
  }

  @XmlJavaTypeAdapter
  public File annotatedTypes(@XmlJavaTypeAdapter File param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }
}


@WebServiceProvider
class WebServiceProviderClass { // $ JaxWsEndpoint

  @WebMethod
  public void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  public void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
  }

  public String acceptableTypes(String param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

  public String unacceptableParamType(File param) { // not an endpoint
    return null;
  }

  public File unacceptableReturnType() { // not an endpoint
    return null;
  }

  @XmlJavaTypeAdapter
  public File annotatedTypes(@XmlJavaTypeAdapter File param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }
}


@WebServiceClient
class WebServiceClientClass { // $ JaxWsEndpoint

  @WebMethod
  public void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  public void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
  }

  public String acceptableTypes(String param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

  public String unacceptableParamType(File param) { // not an endpoint
    return null;
  }

  public File unacceptableReturnType() { // not an endpoint
    return null;
  }

  @XmlJavaTypeAdapter
  public File annotatedTypes(@XmlJavaTypeAdapter File param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

}
