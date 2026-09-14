class CustomTransformStream extends TransformStream<Uint8Array, number | string> {
  constructor() {
    super({
      transform(chunk, controller) {
        controller.enqueue(chunk);
      }
    });
  }
}

new TransformStream();
new TransformStream({});
new TransformStream({}, {});
new TransformStream({}, {}, {});
new TransformStream({}, {}, {}, {}); // $ Alert
