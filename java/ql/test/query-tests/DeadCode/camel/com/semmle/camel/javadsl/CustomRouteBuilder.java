package com.semmle.camel.javadsl;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;

public class CustomRouteBuilder extends RouteBuilder {
  @Override
  public void configure() throws Exception {
    from("direct:test")
        .to("bean:dslToTarget")
        .bean(DSLBeanTarget.class)
        .bean(new DSLBeanObjectTarget())
        .beanRef("dslBeanRefTarget")
        .filter()
        .method("dslMethodBean");
  }

  public static void main(String[] args) throws Exception {
    DefaultCamelContext camelContext = new DefaultCamelContext();
    camelContext.addRoutes(new CustomRouteBuilder());
  }
}
