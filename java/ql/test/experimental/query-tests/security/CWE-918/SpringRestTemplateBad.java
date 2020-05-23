// Test case for
// CWE-918: Server-Side Request Forgery (SSRF)
// https://cwe.mitre.org/data/definitions/918.html

package test.cwe918.cwe.examples;

import java.net.URI;
import java.util.HashMap;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.RequestParam;

public class SpringRestTemplateBad {
	protected void handleRequest(@RequestParam String userInput) {
        RestTemplate template = new RestTemplate();
       
        template.getForObject(userInput, Entity.class, "webhook");
        template.getForObject(userInput, Entity.class, new HashMap<>());
        template.getForObject(URI.create(userInput), Entity.class);

        template.getForEntity(userInput, Entity.class, "webhook");
        template.getForEntity(userInput, Entity.class, new HashMap<>());
        template.getForEntity(URI.create(userInput), Entity.class);

        template.headForHeaders(userInput, "webhook");
        template.headForHeaders(userInput, new HashMap<>());
        template.headForHeaders(URI.create(userInput));

        template.postForLocation(userInput, null, "webhook");
        template.postForLocation(userInput, null, new HashMap<>());
        template.postForLocation(URI.create(userInput), null);

        template.postForObject(userInput, null, Entity.class, "webhook");
        template.postForObject(userInput, null, Entity.class, new HashMap<>());
        template.postForObject(URI.create(userInput), null, Entity.class);

        template.postForEntity(userInput, null, Entity.class, "webhook");
        template.postForEntity(userInput, null, Entity.class, new HashMap<>());
        template.postForEntity(URI.create(userInput), null, Entity.class);

        template.put(userInput, null, "webhook");
        template.put(userInput, null, new HashMap<>());
        template.put(URI.create(userInput), null);

        template.patchForObject(userInput, null, Entity.class, "webhook");
        template.patchForObject(userInput, null, Entity.class, new HashMap<>());
        template.patchForObject(URI.create(userInput), null, Entity.class);

        template.delete(userInput, "webhook");
        template.delete(userInput, new HashMap<>());
        template.delete(URI.create(userInput));

        template.optionsForAllow(userInput, "webhook");
        template.optionsForAllow(userInput, new HashMap<>());
        template.optionsForAllow(URI.create(userInput));

        template.exchange(userInput, HttpMethod.GET, null, Entity.class, "path");
        template.exchange(userInput, HttpMethod.GET, null, Entity.class, new HashMap<>());
        template.exchange(userInput, HttpMethod.GET, null, new ParametrizedEntity(), "path");
        template.exchange(userInput, HttpMethod.GET, null, new ParametrizedEntity(), new HashMap<>());
        template.exchange(URI.create(userInput), HttpMethod.GET, null, Entity.class);
        template.exchange(URI.create(userInput), HttpMethod.GET, null, new ParametrizedEntity());
        template.exchange(new RequestEntity<>(HttpMethod.GET, URI.create(userInput)), Entity.class);
        template.exchange(new RequestEntity<>(HttpMethod.GET, URI.create(userInput)), new ParametrizedEntity());

        template.execute(userInput, HttpMethod.GET, null, null, "path");
        template.execute(userInput, HttpMethod.GET, null, null, new HashMap<>());
        template.execute(URI.create(userInput), HttpMethod.GET, null, null);
	}

    static class Entity {}

    static class ParametrizedEntity extends ParameterizedTypeReference<ParametrizedEntity> {}
}
