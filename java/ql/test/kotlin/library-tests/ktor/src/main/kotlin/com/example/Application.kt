package com.example

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.engine.*
import io.ktor.client.engine.apache.*
import io.ktor.client.engine.cio.*
import io.ktor.client.engine.java.*
import io.ktor.client.plugins.*
import io.ktor.client.request.*
import io.ktor.client.request.forms.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.ldap.*
import io.ktor.server.engine.*
import io.ktor.server.html.*
import io.ktor.server.http.content.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.sessions.*
import io.ktor.server.websocket.*
import io.ktor.util.*
import io.ktor.util.cio.*
import io.ktor.utils.io.*
import io.ktor.utils.io.core.*
import io.ktor.websocket.*
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.nio.ByteBuffer
import java.time.Duration
import kotlinx.html.*
import kotlinx.html.body
import kotlinx.html.h1
import kotlinx.html.title

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
            .start(wait = true)
}

fun Application.module() {
    configureSockets()
    configureSecurity()
    configureRouting()
    kotlinxHtmlResponse()
}

data class MySession(val count: Int = 0, val name: String = "", val id: Int = 0)

data class MySession2(val count: Int = 0, val name: String = "", val id: Int = 0)

fun Application.kotlinxHtmlResponse() {
    routing {
        get("/xss") {
            val name = "Ktor"
            val xss1: String? = call.parameters["xss1"] ?: "<script>alert(1)</script>" // $source
            val xss2: String? = call.parameters["xss2"] ?: "alert(2)" // $source
            call.respondHtml(HttpStatusCode.OK) {
                head {
                    title { +name }
                    style {
                        unsafe {
                            raw(
                                    """
                                    body {
                                        background-color: #272727;
                                    color: #ccc;
                                    }
                                    </style>
                                    $xss1 
                                """ // $xss
                            )
                        }
                    }
                }
                body {
                    h1 {
                        script {
                            unsafe {
                                raw(
                                        """
                                    $xss2
                                    """ // $xss
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

fun Application.configureSockets() {
    install(WebSockets) {
        pingPeriod = Duration.ofSeconds(15)
        timeout = Duration.ofSeconds(15)
        maxFrameSize = Long.MAX_VALUE
        masking = false
    }
    routing {
        webSocket("/ws") { // websocketSession
            for (frame in incoming) { // $source
                if (frame is Frame.Text) {
                    val text = frame.readText() // $source
                    frame.readBytes() // $source
                    frame.buffer // $source
                    frame.data // $source
                    outgoing.send(Frame.Text("YOU SAID: $text"))
                    if (text.equals("bye", ignoreCase = true)) {
                        close(CloseReason(CloseReason.Codes.NORMAL, "Client said BYE"))
                    }
                }
            }
        }
    }
}

fun Application.configureSecurity() {
    install(Sessions) {
        // https://ktor.io/docs/sessions.html#sign_session
        // put cookie in new header
        var secretSignKey = hex("6819b57a326945c1968f45236589")
        header<String>("cart_session", directorySessionStorage(File("build/.sessions"))) {
            transform(SessionTransportTransformerMessageAuthentication(secretSignKey)) // $sensitive
        }
        // or
        // https://ktor.io/docs/sessions.html#sign_encrypt_session
        // put cookie in cookie header with a new cookie-name
        val secretEncryptKey = hex("00112233445566778899aabbccddeeff")
        secretSignKey = hex("6819b57a326945c1968f45236589")
        cookie<MySession>("user_session") {
            cookie.path = "/"
            transform(
                    SessionTransportTransformerEncrypt(secretEncryptKey, secretSignKey)
            ) // $sensitive
        }
        cookie<MySession2>("user_data") { cookie.path = "/" }
    }

    routing {
        get("/session/increment") {
            val session: String = call.sessions.get<String>() ?: ""
            call.sessions.set("$session new part ")
            val session2 = call.sessions.get<MySession>() ?: MySession()
            call.sessions.set(session2.copy(count = session2.count + 1))
            // in case of not-protected cookie it is dangerous to trust following value
            val session3 = call.sessions.get<MySession2>() // $source
            call.respondText("Counter is ${session2.id}. Refresh to increment.")
        }
    }
}

fun Application.configureRouting() {
    install(StatusPages) {
        exception<Throwable> { call, cause ->
            call.respondText(text = "500: $cause", status = HttpStatusCode.InternalServerError)
        }
    }
    routing {
        get("/LdapInjection") {
            val result =
                    ldapAuthenticate(
                            UserPasswordCredential("username", "password"), // $sensitive
                            "ldap://${call.parameters["path"]}",
                            "uid=${call.parameters["path"]},ou=system"
                    )
            call.respondText("Not Safe! $result.toString()")
        }
        get("/SSRF") {
            data class Item(val key: String, val value: String)
            data class Model(val name: String, val items: List<Item>)

            val url = call.parameters["url"] // $source

            val client = HttpClient(Apache)
            var model: Model

            model = client.get("$url").body() // $ssrf
            for ((key, _) in model.items) {
                val item: Item = client.get("$url/$key").body() // $ssrf
                sink(item) // $tainted
            }

            model = client.get("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.post("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.put("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.patch("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.head("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.delete("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.options("$url").body() // $ssrf
            sink(model) // $tainted

            model = client.prepareGet("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.preparePost("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.preparePut("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.preparePatch("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.prepareHead("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.prepareDelete("$url").body() // $ssrf
            sink(model) // $tainted
            model = client.prepareOptions("$url").body() // $ssrf
            sink(model) // $tainted

            var response: HttpResponse = client.get("$url") // $ssrf
            sink(response.bodyAsText()) // $tainted
            sink(response.bodyAsChannel()) // $tainted
            sink(response.readBytes()) // $tainted
            sink(response.readBytes(100)) // $tainted
            sink(response.headers) // $tainted

            val HttpStmt = client.prepareGet("$url") // $ssrf
            model = HttpStmt.body()
            sink(model) // $ssrf $tainted
            sink(HttpStmt.execute()) // $tainted

            val CioClient = HttpClient(CIO)
            response =
                    CioClient.submitFormWithBinaryData(
                            url = "$url", // $ssrf
                            formData = formData { append("description", "Ktor logo") }
                    )
            sink(response.bodyAsText()) // $tainted

            client.submitForm(
                    url = "$url", // $ssrf
                    formParameters = parameters { append("username", "JetBrains") }
            )

            HttpClient(Java) {
                engine {
                    // typealias ProxyConfig = Proxy
                    proxy = ProxyBuilder.http("$url") // $ssrf
                }
            }
            // type-safe requests
            HttpClient(CIO) {
                install(DefaultRequest)
                defaultRequest {
                    host = "$url" // $ssrf
                    port = 8080
                    url { protocol = URLProtocol.HTTP }
                    header(HttpHeaders.Origin, "text/html") // $ssrf
                    headers.appendIfNameAbsent(HttpHeaders.Origin, "text/html") // $ssrf
                }
            }
            HttpClient(CIO) {
                install(DefaultRequest)
                defaultRequest {
                    url("$url") // $ssrf
                }
            }
            HttpClient(CIO) {
                install(DefaultRequest)
                defaultRequest {
                    url {
                        host = "$url" // $ssrf
                    }
                }
            }

            // Build HttpRequestBuilder separately
            client.submitFormWithBinaryData(emptyList()) {
                host = "$url" // $ssrf
            }
            client.submitFormWithBinaryData(emptyList()) {
                url("$url") // $ssrf
            }
            // Configure URL components separately
            client.get {
                url {
                    host = "$url" // $ssrf
                }
            }
            // Configure Headers components separately
            client.get("$url") {
                headers {
                    append(HttpHeaders.Origin, "text/html") // $ssrf
                }
            }
        }
        get("/RemoteFlowSource") {
            val receive = call.receive<String>() // $source
            var parameters = call.parameters // $source
            sink(parameters["id"]) // $tainted
            sink(parameters.get("id")) // $tainted
            val callRequest = call.request // $source
            callRequest.uri // $source
            val cookies = callRequest.cookies // $source
            cookies.rawCookies // $source
            sink(cookies.get("aa")) // $tainted
            sink(cookies["aa"]) // $tainted

            val headers = callRequest.headers // $source
            sink(headers.get("a")) // $tainted
            sink(headers["a"]) // $tainted
            headers.forEach { key, values ->
                sink(key) // $tainted
                sink(values) // $tainted
            }
            sink(headers.entries()) // $tainted
            sink(headers.getAll("aa")) // $tainted
            sink(headers.names()) // $tainted

            val queryParameters = callRequest.queryParameters // $source
            sink(queryParameters.get("a")) // $tainted
            sink(queryParameters["a"]) // $tainted
            queryParameters.forEach { key, values ->
                sink(key) // $tainted
                sink(values) // $tainted
            }
            sink(queryParameters.entries()) // $tainted
            sink(queryParameters.getAll("aa")) // $tainted
            sink(queryParameters.names()) // $tainted

            val rawQueryParameters = callRequest.rawQueryParameters // $source
            sink(rawQueryParameters.get("a")) // $tainted
            sink(rawQueryParameters["a"]) // $tainted
            rawQueryParameters.forEach { key, values ->
                sink(key) // $tainted
                sink(values) // $tainted
            }
            sink(rawQueryParameters.entries()) // $tainted
            sink(rawQueryParameters.getAll("aa")) // $tainted
            sink(rawQueryParameters.names()) // $tainted

            parameters = call.parameters // $source
            sink(parameters.get("a")) // $tainted
            sink(parameters["a"]) // $tainted
            parameters.forEach { key, values ->
                sink(key) // $tainted
                sink(values) // $tainted
            }
            sink(parameters.entries()) // $tainted
            sink(parameters.getAll("aa")) // $tainted
            sink(parameters.names()) // $tainted

            val formParameters = call.receiveParameters() // $source
            sink(formParameters.get("a")) // $tainted
            sink(formParameters["a"]) // $tainted
            formParameters.forEach { key, values ->
                sink(key) // $tainted
                sink(values) // $tainted
            }
            sink(formParameters.entries()) // $tainted
            sink(formParameters.getAll("aa")) // $tainted
            sink(formParameters.names()) // $tainted

            val stringValues: StringValues = formParameters
            sink(stringValues.get("a")) // $tainted
            sink(stringValues["a"]) // $tainted
            stringValues.forEach { key, values ->
                sink(key) // $tainted
                sink(values) // $tainted
            }
            sink(stringValues.entries()) // $tainted
            sink(stringValues.getAll("aa")) // $tainted
            sink(stringValues.names()) // $tainted

            val multipartData = call.receiveMultipart()
            val Parts: List<PartData> = multipartData.readAllParts()
            Parts[0].headers // $source
            Parts[0].name // $source
            Parts[0].contentDisposition // $source
            Parts[0].contentType // $source

            val receiveStream = call.receiveStream() // $source
            sink(receiveStream.readAllBytes()) // $tainted
            sink(receiveStream.readNBytes(100)) // $tainted

            call.receiveText() // $source
            val byteReadChan = call.receiveChannel() // $source
            sink(byteReadChan.toByteArray()) // $tainted
            sink(byteReadChan.readUTF8Line(100)) // $tainted
            val byteBuff: ByteBuffer = ByteBuffer.allocateDirect(100)
            byteReadChan.readAvailable(byteBuff)
            sink(byteBuff) // $tainted
            val writeChan = File("/tmp/ktortmpp").writeChannel()
            byteReadChan.copyAndClose(writeChan)
            sink(writeChan) // $tainted
            sink(byteReadChan.read { println(it) }) // $tainted
            sink(byteReadChan.readAvailable { println(it) }) // $tainted
            sink(byteReadChan.readByte()) // $tainted
            sink(byteReadChan.readPacket(100)) // $tainted
            byteReadChan.readFully(byteBuff)
            sink(byteBuff) // $tainted
            sink(byteReadChan.readRemaining()) // $tainted

            val byteReadPacket: ByteReadPacket = sink(byteReadChan.readRemaining()) // $tainted
            sink(byteReadPacket.readText()) // $tainted
            byteReadPacket.readAvailable(byteBuff)
            sink(byteBuff) // $tainted
            sink(byteReadPacket.readTextExact(1000)) // $tainted
            sink(byteReadPacket.copy()) // $tainted
            val buffWriter = BufferedWriter(FileWriter("foo.out"))
            byteReadPacket.readText(buffWriter)
            sink(buffWriter) // $tainted
            sink(byteReadPacket.readBytes(100)) // $tainted
            byteReadPacket.readFully(byteBuff)
            sink(byteBuff) // $tainted

            call.receiveNullable<String>() // $source
            call.receiveOrNull<String>() // $source

            call.respondText("receive: $receive")
        }
        // Static plugin. Try to access `/static/index.html`
        staticResources("/static", "static")
    }
}

fun <T> sink(readFully: T): T {
    return readFully
}
