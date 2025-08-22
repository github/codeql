package com.semmle.e;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Live because it is in a live package, and has a {@code RestController} annotation which is
 * annotated with {@code @Controller} which is annotated with {@code @Component}, making it a
 * component.
 */
@RestController
public class LiveRestController {

  @RequestMapping(value = {"/"})
  public String testMethod() {
    return "result";
  }
}
