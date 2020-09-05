/**
 * Provides classes for working with Spring web requests.
 */

import java

/** An interface for web requests in the Spring framework. */
class SpringWebRequest extends Class {
  SpringWebRequest() {
    this.hasQualifiedName("org.springframework.web.context.request", "WebRequest")
  }
}

/** An interface for web requests in the Spring framework. */
class SpringNativeWebRequest extends Class {
  SpringNativeWebRequest() {
    this.hasQualifiedName("org.springframework.web.context.request", "NativeWebRequest")
  }
}

/** Models Spring `servlet` as well as `portlet` package's `ModelAndView` class. */
class ModelAndView extends Class {
  ModelAndView() {
    hasQualifiedName(["org.springframework.web.servlet", "org.springframework.web.portlet"],
      "ModelAndView")
  }
}

/** Models a call to the Spring `ModelAndView` class's `setViewName` method. */
class SpringModelAndViewSetViewNameCall extends MethodAccess {
  SpringModelAndViewSetViewNameCall() {
    getMethod().getDeclaringType() instanceof ModelAndView and
    getMethod().hasName("setViewName")
  }
}
