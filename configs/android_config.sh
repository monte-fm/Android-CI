#!/bin/bash
export ANDROID_NDK=/opt/android-ndk-r10e
export ANDROID_HOME=/opt/android-sdk-linux
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
echo "y" | android update sdk -u --all
