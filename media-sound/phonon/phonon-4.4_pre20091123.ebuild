# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit cmake-utils

DESCRIPTION="KDE multimedia API"
HOMEPAGE="http://phonon.kde.org"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="alsa debug gstreamer pulseaudio +xcb +xine"

RDEPEND="
	!kde-base/phonon-xine
	!x11-libs/qt-phonon:4
	>=x11-libs/qt-test-4.4.0:4
	>=x11-libs/qt-dbus-4.4.0:4
	>=x11-libs/qt-gui-4.4.0:4
	>=x11-libs/qt-opengl-4.4.0:4
	gstreamer? (
		media-libs/gstreamer
		media-libs/gst-plugins-base
		alsa? ( media-libs/alsa-lib )
	)
	pulseaudio? (
		dev-libs/glib:2
		>=media-sound/pulseaudio-0.9.21[glib]
	)
	xine? (
		>=media-libs/xine-lib-1.1.15-r1[xcb?]
		xcb? ( x11-libs/libxcb )
	)
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=kde-base/automoc-0.9.87
"

pkg_setup() {
	if use !xine && use !gstreamer; then
		die "you must at least select one backend for phonon"
	fi
}

src_unpack() {
	echo ">>> Unpacking ${P}.tar.xz to ${PWD}"
	xz -dc "${DISTDIR}"/${P}.tar.xz | tar xof -
	assert "failed unpacking ${P}.tar.xz"
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with gstreamer GStreamer)
		$(cmake-utils_use_with gstreamer GStreamerPlugins)
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(cmake-utils_use_with pulseaudio GLib2)
		$(cmake-utils_use_with xine)
		$(cmake-utils_use_with xcb)
	"

	cmake-utils_src_configure
}