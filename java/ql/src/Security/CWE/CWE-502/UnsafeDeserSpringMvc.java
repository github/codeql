import com.alibaba.fastjson.JSON;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.yaml.snakeyaml.Yaml;

import javax.servlet.http.HttpServletRequest;

@RestController
public class UnsafeDeserSpringMvc {

    @GetMapping(value = "index")
    public void index(HttpServletRequest request){
        Yaml yaml = new Yaml();
        yaml.load(request.getParameter("str"));
        Runtime runtime = Runtime.getRuntime();
        HttpServletRequest request1 = request;
    }

    @GetMapping(value = "fastjson")
    public void fastjson(HttpServletRequest request){
        JSON.parseObject(request.getParameter("str"));
    }

    @GetMapping(value = "test")
    public void fastjson1(String request){
        String temp = request;
        JSON.parseObject(temp);
    }

    @GetMapping(value = "test1")
    public void fastjson2(String request){
        System.out.println(request);
        JSON.parseObject(request);
    }

    @GetMapping(value = "test2")
    public void fastjson3(@RequestBody String request){
        JSON.parseObject(request);
    }

    public void fastjson4(@RequestBody String request){
        JSON.parseObject(request);
    }
}
