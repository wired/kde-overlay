# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KMNAME="extragear/multimedia"
KMMODULE="kaffeine"
inherit kde4-base

DESCRIPTION="Media player for KDE using xine and gstreamer backends."
HOMEPAGE="http://kaffeine.sourceforge.net/"
if [[ ${PV} != *9999* ]] ; then
	KDE_LINGUAS="cs da de el en_GB es et fi fr ga gl hu it ja km ko ku lt mai nb
	nds nl nn pa pl pt pt_BR ro ru se sk sv th tr uk zh_CN zh_TW"
	SRC_URI="mirror://sourceforge/kaffeine/${P/_/-}.tar.gz"
else
	SRC_URI=""
fi

LICENSE="GPL-2"
KEYWORDS=""
SLOT="4"
IUSE="debug"

COMMON_DEPEND="
	>=kde-base/phonon-kde-${KDE_MINIMAL}
	>=kde-base/solid-${KDE_MINIMAL}
	x11-libs/libXScrnSaver
"
DEPEND="${COMMON_DEPEND}
	x11-proto/scrnsaverproto
"
RDEPEND="${COMMON_DEPEND}
	!media-video/kaffeine:0
	!media-video/kaffeine:1
"

S=${WORKDIR}/${P/_/-}

src_configure() {
	mycmakeargs=(
		-DBUILD_po=ON
		$(cmake-utils_use_build debug DEBUG_MODULE)
	)
	kde4-base_src_configure
}
