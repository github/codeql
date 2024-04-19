# GoWebsocket
Gorilla websocket based simplified client implementation in GO.

Overview
--------
This client provides following easy to implement functionality
- Support for emitting and receiving text and binary data
- Data compression
- Concurrency control
- Proxy support
- Setting request headers
- Subprotocols support
- SSL verification enable/disable

To install use

```markdown
    go get github.com/sacOO7/gowebsocket
```

Description
-----------

Create instance of `Websocket` by passing url of websocket-server end-point

```go
    //Create a client instance
    socket := gowebsocket.New("ws://echo.websocket.org/")
    
```
 
**Important Note** : url to websocket server must be specified with either **ws** or **wss**.

#### Connecting to server
- For connecting to server:

```go
    //This will send websocket handshake request to socketcluster-server
    socket.Connect()
```

#### Registering All Listeners
```go
    package main
    
    import (
    	"log"
    	"github.com/sacOO7/gowebsocket"
        "os"
        "os/signal"
    )
    
    func main() {
    
        interrupt := make(chan os.Signal, 1)
        signal.Notify(interrupt, os.Interrupt)
        
    	socket := gowebsocket.New("ws://echo.websocket.org/");
    	
    	socket.OnConnected = func(socket gowebsocket.Socket) {
    		log.Println("Connected to server");
    	};
    	
        socket.OnConnectError = func(err error, socket gowebsocket.Socket) {
            log.Println("Recieved connect error ", err)
        };
        
    	socket.OnTextMessage = func(message string, socket gowebsocket.Socket) {
    		log.Println("Recieved message " + message)
    	};
    	
    	socket.OnBinaryMessage = func(data [] byte, socket gowebsocket.Socket) {
            log.Println("Recieved binary data ", data)
        };
        
    	socket.OnPingReceived = func(data string, socket gowebsocket.Socket) {
    		log.Println("Recieved ping " + data)
    	};
    	
    	socket.OnPongReceived = func(data string, socket gowebsocket.Socket) {
            log.Println("Recieved pong " + data)
        };
        
    	socket.OnDisconnected = func(err error, socket gowebsocket.Socket) {
    		log.Println("Disconnected from server ")
    		return
    	};
    	
    	socket.Connect()
    	
        for {
            select {
            case <-interrupt:
                log.Println("interrupt")
                socket.Close()
                return
            }
        }
    }
    
``` 

#### Sending Text message

```go
    socket.SendText("Hi there, this is my sample test message")
```

#### Sending Binary data
```go
    token := make([]byte, 4)
    // rand.Read(token) putting some random value in token
    socket.SendBinary(token)
```

#### Closing the connection with server
```go
    socket.Close()
```

#### Setting request headers
```go
	socket.RequestHeader.Set("Accept-Encoding","gzip, deflate, sdch")
	socket.RequestHeader.Set("Accept-Language","en-US,en;q=0.8")
	socket.RequestHeader.Set("Pragma","no-cache")
	socket.RequestHeader.Set("User-Agent","Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36")
	
```

#### Setting proxy server
- It can be set using connectionOptions by providing url to proxy server

```go
    socket.ConnectionOptions = gowebsocket.ConnectionOptions {
       Proxy: gowebsocket.BuildProxy("http://example.com"),
    }
```

#### Setting data compression, ssl verification and subprotocols

- It can be set using connectionOptions inside socket 

```go
    socket.ConnectionOptions = gowebsocket.ConnectionOptions {
        UseSSL:true,
        UseCompression:true,
        Subprotocols: [] string{"chat","superchat"},
    }
```

- ConnectionOptions needs to be applied before connecting to server
- Please checkout [**examples/gowebsocket**](!https://github.com/sacOO7/GoWebsocket/tree/master/examples/gowebsocket) directory for detailed code..

License
-------
Apache License, Version 2.0

