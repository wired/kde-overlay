# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit virtuoso java-pkg-2

DESCRIPTION="JDBC driver for OpenLink Virtuoso Open-Source Edition"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=virtual/jdk-1.6.0
"
RDEPEND="
	>=virtual/jre-1.6.0
"

VOS_EXTRACT="
	libsrc/JDBCDriverType4
"

src_prepare() {
	java-pkg-2_src_prepare
	virtuoso_src_prepare
}

src_configure() {
	myconf="${myconf} --with-jdk4=$(java-config-2 -O)"
	virtuoso_src_configure
}
