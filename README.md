Mansi Kernel for Lenovo K30-T ![Build Status](https://travis-ci.org/Lenovo-K3/android_kernel_lenovo_msm8916.svg?branch=master)
==================================================
Basic   | Spec Sheet
-------:|:----------
CPU     | Quad-core 1.2 GHz ARM® Cortex™ A53
Chipset | Qualcomm Snapdragon 410, msm8916
GPU     | Adreno 306
ROM     | 16GB 
RAM     | 1GB
Android | 4.4.4
Battery | 2300 mAh
Display | 720x1280 pixels, 5.0 (~320 ppi pixel density)
Rear Camera  | 8 mp, 3264x2448 pixels, autofocus, Sony IMX219
Front Camera | 2 mp, 1600x1200 pixels

IMPORTANT HARDWARE INFORMATION
==================================================
|Hardware | Information |
--------:|:--------------
Flash    | KMQ8X000SA-B414-Samsung
LCD      | hx8394d_HD720p_video_Tianma
TouchPanel | Mutto, FT5436,0x14
Camera_Main | imx219_q8n13a
Camera_Sub | gc2355_8916
Accelerometer | mpu6881
Alsps    | elan2182
Gyroscope| mpu6881
Magnetometer| akm09911
Wi-Fi     | Qualcomm-msm8916
Bluetooth | Qualcomm-msm8916
Fm       | Qualcomm-msm8916
Gps      | Qualcomm-msm8916

BUILD KERNEL INFORMATION
==================================================
1. Configure build.sh script
    
		export CROSS_COMPILE=~/toolchains/arm-eabi-4.8/bin/arm-eabi-

2. Use build script
    
		./build.sh

3. Flash kernel use custom recovery
    
		~/kernel_dir/Mansi/Mansi_(release)_(date(time)).zip

4. Rebot phone and use new kernel

VIEW DEVICE
==================================================
![lenovo K30-T](http://img6a.flixcart.com/image/mobile/r/z/z/lenovo-a6000-plus-a6000-plus-400x400-imae6jegmgumrzzs.jpeg)
