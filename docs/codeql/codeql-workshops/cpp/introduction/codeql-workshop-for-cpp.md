# CodeQL workshop for C/C++

This training workshop is a beginner level course which introduces CodeQL for C/C++.

The course is divided into three sessions. Each session should take around 2 hours to complete.

For each session, we have provided a series of videos. Watch each video in turn, and follow any instructions provided. Alternatively, you can complete the course by following the written instructions linked next to each section.

The interactive videos are formatted to take up half the width of a HD screen, allowing you to follow along in your own VS Code window side-by-side with the video (for example, using [Split View](https://youtu.be/cYGrlEtqaVw) on Macs, or Win+Left, Win+Right hotkeys on Microsoft Windows). Some videos include exercises to be completed during the video. We recommend pausing the video when the exercise is read out, completing the exercise, then clicking play to continue the video.

## Session 1

_Estimated completion time: 2 hours_

1. Introduction to CodeQL [[Video](https://drive.google.com/file/d/1DdyD5PGy6LeV2urnitiiwWeBVyNHy20G/view?usp=sharing)] _08:22_
2. Setting up the CodeQL extension for VS Code [[Video](https://drive.google.com/file/d/1bS5DzKhQzofejr-ZgnbYaezucjhKgqgc/view?usp=sharing)] [[Transcript](session-1/installing-vs-code.md)] [[Exiv2 database](http://downloads.lgtm.com/snapshots/cpp/exiv2/Exiv2_exiv2_b090f4d.zip)] _02:54_
3. Empty if statements [[Video](https://drive.google.com/file/d/1muud6R6Z5XUfE2r6MVyP71KyYYrOnAvr/view?usp=sharing)] [[Instructions](session-1/codeql-workshop-cpp-empty-if-stmt.md)]  [[Exiv2 database](http://downloads.lgtm.com/snapshots/cpp/exiv2/Exiv2_exiv2_b090f4d.zip)] _15:12_
4. Predicates and classes [[Video](https://drive.google.com/file/d/14zShBCHYzU8TdcVPcNepZ7AGb9JwEu92/view?usp=sharing)] [[Transcript](session-1/codeql-workshop-cpp-predicates-and-classes.md)]  _11:17_
5. Bad overflow checks [[Video](https://drive.google.com/file/d/1ts05movEiHC05wnZmSLzUNYybmVVBLPf/view?usp=sharing)] [[Instructions](session-1/codeql-workshop-cpp-bad-overflow-check.md)] [[ChakraCore database](https://downloads.lgtm.com/snapshots/cpp/microsoft/chakracore/ChakraCore-revision-2017-April-12--18-13-26.zip)]  _22:46_


## Session 2

_Estimated completion time: 2 hours_

6. Introduction to local data flow
   [[Video](https://drive.google.com/file/d/1vTNFKYcAiGY-xurFUgg0hRDBBAKNt_9E/view?usp=sharing)]
   [[Instructions](session-2/codeql-workshop-cpp-local-data-flow.md)]
   [[dotnet/coreclr database](http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip)]
   _37:13_ 
7. snprintf overflow
   [[Video](https://drive.google.com/file/d/1zyu4AzKtqNKB-KR8MoHIh2ZflKgTzP5j/view?usp=sharing)]
   [[Instructions](session-2/codeql-workshop-cpp-snprintf-overflow.md)]
   [[rsyslog database](https://downloads.lgtm.com/snapshots/cpp/rsyslog/rsyslog/rsyslog-all-revision-2018-April-27--14-12-31.zip)]
   _16:09_ 

## Session 3

_Estimated completion time: 2 hours_

8. Introduction to global data flow
   [[Video](https://drive.google.com/file/d/11HAZoo_2ZcEezY4qlTWIFmad-VU82A-y/view?usp=sharing)]
   [[Instructions](session-3/codeql-workshop-cpp-global-data-flow.md)]
   [[dotnet/coreclr database](http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip)]
   _21:27_ 
9. U-Boot Challenge
   [[Video](https://drive.google.com/file/d/1pXKQxuKLSJQOo0Kmwci-PUy8JTih5fCB/view?usp=sharing)]
   [[Instructions](session-3/codeql-workshop-cpp-uboot.md)]
   [[U-Boot database](https://downloads.lgtm.com/snapshots/cpp/uboot/u-boot_u-boot_cpp-srcVersion_d0d07ba86afc8074d79e436b1ba4478fa0f0c1b5-dist_odasa-2019-07-25-linux64.zip)]
   _20:51_ 

Alternatively, you can follow the U-Boot Challenge using a [GitHub Learning Lab course](https://lab.github.com/githubtraining/codeql-u-boot-challenge-(cc++)).

## Session 4

_Estimated completion time: 2 hours_

10.  glibc SEGV hunt
     [[Video](https://drive.google.com/file/d/1e7zgYsQqP6q1p3T1zBKXN6JetQeG7k5p/view?usp=sharing)]
     [[Instructions](session-4/codeql-workshop-cpp-glibc-segv.md)]
     [[glibc database](https://downloads.lgtm.com/snapshots/cpp/GNU/glibc/bminor_glibc_cpp-srcVersion_333221862ecbebde60dd16e7ca17d26444e62f50-dist_odasa-lgtm-2019-04-08-af06f68-linux64.zip)]
     _29:49_ 
