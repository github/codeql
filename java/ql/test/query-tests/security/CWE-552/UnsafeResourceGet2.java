package com.example;

import javax.faces.context.FacesContext;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.URL;
import java.util.Map;

/** Sample class of JSF managed bean */
public class UnsafeResourceGet2 {
	// BAD: getResourceAsStream constructed from `ExternalContext` without input validation
	public String parameterActionBad1() throws IOException {
		FacesContext fc = FacesContext.getCurrentInstance();
		Map<String, String> params = fc.getExternalContext().getRequestParameterMap();
		String loadUrl = params.get("loadUrl");

		InputStreamReader isr = new InputStreamReader(fc.getExternalContext().getResourceAsStream(loadUrl));
		BufferedReader br = new BufferedReader(isr);
		if(br.ready()) {
			//Do Stuff
			return "result";
		}

		return "home";
	}

	// BAD: getResource constructed from `ExternalContext` without input validation
	public String parameterActionBad2() throws IOException {
		FacesContext fc = FacesContext.getCurrentInstance();
		Map<String, String> params = fc.getExternalContext().getRequestParameterMap();
		String loadUrl = params.get("loadUrl");

		URL url = fc.getExternalContext().getResource(loadUrl);

		InputStream in = url.openStream();
		//Do Stuff
		return "result";
	}

	// GOOD: getResource constructed from `ExternalContext` with input validation
	public String parameterActionGood1() throws IOException {
		FacesContext fc = FacesContext.getCurrentInstance();
		Map<String, String> params = fc.getExternalContext().getRequestParameterMap();
		String loadUrl = params.get("loadUrl");

		if (loadUrl.equals("/public/crossdomain.xml")) {
			URL url = fc.getExternalContext().getResource(loadUrl);

			InputStream in = url.openStream();
			//Do Stuff
			return "result";
		}

		return "home";
	}
}
