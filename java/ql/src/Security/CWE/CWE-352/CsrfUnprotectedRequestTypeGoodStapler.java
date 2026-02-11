import org.kohsuke.stapler.verb.POST;

// GOOD - use POST
@POST
public HttpRedirect doTransfer() {
  return transfer();
}

// GOOD - use POST
@POST
public HttpRedirect doPost() {
  return post();
}
