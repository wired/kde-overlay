# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KMNAME="extragear/pim"
KMMODULE="googledata"
inherit kde4-base

DESCRIPTION="Google contacts and calendar akonadi resource"
HOMEPAGE="http://pim.kde.org/akonadi/"
LICENSE="GPL-2"

SLOT="0"
IUSE="debug"

DEPEND="
	dev-libs/boost
	dev-libs/libxslt
	>=kde-base/kdepimlibs-${KDE_MINIMAL}[semantic-desktop]
	>=net-libs/libgcal-0.9.4
"
RDEPEND="${DEPEND}
	!kde-misc/googledata
"

src_configure() {
	local mycmakeargs
	mycmakeargs=(-DLIBGCAL_INCLUDE_DIR=/usr/include/libgcal)
	kde4-base_src_configure
}
