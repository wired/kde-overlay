# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdeaccessibility"

inherit kde4-meta

DESCRIPTION="KDE program that clicks the mouse for you."
KEYWORDS=""
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep knotify)
"
