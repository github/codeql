@Controller
public class SptingViewManipulationController {

    Logger log = LoggerFactory.getLogger(HelloController.class);

    @GetMapping("/safe/fragment")
    @ResponseBody
    public String Fragment(@RequestParam String section) {
        // good, as `@ResponseBody` annotation tells Spring
        // to process the return values as body, instead of view name
        return "welcome :: " + section;
    }

    @GetMapping("/safe/doc/{document}")
    public void getDocument(@PathVariable String document, HttpServletResponse response) {
        // good as `HttpServletResponse param tells Spring that the response is already
        // processed.
        log.info("Retrieving " + document); // FP
    }
}
