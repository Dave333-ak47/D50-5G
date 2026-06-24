include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=ipq50xx
BOARDNAME:=Qualcomm Atheros IPQ50xx
FEATURES:=squashfs ramdisk fpu nand pcie usb
KERNELNAME:=Image dtbs
CPU_TYPE:=cortex-a53
SUBTARGETS:=generic

KERNEL_PATCHVER:=5.15

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += \
    kmod-gpio-button-hotplug \
    uboot-envtools \
    kmod-ath11k \
    kmod-ath11k-ahb \
    kmod-ath11k-pci \
    ath11k-firmware-ipq5018 \
    ath11k-firmware-qcn6122 \
    ath11k-firmware-qcn9074 \
    kmod-usb2 \
    kmod-usb3 \
    kmod-usb-dwc3 \
    kmod-usb-dwc3-qcom \
    kmod-qca-nss-dp \
    kmod-qca-nss-gmac \
    kmod-qca-nss-ecm \
    kmod-mhi-bus \
    kmod-mhi-pci-generic \
    kmod-qmi-wwan \
    kmod-usb-net-qmi-wwan \
    kmod-usb-serial \
    kmod-usb-serial-option \
    uqmi umbim modemmanager \
    wpad-basic-wolfssl

define Device/xunison_exigo_d50
  DEVICE_VENDOR := Xunison
  DEVICE_MODEL := Exigo Hub D50 5G
  DEVICE_DTS := ipq5018-exigo-hub-d50-5g
  DEVICE_DTS_DIR := $(DTS_DIR)/qcom
  SUPPORTED_DEVICES := xunison,exigo_hub_d50

  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGES := factory.bin sysupgrade.bin

  IMAGE/factory.bin := append-kernel | append-rootfs | pad-rootfs | append-metadata
  IMAGE/sysupgrade.bin := append-kernel | append-rootfs | pad-rootfs | append-metadata
endef
TARGET_DEVICES += xunison_exigo_d50

$(eval $(call BuildTarget))
