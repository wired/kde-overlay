# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="Phonon GStreamer backend"
HOMEPAGE="http://phonon.kde.org"
EGIT_REPO_URI="git://anongit.kde.org/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="alsa pulseaudio"

COMMON_DEPEND="
	>=media-sound/phonon-4.4.4
	media-libs/gstreamer
	media-plugins/gst-plugins-meta[alsa?]
	pulseaudio? (
		dev-libs/glib:2
		>=media-sound/pulseaudio-0.9.21[glib]
	)
"
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/automoc-0.9.87
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with pulseaudio GLib2)
	)

	cmake-utils_src_configure
}
