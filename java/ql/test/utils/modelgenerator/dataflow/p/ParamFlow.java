package p;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;

public class ParamFlow {

  // summary=p;ParamFlow;true;returnsInput;(String);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnsInput;(String);;Argument[0];ReturnValue;value;dfc-generated
  public String returnsInput(String input) {
    return input;
  }

  // neutral=p;ParamFlow;ignorePrimitiveReturnValue;(String);summary;df-generated
  public int ignorePrimitiveReturnValue(String input) {
    return input.length();
  }

  // summary=p;ParamFlow;true;returnMultipleParameters;(String,String);;Argument[0];ReturnValue;taint;df-generated
  // summary=p;ParamFlow;true;returnMultipleParameters;(String,String);;Argument[1];ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnMultipleParameters;(String,String);;Argument[0];ReturnValue;value;dfc-generated
  // contentbased-summary=p;ParamFlow;true;returnMultipleParameters;(String,String);;Argument[1];ReturnValue;value;dfc-generated
  public String returnMultipleParameters(String one, String two) {
    if (System.currentTimeMillis() > 100) {
      return two;
    }
    return one;
  }

  // summary=p;ParamFlow;true;returnArrayElement;(String[]);;Argument[0].ArrayElement;ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnArrayElement;(String[]);;Argument[0].ArrayElement;ReturnValue;value;dfc-generated
  public String returnArrayElement(String[] input) {
    return input[0];
  }

  // summary=p;ParamFlow;true;returnVarArgElement;(String[]);;Argument[0].ArrayElement;ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnVarArgElement;(String[]);;Argument[0].ArrayElement;ReturnValue;value;dfc-generated
  public String returnVarArgElement(String... input) {
    return input[0];
  }

  // summary=p;ParamFlow;true;returnCollectionElement;(List);;Argument[0].Element;ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnCollectionElement;(List);;Argument[0].Element;ReturnValue;value;dfc-generated
  public String returnCollectionElement(List<String> input) {
    return input.get(0);
  }

  // summary=p;ParamFlow;true;returnIteratorElement;(Iterator);;Argument[0].Element;ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnIteratorElement;(Iterator);;Argument[0].Element;ReturnValue;value;dfc-generated
  public String returnIteratorElement(Iterator<String> input) {
    return input.next();
  }

  // summary=p;ParamFlow;true;returnIterableElement;(Iterable);;Argument[0].Element;ReturnValue;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;returnIterableElement;(Iterable);;Argument[0].Element;ReturnValue;value;dfc-generated
  public String returnIterableElement(Iterable<String> input) {
    return input.iterator().next();
  }

  // neutral=p;ParamFlow;mapType;(Class);summary;df-generated
  public Class<?> mapType(Class<?> input) {
    return input;
  }

  // summary=p;ParamFlow;true;writeChunked;(byte[],OutputStream);;Argument[0];Argument[1];taint;df-generated
  // contentbased-summary=p;ParamFlow;true;writeChunked;(byte[],OutputStream);;Argument[0];Argument[1];taint;dfc-generated
  public void writeChunked(byte[] data, OutputStream output) throws IOException {
    output.write(data, 0, data.length);
  }

  // summary=p;ParamFlow;true;writeChunked;(char[],OutputStream);;Argument[0];Argument[1];taint;df-generated
  // contentbased-summary=p;ParamFlow;true;writeChunked;(char[],OutputStream);;Argument[0];Argument[1];taint;dfc-generated
  public void writeChunked(char[] data, OutputStream output) throws IOException {
    output.write(String.valueOf(data).getBytes(), 0, data.length);
  }

  // summary=p;ParamFlow;true;addTo;(String,List);;Argument[0];Argument[1].Element;taint;df-generated
  // contentbased-summary=p;ParamFlow;true;addTo;(String,List);;Argument[0];Argument[1].Element;value;dfc-generated
  public void addTo(String data, List<String> target) {
    target.add(data);
  }
}
