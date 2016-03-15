#!/bin/bash

###############################################################################
# To all DEV around the world via Mansi :)                                    #
#                                                                             #
# 1.) use the "bash"                                                          #
# chsh -s /bin/bash `whoami`                                                  #
#                                                                             #
# 2.) delete old files                                                        #
# rm -r out                                                                   #
#                                                                             #
# 3.) now you can build my kernel                                             #
# ./build.sh                                                                  #
#                                                                             #
# Have fun and update me if something nice can be added to my source.         #
###############################################################################

OUT_DIR="out"
KERNEL_DIR=$PWD
KERN_IMG=${OUT_DIR}/arch/arm/boot/zImage
NR_CPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_START=$(date +"%s")

#Set Color
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

###############################################################################
# Set configs
###############################################################################

# Name a kernel
export KBUILD_BUILD_USER="Mansi"
export KBUILD_BUILD_HOST="MSI"

# Type
export ARCH=arm
export SUBARCH=arm
export TARGET_BUILD_VARIANT=user

# gcc 4.8.3 (Linaro 2013.x)
export CROSS_COMPILE=~/toolchains/arm-eabi-4.8/bin/arm-eabi-
#export CROSS_COMPILE=~/toolchains/arm-cortex_a8-linux-gnueabi-linaro_4.9.4/bin/arm-cortex_a8-linux-gnueabi-

# Other
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export USE_CCACHE=1

mkdir ${OUT_DIR}


###############################################################################
# Chech cores in you PC
###############################################################################
if [ "$NR_CPUS" -le "2" ]; then
NR_CPUS=4;
echo -e "$red Building kernel with 4 CPU threads $nocol";
else
echo -e "$red Building kernel with $NR_CPUS CPU threads $nocol";
fi;


###############################################################################
# Build system
###############################################################################
echo -e "$cyan Clean old files $nocol";
	rm ${OUT_DIR}/arch/arm/boot/Image
	rm ${KERN_IMG}
	rm ${KERNEL_DIR}/Mansi/Output/dtb
	rm ${KERNEL_DIR}/Mansi/Output/zImage

echo -e "$cyan Make DefConfig $nocol";
	make O=${OUT_DIR} msm8916-k30_defconfig

echo -e "$cyan Build kernel $nocol";
	make O=${OUT_DIR} -j${NR_CPUS}

if ! [ -a $KERN_IMG ]; then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol";
	exit 1
fi


###############################################################################
# Other configs, after build
###############################################################################

echo -e "$cyan Build dtb file $nocol";
	scripts/dtbToolCM -2 -o ${OUT_DIR}/arch/arm/boot/dtb -s 2048 -p ${OUT_DIR}/scripts/dtc/ ${OUT_DIR}/arch/arm/boot/dts/

echo -e "$cyan Copy kernel $nocol";
	cp ${OUT_DIR}/arch/arm/boot/dtb  ${KERNEL_DIR}/Mansi/Output/dtb
	cp ${KERN_IMG}  ${KERNEL_DIR}/Mansi/Output/zImage
	cd ${KERNEL_DIR}/Mansi/Output/

echo -e "$cyan Build flash file $nocol";
	zipfile="Mansi_M5_($(date +"%d-%m-%Y(%H.%M%p)")).zip"
	zip -r ../${zipfile} ramdisk anykernel.sh dtb zImage tools META-INF -x *kernel/.gitignore*

	BUILD_END=$(date +"%s")
	DIFF=$(($BUILD_END - $BUILD_START))

echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol";

echo "Enjoy Mansi kernel";
