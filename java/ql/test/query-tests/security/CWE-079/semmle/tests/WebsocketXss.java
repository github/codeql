// package test.cwe079.cwe.examples;

// import java.net.http.HttpClient;
// import java.net.http.WebSocket;
// import java.net.URI;
// import java.util.*;
// import java.util.concurrent.*;

// public class WebsocketXss {
//     public static void main(String[] args) throws Exception {
//         WebSocket.Listener listener = new WebSocket.Listener() {
//             public CompletionStage<?> onText(WebSocket webSocket, CharSequence message, boolean last) {
//                 try {
//                     HttpClient client = HttpClient.newBuilder().build();
//                     CompletableFuture<WebSocket> ws = client.newWebSocketBuilder()
//                             .buildAsync(URI.create("ws://websocket.example.com"), null);
//                     ws.get().sendText(message, false);
//                 } catch (Exception e) {
//                     // TODO: handle exception
//                 }

//                 return null;
//             };
//         };

//     }
// }
