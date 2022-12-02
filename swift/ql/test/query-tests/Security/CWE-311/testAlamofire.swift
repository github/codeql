
// --- Foundation stubs ---

class NSObject {
}

struct URL {
}

struct URLRequest {
}

class URLResponse: NSObject {
}

class HTTPURLResponse : URLResponse {
}

// --- Alamofire stubs ---

protocol URLConvertible {
}

extension String: URLConvertible {
}

struct HTTPMethod {
	static let get = HTTPMethod(rawValue: "GET")
	static let post = HTTPMethod(rawValue: "POST")

	init(rawValue: String) {}
}

struct HTTPHeaders {
	init(_ dictionary: [String: String]) {}

	mutating func add(name: String, value: String) {}
	mutating func update(name: String, value: String) {}
}

extension HTTPHeaders: ExpressibleByDictionaryLiteral {
	public init(dictionaryLiteral elements: (String, String)...) {}
}

typealias Parameters = [String: Any]

protocol ParameterEncoding {
}

struct URLEncoding: ParameterEncoding {
	static var `default`: URLEncoding { URLEncoding() }
}

protocol ParameterEncoder {
}

class URLEncodedFormParameterEncoder: ParameterEncoder {
	static var `default`: URLEncodedFormParameterEncoder { URLEncodedFormParameterEncoder() }
}

protocol RequestInterceptor {
}

class Request {
}

class DataRequest: Request {
}

final class DataStreamRequest: Request {
}

class DownloadRequest: Request {
	struct Options: OptionSet {
		let rawValue: Int

		init(rawValue: Int) {
			self.rawValue = rawValue
		}
	}

	typealias Destination =
		(_ temporaryURL: URL, _ response: HTTPURLResponse) ->
		(destinationURL: URL, options: Options)
}

class Session {
	static let `default` = Session()

	typealias RequestModifier = (inout URLRequest) throws -> Void

	func request(
		_ convertible: URLConvertible,
		method: HTTPMethod = .get,
		parameters: Parameters? = nil,
		encoding: ParameterEncoding = URLEncoding.default,
		headers: HTTPHeaders? = nil,
		interceptor: RequestInterceptor? = nil,
		requestModifier: RequestModifier? = nil) -> DataRequest {
			return DataRequest()
	}

	func request<Parameters: Encodable>(
		_ convertible: URLConvertible,
		method: HTTPMethod = .get,
		parameters: Parameters? = nil,
		encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
		headers: HTTPHeaders? = nil,
		interceptor: RequestInterceptor? = nil,
		requestModifier: RequestModifier? = nil) -> DataRequest {
			return DataRequest()
	}

	func streamRequest(
		_ convertible: URLConvertible,
		method: HTTPMethod = .get,
		headers: HTTPHeaders? = nil,
		automaticallyCancelOnStreamError: Bool = false,
		interceptor: RequestInterceptor? = nil,
		requestModifier: RequestModifier? = nil) -> DataStreamRequest {
			return DataStreamRequest()
	}

	func download(
		_ convertible: URLConvertible,
		method: HTTPMethod = .get,
		parameters: Parameters? = nil,
		encoding: ParameterEncoding = URLEncoding.default,
		headers: HTTPHeaders? = nil,
		interceptor: RequestInterceptor? = nil,
		requestModifier: RequestModifier? = nil,
		to destination: DownloadRequest.Destination? = nil) -> DownloadRequest {
			return DownloadRequest()
	}

	// (there are many more variants of `request`, `streamRequest` and `download`)
}

let AF = Session.default

// --- tests ---

struct MyEncodable: Encodable {
	let value: String
}

func test1(username: String, password: String, email: String, harmless: String) {
	// sensitive data in URL

	AF.request("http://example.com/login?p=" + password) // BAD
	AF.request("http://example.com/login?h=" + harmless) // GOOD (not sensitive)
	AF.streamRequest("http://example.com/login?p=" + password) // BAD
	AF.streamRequest("http://example.com/login?h=" + harmless) // GOOD (not sensitive)
	AF.download("http://example.com/" + email + ".html") // BAD
	AF.download("http://example.com/" + harmless + ".html") // GOOD (not sensitive)

	// sensitive data in parameters

	let params1 = ["value": email]
	let params2 = ["value": harmless]

	AF.request("http://example.com/", parameters: params1) // BAD [NOT DETECTED]
	AF.request("http://example.com/", parameters: params2) // GOOD (not sensitive)
	AF.request("http://example.com/", parameters: params1, encoding: URLEncoding.default) // BAD [NOT DETECTED]
	AF.request("http://example.com/", parameters: params2, encoding: URLEncoding.default) // GOOD (not sensitive)
	AF.request("http://example.com/", parameters: params1, encoder: URLEncodedFormParameterEncoder.default) // BAD [NOT DETECTED]
	AF.request("http://example.com/", parameters: params2, encoder: URLEncodedFormParameterEncoder.default) // GOOD (not sensitive)
	AF.download("http://example.com/", parameters: params1) // BAD [NOT DETECTED]
	AF.download("http://example.com/", parameters: params2) // GOOD (not sensitive)

	let params3 = ["values": ["...", email, "..."]]
	let params4 = ["values": ["...", harmless, "..."]]

	AF.request("http://example.com/", method:.post, parameters: params3) // BAD [NOT DETECTED]
	AF.request("http://example.com/", method:.post, parameters: params4) // GOOD (not sensitive)

	let params5 = MyEncodable(value: email)
	let params6 = MyEncodable(value: harmless)

	AF.request("http://example.com/", parameters: params5) // BAD [NOT DETECTED]
	AF.request("http://example.com/", parameters: params6) // GOOD (not sensitive)

	// request headers
	//  - in real usage a password here would normally be base64 encoded for transmission
	//  - the risk is greatly reduced (but not eliminated) if HTTPS is used

	let headers1: HTTPHeaders = ["Authorization": username + ":" + password]
	let headers2: HTTPHeaders = ["Value": harmless]

	AF.request("http://example.com/", headers: headers1) // BAD [NOT DETECTED]
	AF.request("http://example.com/", headers: headers2) // GOOD (not sensitive)
	AF.streamRequest("http://example.com/", headers: headers1) // BAD [NOT DETECTED]
	AF.streamRequest("http://example.com/", headers: headers2) // GOOD (not sensitive)

	let headers3 = HTTPHeaders(["Authorization": username + ":" + password])
	let headers4 = HTTPHeaders(["Value": harmless])

	AF.request("http://example.com/", headers: headers3) // BAD [NOT DETECTED]
	AF.request("http://example.com/", headers: headers4) // GOOD (not sensitive)
	AF.download("http://example.com/", headers: headers1) // BAD [NOT DETECTED]
	AF.download("http://example.com/", headers: headers2) // GOOD (not sensitive)

	var headers5 = HTTPHeaders([:])
	var headers6 = HTTPHeaders([:])
	headers5.add(name: "Authorization", value: username + ":" + password)
	headers6.add(name: "Data", value: harmless)

	AF.request("http://example.com/", headers: headers5) // BAD [NOT DETECTED]
	AF.request("http://example.com/", headers: headers6) // GOOD (not sensitive)

	var headers7 = HTTPHeaders([:])
	var headers8 = HTTPHeaders([:])
	headers7.update(name: "Authorization", value: username + ":" + password)
	headers8.update(name: "Data", value: harmless)

	AF.request("http://example.com/", headers: headers7) // BAD [NOT DETECTED]
	AF.request("http://example.com/", headers: headers8) // GOOD (not sensitive)
}
