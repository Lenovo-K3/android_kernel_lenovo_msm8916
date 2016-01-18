#!/bin/bash
# Set config's
outdir="out"

#Set Color
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
blu=$(tput setaf 4) # blue
txtrst=$(tput sgr0) # Reset

mkdir ${outdir}
# Info for Java
echo -e ${txtrst} ${blu}"Config Java"${txtrst}
export JAVA_HOME=/usr/lib/jvm/java-7-oracle

# Set patch for ToolChain
echo -e ${blu}"Set Toolchain"${txtrst}
export CROSS_COMPILE=~/toolchains/arm-eabi-4.8/bin/arm-eabi-

# This is essential to build a working kernel!
export TARGET_BUILD_VARIANT=user
export KBUILD_BUILD_USER=Mansi
export KBUILD_BUILD_HOST=MSI

# Build command
echo -e ${red}"Make DefConfig"${txtrst}
make O=${outdir} msm8916-k30_defconfig

echo -e ${red}"Build kernel"${txtrst}
RUN=`date +%H%M%S` && date && date >> ${outdir}/make.$RUN.log && /usr/bin/time -f "Total time: %E" make O=${outdir} -j$(grep -c ^processor /proc/cpuinfo)  2>&1 | tee -a ${outdir}/make.$RUN.log && date >> ${outdir}/make.$RUN.log && date

# Generate dtb file
echo -e ${red}"Build dtb file"${txtrst}
scripts/dtbToolCM -2 -o ${outdir}/arch/arm/boot/devtree.dtb -s 2048 -p ${outdir}/scripts/dtc/ ${outdir}/arch/arm/boot/dts/

echo -e ${grn}"ALL DONE!!!"${txtrst}
# End Build script
