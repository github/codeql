// Test case for
// CWE-918: Server-Side Request Forgery (SSRF)
// https://cwe.mitre.org/data/definitions/918.html

package test.cwe918.cwe.examples;

import java.io.IOException;
import java.net.URI;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.CompletionStageRxInvoker;
import javax.ws.rs.client.InvocationCallback;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Link;
import javax.ws.rs.core.UriBuilder;

public class JxRsBad extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
        Client client = ClientBuilder.newClient();
		String userInput = request.getParameter("webhook");

		client.target(userInput).request().get();
        client.target(userInput).path("webhook").request().get();
        client.target(URI.create(userInput)).request().get();
        client.target(UriBuilder.fromPath(userInput)).request().get();
        client.target(Link.fromPath(userInput).build()).request().get();
        client.invocation(Link.fromPath(userInput).build()).get();

        client.target(UriBuilder.fromPath(userInput)).request().get();
        client.target(UriBuilder.fromUri(userInput)).request().get();
        client.target(UriBuilder.fromUri(URI.create(userInput))).request().get();
        client.target(UriBuilder.fromLink(Link.fromPath(userInput).build())).request().get();
        client.target(UriBuilder.fromPath("https://safe.domain.com").host(userInput)).request().get();
        client.target(UriBuilder.fromPath(userInput).path("webhook")).request().get();
        client.target(UriBuilder.fromPath("https://safe.domain.com").uri(userInput)).request().get();
        client.target(UriBuilder.fromPath("https://safe.domain.com").uri(URI.create(userInput))).request().get();
        client.target(UriBuilder.fromUri(userInput).build()).request().get();
        client.target(UriBuilder.fromUri(userInput).buildFromEncoded()).request().get();
        client.target(UriBuilder.fromUri(userInput).buildFromEncodedMap(new HashMap<>())).request().get();
        client.target(UriBuilder.fromUri(userInput).buildFromMap(new HashMap<>())).request().get();
        client.target(UriBuilder.fromUri(userInput).buildFromMap(new HashMap<>(), true)).request().get();

        client.target(Link.fromPath(userInput).build()).request().get();
        client.target(Link.fromUri(userInput).build()).request().get();
        client.target(Link.fromUri(URI.create(userInput)).build()).request().get();
        client.target(Link.fromUriBuilder(UriBuilder.fromPath(userInput)).build()).request().get();
        client.target(Link.fromLink(Link.fromPath(userInput).build()).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").uri(userInput).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").uri(URI.create(userInput)).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").link(Link.fromPath(userInput).build()).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").link(userInput).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").uriBuilder(UriBuilder.fromPath(userInput)).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").baseUri(userInput).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").baseUri(URI.create(userInput)).build()).request().get();
        client.target(Link.fromPath("https://safe.domain.com").buildRelativized(URI.create(userInput))).request().get();
        client.target(Link.fromPath(userInput).title("title").type("type").build()).request().get();

        client.target(userInput).request().get();
        client.target(userInput).request().get(TestClass.class);
        client.target(userInput).request().get(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().post(null);
        client.target(userInput).request().post(null, TestClass.class);
        client.target(userInput).request().post(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().delete();
        client.target(userInput).request().delete(TestClass.class);
        client.target(userInput).request().delete(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().put(null);
        client.target(userInput).request().put(null, TestClass.class);
        client.target(userInput).request().put(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().options();
        client.target(userInput).request().options(TestClass.class);
        client.target(userInput).request().options(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().head();
        client.target(userInput).request().trace();
        client.target(userInput).request().trace(TestClass.class);
        client.target(userInput).request().trace(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().method("GET");
        client.target(userInput).request().method("GET", TestClass.class);
        client.target(userInput).request().method("GET", GenericType.forInstance(new TestClass()));
        client.target(userInput).request().method("POST");
        client.target(userInput).request().method("POST", null, TestClass.class);
        client.target(userInput).request().method("POST", null, GenericType.forInstance(new TestClass()));

        InvocationCallback cb = new InvocationCallback() {
            @Override
            public void completed(Object o) { }
            @Override
            public void failed(Throwable throwable) { }
        };
        client.target(userInput).request().async().get();
        client.target(userInput).request().async().get(TestClass.class);
        client.target(userInput).request().async().get(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().get(cb);
        client.target(userInput).request().async().post(null);
        client.target(userInput).request().async().post(null, TestClass.class);
        client.target(userInput).request().async().post(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().post(null, cb);
        client.target(userInput).request().async().delete();
        client.target(userInput).request().async().delete(TestClass.class);
        client.target(userInput).request().async().delete(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().delete(cb);
        client.target(userInput).request().async().put(null);
        client.target(userInput).request().async().put(null, TestClass.class);
        client.target(userInput).request().async().put(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().put(null, cb);
        client.target(userInput).request().async().options();
        client.target(userInput).request().async().options(TestClass.class);
        client.target(userInput).request().async().options(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().options(cb);
        client.target(userInput).request().async().head();
        client.target(userInput).request().async().head(cb);
        client.target(userInput).request().async().trace();
        client.target(userInput).request().async().trace(TestClass.class);
        client.target(userInput).request().async().trace(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().trace(cb);
        client.target(userInput).request().async().method("GET");
        client.target(userInput).request().async().method("GET", TestClass.class);
        client.target(userInput).request().async().method("GET", GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().method("GET", cb);
        client.target(userInput).request().async().method("POST");
        client.target(userInput).request().async().method("POST", null, TestClass.class);
        client.target(userInput).request().async().method("POST", null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().async().method("POST", null, cb);

        client.target(userInput).request().rx().get();
        client.target(userInput).request().rx().get(TestClass.class);
        client.target(userInput).request().rx().get(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().post(null);
        client.target(userInput).request().rx().post(null, TestClass.class);
        client.target(userInput).request().rx().post(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().delete();
        client.target(userInput).request().rx().delete(TestClass.class);
        client.target(userInput).request().rx().delete(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().put(null);
        client.target(userInput).request().rx().put(null, TestClass.class);
        client.target(userInput).request().rx().put(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().options();
        client.target(userInput).request().rx().options(TestClass.class);
        client.target(userInput).request().rx().options(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().head();
        client.target(userInput).request().rx().trace();
        client.target(userInput).request().rx().trace(TestClass.class);
        client.target(userInput).request().rx().trace(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().method("GET");
        client.target(userInput).request().rx().method("GET", TestClass.class);
        client.target(userInput).request().rx().method("GET", GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx().method("POST");
        client.target(userInput).request().rx().method("POST", null, TestClass.class);
        client.target(userInput).request().rx().method("POST", null, GenericType.forInstance(new TestClass()));

        client.target(userInput).request().rx(CompletionStageRxInvoker.class).get();
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).get(TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).get(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).post(null);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).post(null, TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).post(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).delete();
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).delete(TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).delete(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).put(null);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).put(null, TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).put(null, GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).options();
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).options(TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).options(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).head();
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).trace();
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).trace(TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).trace(GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).method("GET");
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).method("GET", TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).method("GET", GenericType.forInstance(new TestClass()));
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).method("POST");
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).method("POST", null, TestClass.class);
        client.target(userInput).request().rx(CompletionStageRxInvoker.class).method("POST", null, GenericType.forInstance(new TestClass()));
	}

    static class TestClass {}
}
