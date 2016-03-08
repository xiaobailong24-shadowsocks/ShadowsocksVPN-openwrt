#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2015 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocks-libev
PKG_VERSION:=2.4.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/shadowsocks/openwrt-shadowsocks/releases/download/v$(PKG_VERSION)
PKG_MD5SUM:=b0541ec80f976c166d4af6a914497377

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Max Lv <max.c.lv@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocks-libev/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy $(2)
	URL:=https://github.com/shadowsocks/shadowsocks-libev
	VARIANT:=$(1)
	DEPENDS:=$(3)
endef

Package/shadowsocks-libev = $(call Package/shadowsocks-libev/Default,openssl,(OpenSSL),+libopenssl +libpthread)
Package/shadowsocks-libev-gfwlist = $(call Package/shadowsocks-libev/Default,openssl,(OpenSSL),-dnsmasq +libopenssl +libpthread +dnsmasq-full +ipset +iptables)
Package/shadowsocks-libev-polarssl = $(call Package/shadowsocks-libev/Default,polarssl,(PolarSSL),+libpolarssl +libpthread)
Package/shadowsocks-libev-gfwlist-polarssl = $(call Package/shadowsocks-libev/Default,polarssl,(PolarSSL),-dnsmasq +libopenssl +libpthread +dnsmasq-full +ipset +iptables)

Package/shadowsocks-libev-server = $(call Package/shadowsocks-libev/Default,openssl,(OpenSSL),+libopenssl +libpthread)
Package/shadowsocks-libev-server-polarssl = $(call Package/shadowsocks-libev/Default,polarssl,(PolarSSL),+libpolarssl +libpthread)

define Package/shadowsocks-libev/description
Shadowsocks-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocks-libev-gfwlist/description = $(Package/shadowsocks-libev/description)
Package/shadowsocks-libev-polarssl/description = $(Package/shadowsocks-libev/description)
Package/shadowsocks-libev-gfwlist-polarssl/description = $(Package/shadowsocks-libev/description)

Package/shadowsocks-libev-server/description = $(Package/shadowsocks-libev/description)
Package/shadowsocks-libev-server-polarssl/description = $(Package/shadowsocks-libev/description)

define Package/shadowsocks-libev/conffiles
/etc/shadowsocks.json
endef

define Package/shadowsocks-libev-gfwlist/conffiles
/etc/shadowsocks.json
endef

Package/shadowsocks-libev-polarssl/conffiles = $(Package/shadowsocks-libev/conffiles)
Package/shadowsocks-libev-gfwlist-polarssl/conffiles = $(Package/shadowsocks-libev-gfwlist/conffiles)

define Package/shadowsocks-libev-server/conffiles
/etc/shadowsocks-server.json
endef

Package/shadowsocks-libev-server-polarssl/conffiles = $(Package/shadowsocks-libev-server/conffiles)

define Package/shadowsocks-libev-gfwlist/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then

fi
exit 0
endef

Package/shadowsocks-libev-gfwlist-polarssl/postinst = $(Package/shadowsocks-libev-spec/postinst)

CONFIGURE_ARGS += --disable-ssp

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocks-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{local,redir,tunnel} $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocks.conf $(1)/etc/shadowsocks.json
	$(INSTALL_BIN) ./files/shadowsocks.init $(1)/etc/init.d/shadowsocks
endef

define Package/shadowsocks-libev-gfwlist/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{local,redir,tunnel} $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocks.conf $(1)/etc/shadowsocks.json
	$(INSTALL_BIN) ./files/shadowsocks.init $(1)/etc/init.d/shadowsocks
endef

Package/shadowsocks-libev-polarssl/install = $(Package/shadowsocks-libev/install)
Package/shadowsocks-libev-gfwlist-polarssl/install = $(Package/shadowsocks-libev-gfwlist/install)

define Package/shadowsocks-libev-server/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-server $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocks-server.conf $(1)/etc/shadowsocks-server.json
	$(INSTALL_BIN) ./files/shadowsocks-server.init $(1)/etc/init.d/shadowsocks-server
endef

Package/shadowsocks-libev-server-polarssl/install = $(Package/shadowsocks-libev-server/install)

$(eval $(call BuildPackage,shadowsocks-libev))
$(eval $(call BuildPackage,shadowsocks-libev-gfwlist))
$(eval $(call BuildPackage,shadowsocks-libev-polarssl))
$(eval $(call BuildPackage,shadowsocks-libev-gfwlist-polarssl))

$(eval $(call BuildPackage,shadowsocks-libev-server))
$(eval $(call BuildPackage,shadowsocks-libev-server-polarssl))
