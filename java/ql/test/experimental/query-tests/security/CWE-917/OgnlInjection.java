import ognl.Node;
import ognl.Ognl;

import java.util.HashMap;

import com.opensymphony.xwork2.ognl.OgnlUtil;

import org.springframework.web.bind.annotation.RequestParam;

public class OgnlInjection {
  public void testOgnlParseExpression(@RequestParam String expr) throws Exception {
    Object tree = Ognl.parseExpression(expr);
    Ognl.getValue(tree, new HashMap<>(), new Object());
    Ognl.setValue(tree, new HashMap<>(), new Object());

    Node node = (Node) tree;
    node.getValue(null, new Object());
    node.setValue(null, new Object(), new Object());
  }

  public void testOgnlCompileExpression(@RequestParam String expr) throws Exception {
    Node tree = Ognl.compileExpression(null, new Object(), expr);
    Ognl.getValue(tree, new HashMap<>(), new Object());
    Ognl.setValue(tree, new HashMap<>(), new Object());

    tree.getValue(null, new Object());
    tree.setValue(null, new Object(), new Object());
  }

  public void testOgnlDirectlyToGetSet(@RequestParam String expr) throws Exception {
    Ognl.getValue(expr, new Object());
    Ognl.setValue(expr, new Object(), new Object());
  }

  public void testStruts(@RequestParam String expr) throws Exception {
    OgnlUtil ognl = new OgnlUtil();
    ognl.getValue(expr, new HashMap<>(), new Object());
    ognl.setValue(expr, new HashMap<>(), new Object(), new Object());
    new OgnlUtil().callMethod(expr, new HashMap<>(), new Object());
  }
}
