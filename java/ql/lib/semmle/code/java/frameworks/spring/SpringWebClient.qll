/**
 * Provides classes for working with Spring web clients.
 */

import java
import SpringHttp
private import semmle.code.java.dataflow.ExternalFlow

/** The class `org.springframework.web.client.RestTemplate`. */
class SpringRestTemplate extends Class {
  SpringRestTemplate() { this.hasQualifiedName("org.springframework.web.client", "RestTemplate") }
}

/**
 * A method declared in `org.springframework.web.client.RestTemplate` that
 * returns a `SpringResponseEntity`.
 */
class SpringRestTemplateResponseEntityMethod extends Method {
  SpringRestTemplateResponseEntityMethod() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.getReturnType() instanceof SpringResponseEntity
  }
}

/** The interface `org.springframework.web.reactive.function.client.WebClient`. */
class SpringWebClient extends Interface {
  SpringWebClient() {
    this.hasQualifiedName("org.springframework.web.reactive.function.client", "WebClient")
  }
}

private class UrlOpenSink extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.web.client;RestTemplate;false;delete;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;doExecute;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;exchange;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;execute;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;getForEntity;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;getForObject;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;headForHeaders;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;optionsForAllow;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;patchForObject;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;postForEntity;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;postForLocation;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;postForObject;;;Argument[0];open-url",
        "org.springframework.web.client;RestTemplate;false;put;;;Argument[0];open-url",
        "org.springframework.web.reactive.function.client;WebClient;false;create;;;Argument[0];open-url",
        "org.springframework.web.reactive.function.client;WebClient$Builder;false;baseUrl;;;Argument[0];open-url"
      ]
  }
}
