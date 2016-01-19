#!/bin/bash

OUT_DIR="out"
KERNEL_DIR=$PWD
KERN_IMG=${OUT_DIR}/arch/arm/boot/zImage
BUILD_START=$(date +"%s")
zipfile="K30-ALPHA-M1-$(date +"%Y-%m-%d(%I.%M%p)").zip"

#Set Color
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Set configs
mkdir ${OUT_DIR}
export CROSS_COMPILE=~/toolchains/arm-eabi-4.8/bin/arm-eabi-
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export USE_CCACHE=1
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=Mansi
export KBUILD_BUILD_HOST=MSI
export TARGET_BUILD_VARIANT=user

STRIP=~/toolchains/arm-eabi-4.8/bin/arm-eabi-strip

compile_kernel ()
{
rm ${OUT_DIR}/arch/arm/boot/Image
rm ${OUT_DIR}/arch/arm/boot/zImage
echo -e "Make DefConfig"
make O=${OUT_DIR} msm8916-k30_defconfig
echo -e "Build kernel"
make O=${OUT_DIR} -j$(grep -c ^processor /proc/cpuinfo)

if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
}

case $1 in
clean)
make ARCH=arm -j$(grep -c ^processor /proc/cpuinfo) clean mrproper
;;
*)
compile_kernel
;;
esac
echo -e "Build dtb file"
scripts/dtbToolCM -2 -o ${OUT_DIR}/arch/arm/boot/dt.img -s 2048 -p ${OUT_DIR}/scripts/dtc/ ${OUT_DIR}/arch/arm/boot/dts/

cp ${OUT_DIR}/arch/arm/boot/dt.img  ${KERNEL_DIR}/Mansi/Output/dt.img
cp ${OUT_DIR}/arch/arm/boot/zImage  ${KERNEL_DIR}/Mansi/Output/zImage
cd ${KERNEL_DIR}/Mansi/Output/

zip -r ../${zipfile} ramdisk anykernel.sh dtb zImage patch tools META-INF -x *kernel/.gitignore*
dropbox_uploader -p upload ${KERNEL_DIR}/Mansi/Output/${zipfile} /test/
dropbox_uploader share /test/${zipfile}
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo "Enjoy Mansi kernel"
