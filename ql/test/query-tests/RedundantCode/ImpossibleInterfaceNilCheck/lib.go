package main

type RequestError string

func (e RequestError) Error() string {
	return string(e)
}

func fetch(url string) (string, *RequestError) {
	return "stuff", nil
}
