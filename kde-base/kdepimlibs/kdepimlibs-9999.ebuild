# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps."
HOMEPAGE="http://www.kde.org/"

KEYWORDS=""
LICENSE="LGPL-2.1"
IUSE="debug +handbook ldap"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.1.6
	>=app-office/akonadi-server-1.2.61
	dev-libs/boost
	dev-libs/libgpg-error
	>=dev-libs/libical-0.43
	dev-libs/cyrus-sasl
	ldap? ( net-nds/openldap )
"
RDEPEND="${DEPEND}"

# libakonadi-contact moved here from akonadi in 4.3.66
add_blocker akonadi 4.1.50 '<4.3.66:4.4' 9999:live
# @since 4.3 - libkholidays is in kdepimlibs now
add_blocker libkholidays

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_build handbook doc)
		$(cmake-utils_use_with ldap)"

	kde4-base_src_configure
}
