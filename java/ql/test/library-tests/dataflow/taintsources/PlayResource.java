import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionStage;
import play.filters.csrf.AddCSRFToken;
import play.libs.F;
import play.mvc.BodyParser;
import play.mvc.Controller;
import play.mvc.Http.*;
import play.mvc.Result;

public class PlayResource extends Controller {

  @AddCSRFToken
  public Result index() {
    response().setHeader("X-Play-QL", "1");
    return ok("It works!");
  }

  @BodyParser.Of()
  public Result session_redirect_me(String uri) {
    String url = request().getQueryString("url");
    return redirect(url);
  }

  public F.Promise<Result> async_promise(String token) {
    return F.Promise.pure(ok(token));
  }

  public CompletionStage<Result> async_completionstage(String uri) {
    return CompletableFuture.completedFuture(ok("Async completion Stage"));
  }

  public String not_playactionmethod(String no_action) {
    String return_code = no_action;
    return return_code;
  }
}
