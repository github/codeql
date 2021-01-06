import play.mvc.Controller;
import play.mvc.Http.*;
import play.mvc.Result;
import play.filters.csrf.AddCSRFToken;
import play.libs.F;
import java.util.concurrent.CompletionStage;


public class PlayResource extends Controller {

    public Result index(String username, String password) {
        String append_token = "password" + password;
        return ok("Working");
      }

    public Result session_redirect_me() {
        String url = request().getQueryString("url");
        redirect(url);
      }

    public F.Promise<Result> async_promise(String token) {
        ok(token);
      }

    public CompletionStage<Result> async_completionstage(String complete) {
        String return_code = "complete" + complete;
        ok("Async completion Stage");
      }

    public String not_playactionmethod(String no_action) {
        String return_code = no_action;
        return return_code;
      }
}