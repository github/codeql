@Controller
public class SptingViewManipulationController {

    Logger log = LoggerFactory.getLogger(HelloController.class);

    @GetMapping("/safe/fragment")
    public String Fragment(@RequestParam String section) {
        // bad as template path is attacker controlled
        return "welcome :: " + section;
    }

    @GetMapping("/doc/{document}")
    public void getDocument(@PathVariable String document) {
        // returns void, so view name is taken from URI
        log.info("Retrieving " + document);
    }
}
