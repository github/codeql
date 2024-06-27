/**
 * Provides classes for working with Spring web requests.
 */

import java

/** An interface for web requests in the Spring framework. */
class SpringWebRequest extends Interface {
  SpringWebRequest() {
    this.hasQualifiedName("org.springframework.web.context.request", "WebRequest")
  }
}

/** An interface for web requests in the Spring framework. */
class SpringNativeWebRequest extends Interface {
  SpringNativeWebRequest() {
    this.hasQualifiedName("org.springframework.web.context.request", "NativeWebRequest")
  }
}

/**
 * A Spring `ModelAndView` class. This is either
 * `org.springframework.web.servlet.ModelAndView` or
 * `org.springframework.web.portlet.ModelAndView`.
 */
class ModelAndView extends Class {
  ModelAndView() {
    this.hasQualifiedName(["org.springframework.web.servlet", "org.springframework.web.portlet"],
      "ModelAndView")
  }
}

/** A call to the Spring `ModelAndView.setViewName` method. */
class SpringModelAndViewSetViewNameCall extends MethodCall {
  SpringModelAndViewSetViewNameCall() {
    this.getMethod().getDeclaringType() instanceof ModelAndView and
    this.getMethod().hasName("setViewName")
  }
}
