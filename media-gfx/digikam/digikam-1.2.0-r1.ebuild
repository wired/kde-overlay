# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KDE_LINGUAS="ar be bg ca cs da de el es et eu fa fi fr ga gl he hi is it ja km
ko lt lv lb nds ne nl nn pa pl pt pt_BR ro ru se sk sl sv th tr uk vi zh_CN zh_TW"
KMNAME="extragear/graphics"
inherit kde4-base

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="addressbook debug doc geolocation gphoto2 lensfun semantic-desktop +thumbnails"

RDEPEND="
	>=kde-base/kdelibs-${KDE_MINIMAL}[semantic-desktop?]
	>=kde-base/libkdcraw-${KDE_MINIMAL}
	>=kde-base/libkexiv2-${KDE_MINIMAL}
	>=kde-base/libkipi-${KDE_MINIMAL}
	>=kde-base/solid-${KDE_MINIMAL}
	>=kde-base/kreadconfig-${KDE_MINIMAL}
	media-libs/jasper
	>=media-libs/jpeg-8
	media-libs/lcms
	media-libs/liblqr
	media-libs/libpng
	media-libs/tiff
	media-libs/libpgf
	>=media-plugins/kipi-plugins-1.2.0-r1
	virtual/lapack
	x11-libs/qt-gui[qt3support]
	x11-libs/qt-sql[sqlite]
	addressbook? ( >=kde-base/kdepimlibs-${KDE_MINIMAL} )
	geolocation? ( >=kde-base/marble-${KDE_MINIMAL} )
	gphoto2? ( media-libs/libgphoto2 )
	lensfun? ( media-libs/lensfun )
"
DEPEND="${RDEPEND}
	sys-devel/gcc[fortran]
	sys-devel/gettext
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Patch to prevent a crash on startup in RatingWidget (kde#232628)
	epatch "${FILESDIR}/digikam-1.2.0-kde232628.patch"
	# Patch to unbundled libpgf.
	epatch "${FILESDIR}/libpgf-unbundled-digikam-1.2.0-r0.patch"
	# Patch to unbundle lapack.
	epatch "${FILESDIR}/digikam-1.2.0-lapack.patch"

	kde4-base_src_prepare
}

src_configure() {
	local backend

	use semantic-desktop && backend="Nepomuk" || backend="None"
	# LQR = only allows to choose between bundled/external
	mycmakeargs=(
		-DWITH_LQR=ON
		-DENABLE_THEMEDESIGNER=OFF
		-DGWENVIEW_SEMANTICINFO_BACKEND=${backend}
		$(cmake-utils_use_enable gphoto2 GPHOTO2)
		$(cmake-utils_use_with gphoto2)
		$(cmake-utils_use_enable thumbnails THUMBS_DB)
		$(cmake-utils_use_with addressbook KdepimLibs)
		$(cmake-utils_use_with geolocation MarbleWidget)
		$(cmake-utils_use_with lensfun LensFun)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_build doc)
	)

	kde4-base_src_configure
}