# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

if [[ ${PV} = *9999* ]]; then
	inherit git
	EGIT_REPO_URI="git://anongit.kde.org/polkit-kde-agent-1"
	EGIT_PROJECT="polkit-kde-agent-1"
else
	MY_P="${P/agent/agent-1}"
	#SRC_URI="mirror://kde/stable/apps/KDE4.x/admin/${MY_P}.tar.bz2"
	SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
fi
inherit kde4-base

DESCRIPTION="PolKit agent module for KDE."
HOMEPAGE="http://www.kde.org"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	>=sys-auth/polkit-qt-0.98_pre
"
RDEPEND="${DEPEND}
	!sys-auth/polkit-kde
"

[[ ${PV} = *9999* ]] || S="${WORKDIR}/${MY_P}"