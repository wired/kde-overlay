# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KMNAME="extragear/sysadmin"
inherit kde4-base

DESCRIPTION="KDE utility for management of partitions and file systems."
HOMEPAGE="http://partitionman.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-libs/libatasmart
	sys-block/parted
	sys-libs/e2fsprogs-libs
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_configure() {
	mycmakeargs=(
		-DPARTMAN_KPART=ON
		-DPARTMAN_KCM=ON
	)

	kde4-base_src_configure
}
