string host = "codeql.com"
void good(void) {
	std::unique_ptr<CURL, void(*)(CURL*)> curl =
		std::unique_ptr<CURL, void(*)(CURL*)>(curl_easy_init(), curl_easy_cleanup);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYPEER, 2);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYHOST, 2); 
  	curl_easy_setopt(curl.get(), CURLOPT_URL, host.c_str());
  	curl_easy_perform(curl.get());
}