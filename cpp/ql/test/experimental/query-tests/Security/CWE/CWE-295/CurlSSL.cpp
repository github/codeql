#include "../../../../../library-tests/string_concat/stl.h"

namespace std{
	struct CURL {};
	typedef CURL curl;
	enum curl_constant{
		CURLOPT_URL,
		CURLOPT_SSL_VERIFYHOST,
		CURLOPT_SSL_VERIFYPEER
	}; 

	CURL *curl_easy_init();
	void curl_easy_cleanup(CURL *handle);
	void curl_easy_perform(CURL *handle);
	void curl_easy_setopt(CURL *handle, curl_constant param, int p);
	void curl_easy_setopt(CURL *handle, curl_constant param, char* p);
}


using namespace std;
char host[] = "codeql.com";

void bad(void) {
	std::unique_ptr<CURL> curl = std::unique_ptr<CURL>(curl_easy_init());
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYPEER, 0);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYHOST, 0); 
  	curl_easy_setopt(curl.get(), CURLOPT_URL, host);
  	curl_easy_perform(curl.get());
}

void good(void) {
	std::unique_ptr<CURL> curl = std::unique_ptr<CURL>(curl_easy_init());
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYPEER, 2);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYHOST, 2); 
  	curl_easy_setopt(curl.get(), CURLOPT_URL, host);
  	curl_easy_perform(curl.get());
}

int main(int c, char** argv){
	bad();
  	good();
}

