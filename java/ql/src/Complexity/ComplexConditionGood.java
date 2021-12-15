public class Dialog
{
    // ...

    private void validate() {
      if(idIsEmpty() || (noPartnerId() && parameterLengthInvalid())){ // GOOD: Condition is simpler
        disableOKButton();
      } else {
        enableOKButton();
      }
    }

    private boolean idIsEmpty(){
      return id != null && id.length() == 0;
    }

    private boolean noPartnerId(){
      return partner == null || partner.id == -1;
    }

    private boolean parameterLengthInvalid(){
      return (option == Options.SHORT && parameter.length() == 0) ||
             (option == Options.LONG && parameter.length() < 8);
    }

    // ...
}    