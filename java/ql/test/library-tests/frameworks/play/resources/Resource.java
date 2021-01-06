import play.mvc.Controller;
import play.mvc.Http.*;
import play.mvc.Results;
import play.mvc.Result;
import play.filters.csrf.AddCSRFToken;
import play.mvc.BodyParser;
import play.libs.F;
import java.util.concurrent.CompletionStage;


public class Resource extends Controller {

    @AddCSRFToken
    public Result index() {
        response().setHeader("X-Play-QL", "1");
        return ok("It works!");
    }

    @BodyParser.Of()
    public Result session_redirect_me(String uri) {
        String url = request().getQueryString("url");
        redirect(url);
      }

    public F.Promise<Result> async_promise(String token) {
        ok(token);
      }

    public CompletionStage<Result> async_completionstage(String uri) {
        ok("Async completion Stage");
      }

    public String not_playactionmethod(String no_action) {
        String return_code = no_action;
        return return_code;
      }
}