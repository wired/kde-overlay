# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="KDE4: Ejects optical drives when the eject button is pressed"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	>=kde-base/solid-${PV}:${SLOT}[kdeprefix=]
"
RDEPEND="${DEPEND}"