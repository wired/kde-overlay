# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

KMNAME="kdegames"
inherit kde4-meta

DESCRIPTION="KDE Bomberman game"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook gluon"

DEPEND="
	gluon? ( media-libs/gluon )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use gluon GRANATIER_USE_GLUON_SOUND_BACKEND)
	)

	kde4-meta_src_configure
}