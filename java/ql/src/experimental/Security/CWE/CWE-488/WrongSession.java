import java.io.PrintWriter;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class WrongSessionController {

    volatile String name = "test";

    private int timeBase = 1000;

    @RequestMapping("/bad1")
    @ResponseBody
    public void bad1(String greetee, HttpServletResponse response) throws Exception{
        if (!StringUtils.isEmpty(greetee)) {
            timeBase = Integer.parseInt(greetee);
        }

        PrintWriter pw = response.getWriter();
        pw.println("bad1 " + timeBase);
    }

    @RequestMapping("/bad2")
    @ResponseBody
    public void bad2(String greetee, HttpServletResponse response) throws Exception{
        if (!ObjectUtils.isEmpty(greetee)) {
            name = greetee;
        }
        PrintWriter pw = response.getWriter();
        pw.println("bad2 " + name);
    }

    @RequestMapping("/bad3")
    @ResponseBody
    public void bad3(String greetee, HttpServletResponse response) throws Exception{
        boolean result = StringUtils.isEmpty(greetee);
        if (!result) {
            name = greetee;
        }

        PrintWriter pw = response.getWriter();
        pw.println("bad3 " + name);
    }

    @RequestMapping("/good1")
    @ResponseBody
    public void good1(String greetee, HttpServletResponse response) throws Exception{
        boolean result = StringUtils.isEmpty(greetee);
        if (!result) {
            name = greetee;
        }else {
            name = "test";
        }

        PrintWriter pw = response.getWriter();
        pw.println("good1 " + name);
    }

    @RequestMapping("/good2")
    @ResponseBody
    public void good2(String greetee, HttpServletResponse response) throws Exception{
        boolean result = StringUtils.isEmpty(greetee);
        if (result) {
            throw new Exception("greetee is not null");
        }
        name = greetee;
        PrintWriter pw = response.getWriter();
        pw.println("good2 " + name);
    }

    @RequestMapping("/good3")
    @ResponseBody
    public void good3(@RequestParam(value = "interval", required = false, defaultValue = "100") final String interval, HttpServletResponse response) throws Exception{
        if (!StringUtils.isEmpty(interval)) {
            timeBase = Integer.parseInt(interval);
        }
        PrintWriter pw = response.getWriter();
        pw.println("ws1 " + name);
    }
}