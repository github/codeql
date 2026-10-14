.. csv-table::
   :header-rows: 1
   :widths: auto
   :stub-columns: 1

   Operating system,Supported versions,Supported CPU architectures
   Linux,"Ubuntu 22.04

   Ubuntu 24.04","x86-64, arm64 [1]_"
   Windows,"Windows 10 / Windows Server 2019

   Windows 11 / Windows Server 2022/2025","x86-64"
   macOS,"macOS 15 Sequoia

   macOS 26 Tahoe [2]_

   macOS 27 Golden Gate [3]_","x86-64, arm64 (Apple Silicon) [4]_"

.. container:: footnote-group

    .. [1] Support for Linux on arm64 is currently in beta.
    .. [2] Support for macOS 26 with Xcode 27 selected is limited to using build mode ``none``.
    .. [3] Support for macOS 27 is limited to Apple Silicon and using build mode ``none``.
    .. [4] Support for Apple Silicon is currently in beta. Building your code during analysis requires Rosetta 2; analyzing an interpreted language or using build mode ``none`` runs natively.
