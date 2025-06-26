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
  public void testOgnlParseExpression(@RequestParam String expr) throws Exception { // $ Source
    Object tree = Ognl.parseExpression(expr);
    Ognl.getValue(tree, new HashMap<>(), new Object()); // $ Alert
    Ognl.setValue(tree, new HashMap<>(), new Object()); // $ Alert

    Node node = (Node) tree;
    node.getValue(null, new Object()); // $ Alert
    node.setValue(null, new Object(), new Object()); // $ Alert
  }

  @RequestMapping
  public void testOgnlCompileExpression(@RequestParam String expr) throws Exception { // $ Source
    Node tree = Ognl.compileExpression(null, new Object(), expr);
    Ognl.getValue(tree, new HashMap<>(), new Object()); // $ Alert
    Ognl.setValue(tree, new HashMap<>(), new Object()); // $ Alert

    tree.getValue(null, new Object()); // $ Alert
    tree.setValue(null, new Object(), new Object()); // $ Alert
  }

  @RequestMapping
  public void testOgnlDirectlyToGetSet(@RequestParam String expr) throws Exception { // $ Source
    Ognl.getValue(expr, new Object()); // $ Alert
    Ognl.setValue(expr, new Object(), new Object()); // $ Alert
  }

  @RequestMapping
  public void testStruts(@RequestParam String expr) throws Exception { // $ Source
    OgnlUtil ognl = new OgnlUtil();
    ognl.getValue(expr, new HashMap<>(), new Object()); // $ Alert
    ognl.setValue(expr, new HashMap<>(), new Object(), new Object()); // $ Alert
    new OgnlUtil().callMethod(expr, new HashMap<>(), new Object()); // $ Alert
  }

  @RequestMapping
  public void testExpressionAccessor(@RequestParam String expr) throws Exception { // $ Source
    Node tree = Ognl.compileExpression(null, new Object(), expr);
    ExpressionAccessor accessor = tree.getAccessor();
    accessor.get(null, new Object()); // $ Alert
    accessor.set(null, new Object(), new Object()); // $ Alert

    Ognl.getValue(accessor, null, new Object()); // $ Alert
    Ognl.setValue(accessor, null, new Object()); // $ Alert
  }

  @RequestMapping
  public void testExpressionAccessorSetExpression(@RequestParam String expr) throws Exception { // $ Source
    Node tree = Ognl.compileExpression(null, new Object(), "\"some safe expression\".toString()");
    ExpressionAccessor accessor = tree.getAccessor();
    Node taintedTree = Ognl.compileExpression(null, new Object(), expr);
    accessor.setExpression(taintedTree);
    accessor.get(null, new Object()); // $ Alert
    accessor.set(null, new Object(), new Object()); // $ Alert

    Ognl.getValue(accessor, null, new Object()); // $ Alert
    Ognl.setValue(accessor, null, new Object()); // $ Alert
  }
}
