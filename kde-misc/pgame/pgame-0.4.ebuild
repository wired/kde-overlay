# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit kde4-base

DESCRIPTION="KDE4 plasmoid. PGame is a plasmoid similar to xgame."
HOMEPAGE="http://kde-look.org/content/show.php/PGame?content=99357"
SRC_URI="http://kde-look.org/CONTENT/content-files/99357-pgame-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
	!kde-plasmoids/pgame
	>=kde-base/plasma-workspace-4.2.87
"
