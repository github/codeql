// GOOD - use a POST request for a state-changing action
@RequestMapping(value="transfer", method=RequestMethod.POST)
public boolean transfer(HttpServletRequest request, HttpServletResponse response){
  return doTransfer(request, response);
}
