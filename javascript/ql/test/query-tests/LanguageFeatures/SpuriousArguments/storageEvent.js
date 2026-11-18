new StorageEvent("storage");
new StorageEvent("storage", {});
new StorageEvent("storage", { key: "k", newValue: "v" });
new StorageEvent("storage", {
  key: null,
  oldValue: null,
  newValue: null,
  url: "",
  storageArea: null,
  bubbles: false,
  cancelable: false,
  composed: false
});
new StorageEvent("storage", {}, "extra"); // $ Alert
