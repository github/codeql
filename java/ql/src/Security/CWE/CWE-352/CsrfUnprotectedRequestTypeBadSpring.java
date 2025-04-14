import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

// BAD - a safe HTTP request like GET should not be used for a state-changing action
@RequestMapping(value="/transfer", method=RequestMethod.GET)
public boolean doTransfer(HttpServletRequest request, HttpServletResponse response){
  return transfer(request, response);
}

// BAD - no HTTP request type is specified, so safe HTTP requests are allowed
@RequestMapping(value="/delete")
public boolean doDelete(HttpServletRequest request, HttpServletResponse response){
  return delete(request, response);
}
