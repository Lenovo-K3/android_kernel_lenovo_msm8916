#!/bin/bash

OUT_DIR="out"
KERNEL_DIR=$PWD
KERN_IMG=${OUT_DIR}/arch/arm/boot/zImage
BUILD_START=$(date +"%s")
zipfile="K30-ALPHA-M1-$(date +"%d-%m-%Y(%I.%M%p)").zip"

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

compile_kernel ()
{
echo -e "$cyan Clean old files"
rm ${OUT_DIR}/arch/arm/boot/Image
rm ${OUT_DIR}/arch/arm/boot/zImage
rm ${KERNEL_DIR}/Mansi/Output/dt.img
rm ${KERNEL_DIR}/Mansi/Output/zImage

echo -e "$cyan Make DefConfig"
make O=${OUT_DIR} msm8916-k30_defconfig
echo -e "$cyan Build kernel"
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
echo -e "$cyan Build dtb file"
scripts/dtbToolCM -2 -o ${OUT_DIR}/arch/arm/boot/dt.img -s 2048 -p ${OUT_DIR}/scripts/dtc/ ${OUT_DIR}/arch/arm/boot/dts/
echo -e "$cyan Copy kernel"
cp ${OUT_DIR}/arch/arm/boot/dt.img  ${KERNEL_DIR}/Mansi/Output/dt.img
cp ${OUT_DIR}/arch/arm/boot/zImage  ${KERNEL_DIR}/Mansi/Output/zImage
cd ${KERNEL_DIR}/Mansi/Output/
echo -e "$cyan Build flash file"
zip -r ../${zipfile} ramdisk anykernel.sh dtb zImage patch tools META-INF -x *kernel/.gitignore*
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo "Enjoy Mansi kernel"
