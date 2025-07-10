import org.springframework.http.HttpHeaders;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ReactiveWebClientSSRF extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            WebClient webClient = WebClient.create(url); // $ SSRF

            Mono<String> result = webClient.get()
                    .uri("/")
                    .retrieve()
                    .bodyToMono(String.class);

            result.block();
        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            WebClient webClient = WebClient.builder()
                    .defaultHeader("User-Agent", "Java")
                    .baseUrl(url) // $ SSRF
                    .build();


            Mono<String> result = webClient.get()
                    .uri("/")
                    .retrieve()
                    .bodyToMono(String.class);

            result.block();
        } catch (Exception e) {
            // Ignore
        }
    }
}