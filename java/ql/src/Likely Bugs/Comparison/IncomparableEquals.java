String[] anArray = new String[]{"a","b","c"}
String valueToFind = "b";

for(int i=0; i<anArray.length; i++){
  if(anArray.equals(valueToFind){    // anArray[i].equals(valueToFind) was intended
    return "Found value at index " + i;
  }
}

return "Value not found";