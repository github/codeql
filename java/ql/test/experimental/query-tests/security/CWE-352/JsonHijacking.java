import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Random;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class JsonHijacking {

    private static HashMap hashMap = new HashMap();

    static {
        hashMap.put("username","admin");
        hashMap.put("password","123456");
    }


    @GetMapping(value = "jsonp1")
    @ResponseBody
    public String bad1(HttpServletRequest request) {
        String resultStr = null;
        String jsonpCallback = request.getParameter("jsonpCallback");

        Gson gson = new Gson();
        String result = gson.toJson(hashMap);
        resultStr = jsonpCallback + "(" + result + ")";
        return resultStr;
    }

    @GetMapping(value = "jsonp2")
    @ResponseBody
    public String bad2(HttpServletRequest request) {
        String resultStr = null;
        String jsonpCallback = request.getParameter("jsonpCallback");

        resultStr = jsonpCallback + "(" + JSONObject.toJSONString(hashMap) + ")";

        return resultStr;
    }

    @GetMapping(value = "jsonp3")
    @ResponseBody
    public String bad3(HttpServletRequest request) {
        String resultStr = null;
        String jsonpCallback = request.getParameter("jsonpCallback");
        String jsonStr = getJsonStr(hashMap);
        resultStr = jsonpCallback + "(" + jsonStr + ")";
        return resultStr;
    }

    @GetMapping(value = "jsonp4")
    @ResponseBody
    public String bad4(HttpServletRequest request) {
        String resultStr = null;
        String jsonpCallback = request.getParameter("jsonpCallback");
        String restr = JSONObject.toJSONString(hashMap);
        resultStr = jsonpCallback + "(" + restr + ");";
        return resultStr;
    }

    @GetMapping(value = "jsonp5")
    @ResponseBody
    public void bad5(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        String jsonpCallback = request.getParameter("jsonpCallback");
        PrintWriter pw = null;
        Gson gson = new Gson();
        String result = gson.toJson(hashMap);

        String resultStr = null;
        pw = response.getWriter();
        resultStr = jsonpCallback + "(" + result + ")";
        pw.println(resultStr);
    }

    @GetMapping(value = "jsonp6")
    @ResponseBody
    public void bad6(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        String jsonpCallback = request.getParameter("jsonpCallback");
        PrintWriter pw = null;
        ObjectMapper mapper = new ObjectMapper();
        String result = mapper.writeValueAsString(hashMap);
        String resultStr = null;
        pw = response.getWriter();
        resultStr = jsonpCallback + "(" + result + ")";
        pw.println(resultStr);
    }

    @GetMapping(value = "jsonp7")
    @ResponseBody
    public String good(HttpServletRequest request) {
        String resultStr = null;
        String jsonpCallback = request.getParameter("jsonpCallback");

        String val = "";
        Random random = new Random();
        for (int i = 0; i < 10; i++) {
            val += String.valueOf(random.nextInt(10));
        }
        // good
        jsonpCallback = jsonpCallback + "_" + val;
        String jsonStr = getJsonStr(hashMap);
        resultStr = jsonpCallback + "(" + jsonStr + ")";
        return resultStr;
    }

    public static String getJsonStr(Object result) {
        return JSONObject.toJSONString(result);
    }
}
