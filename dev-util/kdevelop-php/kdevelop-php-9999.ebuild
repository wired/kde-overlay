# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="kdevelop"
KMMODULE="php"
inherit kde4-base

DESCRIPTION="PHP plugin for KDevelop 4"

LICENSE="GPL-2 LGPL-2"
KEYWORDS=""
IUSE="debug doc"

DEPEND="
	>=dev-util/kdevelop-pg-qt-0.9.0
"
RDEPEND="
	!=dev-util/kdevelop-plugins-1.0.0
	doc? ( >=dev-util/kdevelop-php-docs-${PV}:${SLOT} )
"