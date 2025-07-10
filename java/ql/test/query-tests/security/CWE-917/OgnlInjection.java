import ognl.Node;
import ognl.Ognl;
import ognl.enhance.ExpressionAccessor;

import java.util.HashMap;

import com.opensymphony.xwork2.ognl.OgnlUtil;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class OgnlInjection {
  @RequestMapping
  public void testOgnlParseExpression(@RequestParam String expr) throws Exception {
    Object tree = Ognl.parseExpression(expr);
    Ognl.getValue(tree, new HashMap<>(), new Object()); // $hasOgnlInjection
    Ognl.setValue(tree, new HashMap<>(), new Object()); // $hasOgnlInjection

    Node node = (Node) tree;
    node.getValue(null, new Object()); // $hasOgnlInjection
    node.setValue(null, new Object(), new Object()); // $hasOgnlInjection
  }

  @RequestMapping
  public void testOgnlCompileExpression(@RequestParam String expr) throws Exception {
    Node tree = Ognl.compileExpression(null, new Object(), expr);
    Ognl.getValue(tree, new HashMap<>(), new Object()); // $hasOgnlInjection
    Ognl.setValue(tree, new HashMap<>(), new Object()); // $hasOgnlInjection

    tree.getValue(null, new Object()); // $hasOgnlInjection
    tree.setValue(null, new Object(), new Object()); // $hasOgnlInjection
  }

  @RequestMapping
  public void testOgnlDirectlyToGetSet(@RequestParam String expr) throws Exception {
    Ognl.getValue(expr, new Object()); // $hasOgnlInjection
    Ognl.setValue(expr, new Object(), new Object()); // $hasOgnlInjection
  }

  @RequestMapping
  public void testStruts(@RequestParam String expr) throws Exception {
    OgnlUtil ognl = new OgnlUtil();
    ognl.getValue(expr, new HashMap<>(), new Object()); // $hasOgnlInjection
    ognl.setValue(expr, new HashMap<>(), new Object(), new Object()); // $hasOgnlInjection
    new OgnlUtil().callMethod(expr, new HashMap<>(), new Object()); // $hasOgnlInjection
  }

  @RequestMapping
  public void testExpressionAccessor(@RequestParam String expr) throws Exception {
    Node tree = Ognl.compileExpression(null, new Object(), expr);
    ExpressionAccessor accessor = tree.getAccessor();
    accessor.get(null, new Object()); // $hasOgnlInjection
    accessor.set(null, new Object(), new Object()); // $hasOgnlInjection

    Ognl.getValue(accessor, null, new Object()); // $hasOgnlInjection
    Ognl.setValue(accessor, null, new Object()); // $hasOgnlInjection
  }

  @RequestMapping
  public void testExpressionAccessorSetExpression(@RequestParam String expr) throws Exception {
    Node tree = Ognl.compileExpression(null, new Object(), "\"some safe expression\".toString()");
    ExpressionAccessor accessor = tree.getAccessor();
    Node taintedTree = Ognl.compileExpression(null, new Object(), expr);
    accessor.setExpression(taintedTree);
    accessor.get(null, new Object()); // $hasOgnlInjection
    accessor.set(null, new Object(), new Object()); // $hasOgnlInjection

    Ognl.getValue(accessor, null, new Object()); // $hasOgnlInjection
    Ognl.setValue(accessor, null, new Object()); // $hasOgnlInjection
  }
}
