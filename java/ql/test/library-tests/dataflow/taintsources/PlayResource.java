import play.mvc.Controller;
import play.mvc.Result;
import play.filters.csrf.AddCSRFToken;
import java.util.concurrent.CompletionStage;


public class PlayResource extends Controller {

    @AddCSRFToken
    public Result play_index(String username, String password) {
        String append_token = "password" + password;
        ok("Working");
      }
}