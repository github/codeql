function join<T>(items: T[], callback: (T) => string) {
  return items.map(callback).join(", ")
}
