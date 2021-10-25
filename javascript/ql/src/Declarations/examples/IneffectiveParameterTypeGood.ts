function join<T>(items: T[], callback: (item: T) => string) {
  return items.map(callback).join(", ")
}
