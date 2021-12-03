struct DeviceConfig {
  bool isEnabled;
  int channel;
};

int initDeviceConfig(DeviceConfig *ref, int deviceNumber) {
  if (deviceNumber >= getMaxDevices()) {
    // No device with that number, return -1 to indicate failure
    return -1;
  }
  // Device with that number, fetch parameters and initialize struct
  ref->isEnabled = fetchIsDeviceEnabled(deviceNumber);
  ref->channel = fetchDeviceChannel(deviceNumber);
  // Return 0 to indicate success
  return 0;
}

int notify(int deviceNumber) {
  DeviceConfig config;
  initDeviceConfig(&config, deviceNumber);
  // BAD: Using config without checking the status code that is returned
  if (config.isEnabled) {
    notifyChannel(config.channel);
  }
}
