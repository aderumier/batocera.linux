################################################################################
#
# flatpak
#
################################################################################

FLATPAK_VERSION = 1.12.9
FLATPAK_SOURCE = flatpak-$(FLATPAK_VERSION).tar.xz
FLATPAK_SITE = https://github.com/flatpak/flatpak/releases/download/$(FLATPAK_VERSION)

FLATPAK_DEPENDENCIES += appstream-glib glib-networking host-pkgconf host-python3-pyparsing
FLATPAK_DEPENDENCIES += json-glib libarchive libcap libfuse libglib2 libgpgme libostree
FLATPAK_DEPENDENCIES += libseccomp libsoup libsoup3 pkgconf polkit python3-pyparsing yaml-cpp
FLATPAK_DEPENDENCIES += hicolor-icon-theme adwaita-icon-theme adwaita-icon-theme-light

FLATPAK_CONF_OPTS += --with-sysroot="$(STAGING_DIR)"
FLATPAK_CONF_OPTS += --with-gpgme-prefix="$(STAGING_DIR)/usr"
FLATPAK_CONF_OPTS += --with-system-install-dir="/userdata/saves/flatpak/binaries"
FLATPAK_CONF_OPTS += --with-run-media-dir="/media"
FLATPAK_CONF_OPTS += --disable-selinux-module

FLATPAK_CONF_ENV += LDFLAGS=-lpthread

define FLATPAK_INSTALL_SCRIPTS
	install -m 0755 \
	    $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/utils/flatpak/batocera-flatpak-update \
		$(TARGET_DIR)/usr/bin/
	mkdir -p $(TARGET_DIR)/usr/share/emulationstation/hooks
	ln -sf /usr/bin/batocera-flatpak-update \
	    $(TARGET_DIR)/usr/share/emulationstation/hooks/preupdate-gamelists-flatpak
	ln -sf /usr/bin/batocera-steam-update \
	    $(TARGET_DIR)/usr/share/emulationstation/hooks/preupdate-gamelists-steam
endef

FLATPAK_POST_INSTALL_TARGET_HOOKS += FLATPAK_INSTALL_SCRIPTS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
