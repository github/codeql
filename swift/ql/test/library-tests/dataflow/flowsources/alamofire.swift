
// --- Foundation stubs ---

struct URL {
    init(fileURLWithPath: String) {}

    var path: String { get { return "" } }
}

class NSObject {
}

class URLResponse : NSObject {
}

class HTTPURLResponse : URLResponse {
}

struct Data {
}

extension String {
    init(contentsOf url: URL) throws {
        self.init("")
    }
    init(contentsOfFile path: String) throws {
        self.init("")
    }
}

enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

extension Result {
    var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
}

// --- Alamofire stubs ---

protocol URLConvertible {
}

extension String: URLConvertible {
}

class Request {
}

class DataRequest: Request {
}

class DownloadRequest: Request {
    struct Options: OptionSet {
        let rawValue: Int
    }

    typealias Destination =
        (_ temporaryURL: URL, _ response: HTTPURLResponse) ->
        (destinationURL: URL, options: Options)
}

final class DataStreamRequest: Request {
    typealias Handler<Success, Failure: Error> = (Stream<Success, Failure>) throws -> Void

    struct Stream<Success, Failure: Error> {
        let event: Event<Success, Failure>
    }

    enum Event<Success, Failure: Error> {
        case stream(Result<Success, Failure>)
        case complete(Completion)
    }

    struct Completion {
    }
}

enum AFError: Error {
}

struct DataResponse<Success, Failure: Error> {
    let data: Data?

    let result: Result<Success, Failure>

    var value: Success? { result.success } // SOURCE
}

struct DownloadResponse<Success, Failure: Error> {
    let fileURL: URL?

    let result: Result<Success, Failure>

    var value: Success? { result.success } // SOURCE
}

typealias AFDataResponse<Success> = DataResponse<Success, AFError>
typealias AFDownloadResponse<Success> = DownloadResponse<Success, AFError>

protocol DataResponseSerializerProtocol {
    associatedtype SerializedObject

    func serialize() -> SerializedObject // simplified
}

protocol DownloadResponseSerializerProtocol {
    associatedtype SerializedObject

    func serializeDownload() -> SerializedObject // simplified
}

protocol ResponseSerializer: DataResponseSerializerProtocol & DownloadResponseSerializerProtocol {
}

protocol DataStreamSerializer {
    associatedtype SerializedObject

    func serialize(_ data: Data) throws -> SerializedObject
}

