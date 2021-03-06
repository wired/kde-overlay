# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="http://www.dragonplayer.net/"

KEYWORDS=""
LICENSE="GPL-2"
IUSE="debug"

RDEPEND="
	>=media-sound/phonon-4.4.3
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
