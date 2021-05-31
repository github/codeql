import java.io.ByteArrayInputStream;
import java.io.Reader;
import java.io.StringReader;
import javax.servlet.http.HttpServletRequest;
import org.springframework.oxm.xstream.XStreamMarshaller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class XStreamMarshallerTest {

	@GetMapping(value = "XStreamMarshaller1")
	public void bad1(HttpServletRequest request) throws Exception {
		XStreamMarshaller xStreamMarshaller = new XStreamMarshaller();
		byte[] serializedData = request.getParameter("data").getBytes();
		xStreamMarshaller.unmarshalInputStream(new ByteArrayInputStream(serializedData)); //bad
	}

	@GetMapping(value = "XStreamMarshaller2")
	public void bad2(HttpServletRequest request) throws Exception {
		XStreamMarshaller xStreamMarshaller = new XStreamMarshaller();
		byte[] serializedData = request.getParameter("data").getBytes();
		xStreamMarshaller.unmarshalInputStream(new ByteArrayInputStream(serializedData), null); //bad
	}

	@GetMapping(value = "XStreamMarshaller3")
	public void bad3(HttpServletRequest request) throws Exception {
		XStreamMarshaller xStreamMarshaller = new XStreamMarshaller();
		Reader reader = new StringReader(request.getParameter("data"));
		xStreamMarshaller.unmarshalReader(reader); //bad
	}

	@GetMapping(value = "XStreamMarshaller4")
	public void bad4(HttpServletRequest request) throws Exception {
		XStreamMarshaller xStreamMarshaller = new XStreamMarshaller();
		Reader reader = new StringReader(request.getParameter("data"));
		xStreamMarshaller.unmarshalReader(reader,null); //bad
	}
}
