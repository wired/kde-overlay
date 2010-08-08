# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="3"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="KDE Desktop Planetarium"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug fits +handbook indi"

DEPEND="
	$(add_kdebase_dep libkdeedu)
	fits? ( >=sci-libs/cfitsio-0.390 )
	indi? ( >=sci-libs/indilib-0.6[fits?] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.4.65-solaris.patch
)

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	mycmakeargs=(
		$(cmake-utils_use_with fits CFitsio)
		$(cmake-utils_use_with indi)
	)

	kde4-meta_src_configure
}