# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="extragear/network"
inherit kde4-base

DESCRIPTION="Provides integration for the MLDonkey P2P software and KDE 4."
HOMEPAGE="http://www.kmldonkey.org/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="4"
IUSE="debug plasma"

RDEPEND="
	!net-p2p/kmldonkey:2
	plasma? ( >=kde-base/plasma-workspace-${KDE_MINIMAL} )
"
DEPEND="
	sys-devel/gettext
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with plasma Plasma)"

	kde4-base_src_configure
}