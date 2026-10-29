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

void notify(int deviceNumber) {
  DeviceConfig config;
  int statusCode = initDeviceConfig(&config, deviceNumber);
  if (statusCode == 0) {
    // GOOD: Status code returned by initialization function is checked, so this is safe
    if (config.isEnabled) {
      notifyChannel(config.channel);
    }
  }
}
