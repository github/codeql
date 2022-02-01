public class CharLiterals {
  public static boolean redundantSurrogateRange(char c) {
    if(c >= '\uda00') {
      if(c >= '\ud900') {
        return true;
      }
    }
    return false;
  }

  public static boolean goodSurrogateRange(char c) {
    if(c >= '\ud900') {
      if(c >= '\uda00') {
        return true;
      }
    }
    return false;
  }

  public static boolean redundantNonSurrogateRange(char c) {
    if(c >= 'b') {
      if(c >= 'a') {
        return true;
      }
    }
    return false;
  }

  public static boolean goodNonSurrogateRange(char c) {
    if(c >= 'a') {
      if(c >= 'b') {
        return true;
      }
    }
    return false;
  }

  public static boolean redundantSurrogateEquality(char c) {
    if(c == '\uda00') {
      return true;
    }
    else if(c == '\uda00') {
      return true;
    }
    return false;
  }

  public static boolean goodSurrogateEquality(char c) {
    if(c == '\uda00') {
      return true;
    }
    else if(c == '\ud900') {
      return true;
    }
    return false;
  }

  public static boolean redundantNonSurrogateEquality(char c) {
    if(c == 'a') {
      return true;
    }
    else if(c == 'a') {
      return true;
    }
    return false;
  }

  public static boolean goodNonSurrogateEquality(char c) {
    if(c == 'a') {
      return true;
    }
    else if(c == 'b') {
      return true;
    }
    return false;
  }
}
