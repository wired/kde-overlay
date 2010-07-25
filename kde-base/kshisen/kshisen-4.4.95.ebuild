# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

KMNAME="kdegames"
inherit kde4-meta

DESCRIPTION="A KDE game similiar to Mahjongg"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep libkmahjongg)
"
RDEPEND="${DEPEND}"