# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit kde4-base subversion

ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/playground/base/plasma/applets/networkmanager@1044410"

DESCRIPTION="KDE frontend for NetworkManager"
HOMEPAGE="http://kde.org/"

LICENSE="GPL-2 LGPL-2"
KEYWORDS=""
SLOT="4"
IUSE="debug"

DEPEND="
	!kde-misc/networkmanager-applet
	>=kde-base/solid-${KDE_MINIMAL}[networkmanager]
	>=net-misc/networkmanager-0.7
"
RDEPEND="${DEPEND}"

src_configure() {

	# Fix dbus policy
	sed -i 's/at_console=".*"/group="plugdev"/' \
			"${S}/NetworkManager-kde4.conf" \
				|| die "Fixing dbus policy failed"
	
	# remove plasmoid, doesnt work
	sed -i 's/add_subdirectory(applet)//' \
			"${S}/CMakeLists.txt" \
				|| die "removing plasmoid failed"

	mycmakeargs="${mycmakeargs}
		-DDBUS_SYSTEM_POLICY_DIR=/etc/dbus-1/system.d"

	kde4-base_src_configure
}