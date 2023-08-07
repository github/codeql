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
  void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
  }

  String acceptableTypes(String param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

  String unacceptableParamType(File param) { // not an endpoint
    return null;
  }

  File unacceptableReturnType() { // not an endpoint
    return null;
  }

  @XmlJavaTypeAdapter
  File annotatedTypes(@XmlJavaTypeAdapter File param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }
}


@WebServiceProvider
class WebServiceProviderClass { // $ JaxWsEndpoint

  @WebMethod
  void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
  }

  String acceptableTypes(String param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

  String unacceptableParamType(File param) { // not an endpoint
    return null;
  }

  File unacceptableReturnType() { // not an endpoint
    return null;
  }

  @XmlJavaTypeAdapter
  File annotatedTypes(@XmlJavaTypeAdapter File param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }
}


@WebServiceClient
class WebServiceClientClass { // $ JaxWsEndpoint

  @WebMethod
  void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
  }

  String acceptableTypes(String param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

  String unacceptableParamType(File param) { // not an endpoint
    return null;
  }

  File unacceptableReturnType() { // not an endpoint
    return null;
  }

  @XmlJavaTypeAdapter
  File annotatedTypes(@XmlJavaTypeAdapter File param) { // $ JaxWsEndpointRemoteMethod
    return null;
  }

}