extension DataRequest {
    @discardableResult
    func response(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDataResponse<Data?>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func response<Serializer: DataResponseSerializerProtocol>(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        responseSerializer: Serializer,
        completionHandler: @escaping (AFDataResponse<Serializer.SerializedObject>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func response<Serializer: ResponseSerializer>(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        responseSerializer: Serializer,
        completionHandler: @escaping (AFDataResponse<Serializer.SerializedObject>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseData(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDataResponse<Data>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseString(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDataResponse<String>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseJSON(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseDecodable<T: Decodable>(
        of type: T.Type = T.self,
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
            return self
    }
}

extension DownloadRequest {
    @discardableResult
    func response(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDownloadResponse<URL?>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func response<Serializer: DownloadResponseSerializerProtocol>(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        responseSerializer: Serializer,
        completionHandler: @escaping (AFDownloadResponse<Serializer.SerializedObject>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func response<Serializer: ResponseSerializer>(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        responseSerializer: Serializer,
        completionHandler: @escaping (AFDownloadResponse<Serializer.SerializedObject>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseURL(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDownloadResponse<URL>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseData(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDownloadResponse<Data>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseString(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDownloadResponse<String>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseJSON(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDownloadResponse<Any>) -> Void) -> Self {
            return self
    }

    @discardableResult
    func responseDecodable<T: Decodable>(
        of type: T.Type = T.self,
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        completionHandler: @escaping (AFDownloadResponse<T>) -> Void) -> Self {
            return self
    }
}

extension DataStreamRequest
{
    @discardableResult
    func responseStream(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        stream: @escaping Handler<Data, Never>) -> Self {
            return self
    }

    @discardableResult
    func responseStream<Serializer: DataStreamSerializer>(
        using serializer: Serializer,
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        stream: @escaping Handler<Serializer.SerializedObject, AFError>) -> Self {
            return self
    }

    @discardableResult
    func responseStreamString(
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        stream: @escaping Handler<String, Never>) -> Self {
            return self
    }

    @discardableResult
    func responseStreamDecodable<T: Decodable>(
        of type: T.Type = T.self,
        a1 : Int = 0, // these parameters do not matter for our purposes
        a2 : Int = 0,
        stream: @escaping Handler<T, AFError>) -> Self {
            return self
    }
}

class Session {
	static let `default` = Session()

	func request(
		_ convertible: URLConvertible,
        a2 : Int = 0, // these parameters vary and do not matter for our purposes
        a3 : Int = 0) -> DataRequest {
			return DataRequest()
	}

	func download(
		_ convertible: URLConvertible,
        a2 : Int = 0, // these parameters vary and do not matter for our purposes
        a3 : Int = 0,
        to destination: DownloadRequest.Destination? = nil) -> DownloadRequest {
			return DownloadRequest()
	}

	func streamRequest(
		_ convertible: URLConvertible,
        a2 : Int = 0, // these parameters vary and do not matter for our purposes
        a3 : Int = 0) -> DataStreamRequest {
			return DataStreamRequest()
	}
}

let AF = Session.default

// --- tests ---

struct MySerializer: ResponseSerializer {
    func serialize() -> String { return "" }
    func serializeDownload() -> String { return "" }
}

struct MyStreamSerializer: DataStreamSerializer {
    func serialize(_ data: Data) throws -> String { return "" }
}

struct MyDecodable: Decodable {
}

func doSomethingWith(_ param: Any) {
    // ...
}

func testAlamofire() {
    // requests

    AF.request("http://example.com/").response {
        response in
        if let data = response.data { // SOURCE
            // ...
        }
    }

    AF.request("http://example.com/").response(responseSerializer: MySerializer()) {
        response in
        if let obj = response.value { // SOURCE
            // ...
        }
    }

    AF.request("http://example.com/").responseData {
        response in
        if let data = response.value { // SOURCE
            // ...
        }
    }

    AF.request("http://example.com/").responseString {
        response in
        if let str = response.value { // SOURCE
            // ...
        }
    }

    AF.request("http://example.com/").responseJSON {
        response in
        if let json = response.value { // SOURCE
            // ...
        }
    }

    AF.request("http://example.com/").responseDecodable(of: MyDecodable.self) {
        response in
        if let decodable = response.value { // SOURCE
            // ...
        }
    }

    // downloads (to a file)

    AF.download("http://example.com/").response {
        response in
        if let path = response.fileURL?.path {
            let str = try? String(contentsOfFile: path) // SOURCE
            // ...
        }
    }

    AF.download("http://example.com/").response(responseSerializer: MySerializer()) {
        response in
        if let obj = response.value { // SOURCE
            // ...
        }
    }

    AF.download("http://example.com/").responseURL {
        response in
        if let url = response.value { // just the URL [FALSE POSITIVE]
            let str = try? String(contentsOf: url) // SOURCE
            // ...
        }
    }

    AF.download("http://example.com/").responseData {
        response in
        if let data = response.value { // SOURCE
            // ...
        }
    }

    AF.download("http://example.com/").responseString {
        response in
        if let str = response.value { // SOURCE
            // ...
        }
    }

    AF.download("http://example.com/").responseJSON {
        response in
        if let json = response.value { // SOURCE
        }
    }

    AF.download("http://example.com/").responseDecodable(of: MyDecodable.self) {
        response in
        if let decodable = response.value { // SOURCE
            // ...
        }
    }

    // download (to a *given* file)

    let myPath = "my/path"
    let myDestination: DownloadRequest.Destination = {
        _, _ in
        return (URL(fileURLWithPath: myPath), [])
    }
    AF.download("http://example.com/", to: myDestination).response {
        response in
        // ...
    }
    // ...
    let str = try? String(contentsOfFile: myPath) // SOURCE

    // chaining
    //  - in practice there are a wide range of calls that can be chained through.

    AF.request("http://example.com/").response {
        response in
        if let data = response.data { // SOURCE
            // ...
        }
    }
    .response {
        response in
        if let data = response.data { // SOURCE
            // ...
        }
    }

    // streaming requests

    AF.streamRequest("http://example.com/").responseStream {
        stream in
        switch stream.event {
        case let .stream(result):
            switch result {
            case let .success(data): // SOURCE [NOT DETECTED]
                doSomethingWith(data)
                // ...
            }
        case let .complete(completion):
            doSomethingWith(completion)
            // ...
        }
    }

    AF.streamRequest("http://example.com/").responseStream(using: MyStreamSerializer()) {
        stream in
        switch stream.event {
        case let .stream(result):
            switch result {
            case let .success(value): // SOURCE [NOT DETECTED]
                doSomethingWith(value)
                // ...
            }
        case let .complete(completion):
            doSomethingWith(completion)
            // ...
        }
    }

    AF.streamRequest("http://example.com/").responseStreamString {
        stream in
        switch stream.event {
        case let .stream(result):
            switch result {
            case let .success(value): // SOURCE [NOT DETECTED]
                doSomethingWith(value)
                // ...
            }
        case let .complete(completion):
            doSomethingWith(completion)
            // ...
        }
    }

    AF.streamRequest("http://example.com/").responseStreamDecodable(of: MyDecodable.self) {
        stream in
        switch stream.event {
        case let .stream(result):
            switch result {
            case let .success(value): // SOURCE [NOT DETECTED]
                doSomethingWith(value)
                // ...
            }
        case let .complete(completion):
            doSomethingWith(completion)
            // ...
        }
    }

    // streaming requests (alternative formulations)

    AF.streamRequest("http://example.com/").responseStream {
        stream in
        if case let .stream(myResult) = stream.event {
            if case let .success(myData) = myResult { // SOURCE [NOT DETECTED]
                doSomethingWith(myData)
            }
        }
    }

    AF.streamRequest("http://example.com/").responseStream {
        stream in
        if case let .stream(myResult) = stream.event {
           doSomethingWith(myResult.success!) // SOURCE [NOT DETECTED]
        }
    }

    // access to a non-network `Result` (not a source)

    let myResult = Result<String, Error>.success("data")

    if case let .success(myString) = myResult {
        doSomethingWith(myString)
    }
}
