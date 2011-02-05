# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit base

MY_MAJOR_VERSION="trunk"

DESCRIPTION="Run executables under a new DBus session for testing"
HOMEPAGE="https://launchpad.net/dbus-test-runner"
SRC_URI="http://launchpad.net/dbus-test-runner/${MY_MAJOR_VERSION}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="dev-libs/dbus-glib"
RDEPEND="${DEPEND}"