#include<iostream>
#include<memory>

#include<curl/curl.h>

using namespace std;

string host = "codeql.com"

void bad(void) {
	std::unique_ptr<CURL, void(*)(CURL*)> curl =
		std::unique_ptr<CURL, void(*)(CURL*)>(curl_easy_init(), curl_easy_cleanup);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYPEER, 0);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYHOST, 0); 
  curl_easy_setopt(curl.get(), CURLOPT_URL, host.c_str());
  curl_easy_perform(curl.get());
}

void good(void) {
	std::unique_ptr<CURL, void(*)(CURL*)> curl =
		std::unique_ptr<CURL, void(*)(CURL*)>(curl_easy_init(), curl_easy_cleanup);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYPEER, 2);
	curl_easy_setopt(curl.get(), CURLOPT_SSL_VERIFYHOST, 2); 
  curl_easy_setopt(curl.get(), CURLOPT_URL, host.c_str());
  curl_easy_perform(curl.get());
}

int main(int c, char** argv){
  bad();
  good();
}