import javax.jws.WebMethod;
import javax.jws.WebService;
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

}

@WebServiceProvider
class WebServiceProviderClass { // $ JaxWsEndpoint

  @WebMethod
  void WebMethodMethod() { // $ JaxWsEndpointRemoteMethod
  }

  @WebEndpoint
  void WebEndpointMethod() { // $ JaxWsEndpointRemoteMethod
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

}
