import java.util.HashSet;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UnsafeReflection {

    @GetMapping(value = "uf1")
    public void bad1(HttpServletRequest request) {
        String className = request.getParameter("className");
        try {
            Class clazz = Class.forName(className); //bad
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = "uf2")
    public void bad2(HttpServletRequest request) {
        String className = request.getParameter("className");
        try {
            ClassLoader classLoader = ClassLoader.getSystemClassLoader();
            Class clazz = classLoader.loadClass(className); //bad
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = "uf3")
    public void good1(HttpServletRequest request) throws Exception {
        HashSet<String> hashSet = new HashSet<>();
        hashSet.add("com.example.test1");
        hashSet.add("com.example.test2");
        String className = request.getParameter("className");
        if (hashSet.contains(className)){ //good
            throw new Exception("Class not valid: "  + className);
        }
        ClassLoader classLoader = ClassLoader.getSystemClassLoader();
        Class clazz = classLoader.loadClass(className);
    }

    @GetMapping(value = "uf4")
    public void good2(HttpServletRequest request) throws Exception {
        String className = request.getParameter("className");
        if (!"com.example.test1".equals(className)){ //good
            throw new Exception("Class not valid: "  + className);
        }
        ClassLoader classLoader = ClassLoader.getSystemClassLoader();
        Class clazz = classLoader.loadClass(className);
    }

    @GetMapping(value = "uf5")
    public void good3(HttpServletRequest request) throws Exception {
        String className = request.getParameter("className");
        if (!className.equals("com.example.test1")){ //good
            throw new Exception("Class not valid: "  + className);
        }
        ClassLoader classLoader = ClassLoader.getSystemClassLoader();
        Class clazz = classLoader.loadClass(className);
    }
}