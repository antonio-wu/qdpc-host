#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qdpc-host
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/qdpc-host
  SUBMENU:=Wireless Drivers
  TITLE:=Quantenna 5GHz Chip PCIE2 Host Driver
  FILES:=$(PKG_BUILD_DIR)/qdpc-host.ko
  KCONFIG:=
endef

define KernelPackage/qdpc-host/description
 Kernel module for PCIE2 communications between SoC and the Quantenna SoC
endef

EXTRA_KCONFIG:= \
	CONFIG_QDPC_HOST=m

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG)))) \

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SUBDIRS="$(PKG_BUILD_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	$(EXTRA_KCONFIG)

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,qdpc-host))
