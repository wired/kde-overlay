# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit kde4-functions

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.5"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="aqua cups floppy kdeprefix"

RDEPEND="
	$(add_kdebase_dep ark)
	$(add_kdebase_dep kcalc)
	$(add_kdebase_dep kcharselect)
	$(add_kdebase_dep kdf)
	$(add_kdebase_dep kgpg)
	$(add_kdebase_dep kremotecontrol)
	$(add_kdebase_dep ktimer)
	$(add_kdebase_dep kwallet)
	$(add_kdebase_dep superkaramba)
	$(add_kdebase_dep sweeper)
	$(add_kdebase_dep okteta)
	cups? ( $(add_kdebase_dep printer-applet) )
	floppy? ( $(add_kdebase_dep kfloppy) )
	$(block_other_slots)
"