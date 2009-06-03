# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-meta/kdesdk-meta-4.2.3.ebuild,v 1.1 2009/05/06 23:17:28 scarabeus Exp $

EAPI="2"

inherit kde4-functions

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
# FIXME:
# Add this back when adding kmtrace
# elibc_glibc
IUSE=""

# NOTE: do not use [kdeprefix=] here, as that would force [-kdeprefix]
# (because there is no kdeprefix in IUSE)
RDEPEND="
	>=kde-base/cervisia-${PV}:${SLOT}
	>=kde-base/kapptemplate-${PV}:${SLOT}
	>=kde-base/kate-${PV}:${SLOT}
	>=kde-base/kbugbuster-${PV}:${SLOT}
	>=kde-base/kcachegrind-${PV}:${SLOT}
	>=kde-base/kdeaccounts-plugin-${PV}:${SLOT}
	>=kde-base/kdesdk-kioslaves-${PV}:${SLOT}
	>=kde-base/kdesdk-misc-${PV}:${SLOT}
	>=kde-base/kdesdk-scripts-${PV}:${SLOT}
	>=kde-base/kdesdk-strigi-analyzer-${PV}:${SLOT}
	>=kde-base/kompare-${PV}:${SLOT}
	>=kde-base/kstartperf-${PV}:${SLOT}
	>=kde-base/kuiviewer-${PV}:${SLOT}
	>=kde-base/lokalize-${PV}:${SLOT}
	>=kde-base/umbrello-${PV}:${SLOT}
"

# FIXME:
# Broken in 4.1.0
#   >=kde-base/kspy-${PV}:${SLOT}
#	elibc_glibc? ( >=kde-base/kmtrace-${PV}:${SLOT} )
#	>=kde-base/kunittest-${PV}:${SLOT}
