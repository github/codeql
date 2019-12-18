// based on the qhelp

int getMaxDevices();
bool fetchIsDeviceEnabled(int deviceNumber);
int fetchDeviceChannel(int deviceNumber);
void notifyChannel(int channel);

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

void notifyGood(int deviceNumber) {
  DeviceConfig config;
  int statusCode = initDeviceConfig(&config, deviceNumber);
  if (statusCode == 0) {
    // GOOD: Status code returned by initialization function is checked, so this is safe
    if (config.isEnabled) {
      notifyChannel(config.channel);
    }
  }
}

int notifyBad(int deviceNumber) {
  DeviceConfig config;
  initDeviceConfig(&config, deviceNumber);
  // BAD: Using config without checking the status code that is returned
  if (config.isEnabled) {
    notifyChannel(config.channel);
  }
}