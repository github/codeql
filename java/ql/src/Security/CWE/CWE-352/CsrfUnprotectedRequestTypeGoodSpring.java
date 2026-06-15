import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.DeleteMapping;

// GOOD - use an unsafe HTTP request like POST
@RequestMapping(value="/transfer", method=RequestMethod.POST)
public boolean doTransfer(HttpServletRequest request, HttpServletResponse response){
  return transfer(request, response);
}

// GOOD - use an unsafe HTTP request like DELETE
@DeleteMapping(value="/delete")
public boolean doDelete(HttpServletRequest request, HttpServletResponse response){
  return delete(request, response);
}
