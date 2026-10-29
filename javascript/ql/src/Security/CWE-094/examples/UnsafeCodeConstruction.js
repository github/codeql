export function unsafeDeserialize(value) {
  return eval(`(${value})`);
}

export function unsafeGetter(obj, path) {
    return eval(`obj.${path}`);
}
