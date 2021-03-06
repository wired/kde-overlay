# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Akonadi Syncml client"
HOMEPAGE="http://akunambol.ruphy.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	app-office/akonadi-server
	>=app-pda/funambol-client-sdk-9999
	>=kde-base/kdelibs-${KDE_MINIMAL}
	>=kde-base/kdepimlibs-${KDE_MINIMAL}
	net-libs/likeback
"
RDEPEND="${DEPEND}"
