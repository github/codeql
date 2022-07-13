/**
 * @name Beans that are never used within the code
 * @description Beans that are specified but never used are redundant and should be removed.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/spring/unused-bean
 * @tags maintainability
 *       frameworks/spring
 */

import java
import semmle.code.java.frameworks.spring.Spring

/**
 * A `FieldWrite` that writes to the same instance as the enclosing callable.
 */
class InstanceFieldWrite extends FieldWrite {
  InstanceFieldWrite() {
    // Must be in an instance callable
    not getEnclosingCallable().isStatic() and
    // Must be declared in this type or a supertype.
    getEnclosingCallable().getDeclaringType().inherits(getField()) and
    isOwnFieldAccess()
  }
}

/**
 * A conservative approximation of statements that may affect state outside the context of the current
 * class.
 */
class ImpureStmt extends Stmt {
  ImpureStmt() {
    exists(Expr e | e.getEnclosingStmt() = this |
      // Only permit calls to set of whitelisted targets.
      e instanceof Call and
      not e.(Call).getCallee().getDeclaringType().hasQualifiedName("java.util", "Collections")
      or
      // Writing to a field that is not an instance field is a no-no
      e instanceof FieldWrite and not e instanceof InstanceFieldWrite
    )
  }
}

/**
 * Get any non-block stmt in the block, including those nested within blocks.
 */
private Stmt getANestedStmt(BlockStmt block) {
  // Any non-block statement
  not result instanceof BlockStmt and result = block.getAStmt()
  or
  // Or any statement nested in a block
  result = getANestedStmt(block.getAStmt())
}

/**
 * A class whose loading and construction by Spring does not have any side-effects outside the class.
 *
 * This is a conservative approximation.
 */
class SpringPureClass extends Class {
  SpringPureClass() {
    // The only permitted statement in static initializers is the initialization of a static
    // final or effectively final logger fields, or effectively immutable types.
    forall(Stmt s | s = getANestedStmt(getAMember().(StaticInitializer).getBody()) |
      exists(Field f | f = s.(ExprStmt).getExpr().(AssignExpr).getDest().(FieldWrite).getField() |
        (
          // A logger field
          f.getName().toLowerCase() = "logger" or
          f.getName().toLowerCase() = "log" or
          // An immutable type
          f.getType() instanceof ImmutableType
        ) and
        f.isStatic() and
        // Only written to in this statement e.g. final or effectively final
        forall(FieldWrite fw | fw = f.getAnAccess() | fw.getEnclosingStmt() = s)
      )
    ) and
    // No constructor, instance initializer or Spring bean init or setter method that is impure.
    not exists(Callable c, ImpureStmt impureStmt |
      (
        inherits(c.(Method)) or
        c = getAMember()
      ) and
      impureStmt.getEnclosingCallable() = c
    |
      c instanceof InstanceInitializer
      or
      c instanceof Constructor
      or
      // afterPropertiesSet() method called after bean initialization
      c = this.(InitializingBeanClass).getAfterPropertiesSet()
      or
      // Init and setter methods must be pure, because they are called when the bean is initialized
      exists(SpringBean bean | this = bean.getClass() |
        c = bean.getInitMethod() or
        c = bean.getAProperty().getSetterMethod()
      )
      or
      // Setter method by autowiring, either in the XML or by annotation
      c = this.getAMethod().(SpringBeanAutowiredCallable)
      or
      c = this.getAMethod().(SpringBeanXmlAutowiredSetterMethod)
    )
  }
}

/**
 * A Spring class the constructs beans based on the bean identifier.
 */
class SpringBeanFactory extends ClassOrInterface {
  SpringBeanFactory() {
    getAnAncestor().hasQualifiedName("org.springframework.beans.factory", "BeanFactory")
  }

  /**
   * Get a bean constructed by a call to this bean factory.
   */
  SpringBean getAConstructedBean() {
    exists(Method getBean, MethodAccess call |
      getBean.hasName("getBean") and
      call.getMethod() = getBean and
      getBean.getDeclaringType() = this
    |
      result.getBeanIdentifier() = call.getArgument(0).(CompileTimeConstantExpr).getStringValue()
    )
  }
}

/**
 * A `SpringBean` which is meaningfully used within the program.
 *
 * A meaningfully used bean cannot be removed without changing the observable behavior of the program.
 */
class LiveSpringBean extends SpringBean {
  LiveSpringBean() {
    // Must not be needed for side effects due to construction
    // Only loaded by the container when required, so construction cannot have any useful side-effects
    not isLazyInit() and
    // or has no side-effects when constructed
    not getClass() instanceof SpringPureClass
    or
    (
      // If the class does not exist for this bean, or the class is not a source bean, then this is
      // likely to be a definition using a library class, in which case we should consider it to be
      // live.
      not exists(getClass())
      or
      not getClass().fromSource()
      or
      // In alfresco, "webscript" beans should be considered live
      getBeanParent*().getBeanParentName() = "webscript"
      or
      // A live child bean implies this bean is live
      exists(LiveSpringBean child | this = child.getBeanParent())
      or
      // Beans constructed by a bean factory are considered live
      exists(SpringBeanFactory beanFactory | this = beanFactory.getAConstructedBean())
    )
    or
    (
      // Referenced by a live bean, either as a property or argument in the XML
      exists(LiveSpringBean other |
        this = other.getAConstructorArg().getArgRefBean() or
        this = other.getAProperty().getPropertyRefBean()
      )
      or
      // Referenced as a factory bean
      exists(LiveSpringBean springBean | this = springBean.getFactoryBean())
      or
      // Injected by @Autowired annotation
      exists(SpringBeanAutowiredCallable autowiredCallable |
        // The callable must be in a live class
        autowiredCallable.getEnclosingSpringBean() instanceof LiveSpringBean or
        autowiredCallable.getEnclosingSpringComponent().isLive()
      |
        // This bean is injected into it
        this = autowiredCallable.getAnInjectedBean()
      )
      or
      // Injected by @Autowired annotation on field
      exists(SpringBeanAutowiredField autowiredField |
        // The field must be in a live class
        autowiredField.getEnclosingSpringBean() instanceof LiveSpringBean or
        autowiredField.getEnclosingSpringComponent().isLive()
      |
        // This bean is injected into it
        this = autowiredField.getInjectedBean()
      )
      or
      // Injected by autowired specified in XML
      exists(SpringBeanXmlAutowiredSetterMethod setterMethod |
        // The config method must be on a live bean
        setterMethod.getDeclaringType().(SpringBeanRefType).getSpringBean() instanceof
          LiveSpringBean
      |
        // This bean is injected into it
        this = setterMethod.getInjectedBean()
      )
    )
  }
}

/**
 * A `SpringBean` that can be safely removed from the program without changing overall behavior.
 */
class UnusedSpringBean extends SpringBean {
  UnusedSpringBean() { not this instanceof LiveSpringBean }
}

from UnusedSpringBean unused
select unused, "The spring bean " + unused.getBeanIdentifier() + " is never used."
