# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

KDE_HANDBOOK="optional"
KMNAME="kdegames"
inherit kde4-meta

DESCRIPTION="Kill the bots or they kill you!"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# Tests hang, last checked in 4.3.3
RESTRICT="test"