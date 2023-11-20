import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UnsafeUrlForward {

	@GetMapping("/bad1")
	public ModelAndView bad1(String url) {
		return new ModelAndView(url);
	}

	@GetMapping("/bad2")
	public ModelAndView bad2(String url) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName(url);
		return modelAndView;
	}

	@GetMapping("/bad3")
	public String bad3(String url) {
		return "forward:" + url + "/swagger-ui/index.html";
	}

	@GetMapping("/bad4")
	public ModelAndView bad4(String url) {
		ModelAndView modelAndView = new ModelAndView("forward:" + url);
		return modelAndView;
	}

	@GetMapping("/bad5")
	public void bad5(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher(url).include(request, response);
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/bad6")
	public void bad6(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/WEB-INF/jsp/" + url + ".jsp").include(request, response);
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/bad7")
	public void bad7(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/WEB-INF/jsp/" + url + ".jsp").forward(request, response);
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/good1")
	public void good1(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/index.jsp?token=" + url).forward(request, response);
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
