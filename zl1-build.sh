#!/bin/bash

export LC_ALL=C
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

PERSONAL_BUILD_DATE=$(date +%Y%m%d)

mkdir -p $HOME/android/aospa
cd $HOME/android/aospa

repo init -u https://github.com/AOSPA-zl1/manifest -b nougat-mr2
repo sync -c --force-sync --no-tags --no-clone-bundle -j4

source build/envsetup.sh

lunch pa_zl1-user
mka target-files-package dist

croot

./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs out/dist/*-target_files-*.zip signed-target_files.zip
./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey --block signed-target_files.zip pa_zl1-7.3.7-UNOFFICIAL-$PERSONAL_BUILD_DATE-signed.zip

killall java
exit 0
