# Mapping the `handler` property to a function definition

## AWS

[Documentation](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

### Node.js or Typescript
See [documentaion](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html)

Setting `handler` to `index.handler` means that `handler` is exported from `index.js`.

For Typescript, code is first transpiled to JavaScript, see [documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-typescript.html).


### Python
See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html)

Setting `handler` to `lambda_function.lambda_handler` means that `def lambda_handler` is found in `lambda_function.py`.

### Ruby
See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/ruby-handler.html)

Setting `handler` to `function.handler` means that `def handler` is found in `function.rb`.
Setting `handler` to `source.LambdaFunctions::Handler.process` means that `def self.process` is found inside `class Handler` inside `module LambdaFunctions` in `source.rb`.

### Java
See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/java-handler.html)

You can express the hander in the following formats:

- `package.Class::method` – Full format. For example: `example.Handler::handleRequest`.

- `package.Class` – Abbreviated format for functions that implement a handler interface. For example: `example.Handler`.

### Go
See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html)

When you configure a function in Go, the value of the handler setting is the executable file name. For example, if you set the value of the handler to `Handler`, Lambda will call the `main()` function in the `Handler` executable file.

### C#
See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/csharp-handler.html)

`handler` is of this format: `Assembly::Namespace.ClassName::MethodName`.
For example, `HelloWorldApp::Example.Hello::MyHandler` if `public Stream MyHandler` is found inside `public class Hello` inside `namespace Example` in the `HelloWorldApp` assembly.


## Aliyun (Alibaba Cloud)
[Properties](https://www.alibabacloud.com/help/en/resource-orchestration-service/latest/aliyun-serverless-function)
[Languages](https://www.alibabacloud.com/help/en/function-compute/latest/programming-languages)

### Node.js
See [documentation](https://www.alibabacloud.com/help/en/function-compute/latest/node-request-handler)

The handler must be in the `File name.Method name` format. For example, if your file name is `main.js` and your method name is `handler`, the handler is `main.handler`.

### Python
See [documentation](https://www.alibabacloud.com/help/en/function-compute/latest/programming-languages-python)

In Python, your request handler must be in the `File name.Method name` format. For example, if your file name is `main.py` and your method name is `handler`, the handler is `main.handler`.

### Java
See [documentation](https://www.alibabacloud.com/help/en/function-compute/latest/programming-languages-java)

The handler must be in the `[Package name].[Class name]::[Method name]` format. For example, if the name of your package is `example`, the class type is `HelloFC`, and method is `handleRequest`, the handler can be configured as `example.HelloFC::handleRequest`.

### C#
See [documentation](https://www.alibabacloud.com/help/en/function-compute/latest/programming-languages-csharp)

The handler is in the format of `Assembly::Namespace.ClassName::MethodName`.

### Go
See [documentation](https://www.alibabacloud.com/help/en/function-compute/latest/go-323505)

The handler for FC functions in the Go language is compiled into an executable binary file. You only need to set the Request Handler parameter of the FC function to the name of the executable file.

## Serverless
[Documentation](https://www.serverless.com/framework/docs/providers/aws/guide/functions)

The handler property points to the file and module containing the code you want to run in your function.

There seems to be nothing language specific written down about the handler property.
