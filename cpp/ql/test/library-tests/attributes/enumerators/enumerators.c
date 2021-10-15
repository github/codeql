// Some source code checks for enumerator_attributes prior to using enumerator attributes:
enum OperationMode {
  OM_Invalid,
  OM_Normal,
  OM_Terrified
#if __has_feature(enumerator_attributes)
  __attribute__((deprecated))
#endif
  ,
  OM_AbortOnError
#if __has_feature(enumerator_attributes)
  __attribute__((deprecated))
#endif
  = 4
};

// Other source code just goes ahead and uses them:
enum NSUserNotificationActivationType {
    NSUserNotificationActivationTypeNone = 0,
    NSUserNotificationActivationTypeContentsClicked = 1,
    NSUserNotificationActivationTypeActionButtonClicked = 2,
    NSUserNotificationActivationTypeReplied __attribute__((availability(macosx,introduced=10.9))) = 3
};
