# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdenetwork"
WEBKIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="An advanced download manager for KDE"
KEYWORDS=""
IUSE="debug bittorrent semantic-desktop sqlite"

RDEPEND="
	app-crypt/qca:2
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep libkonq)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep solid)
	bittorrent? ( >=net-libs/libktorrent-1.0.3 )
	sqlite? ( dev-db/sqlite:3 )
	webkit? ( >=kde-misc/kwebkitpart-0.9.6 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_prepare() {
	kde4-meta_src_prepare
	# Disable bittorrent as supported mimetype
	if ! use bittorrent; then
		sed -e '/MimeType=/s|application/x-bittorrent;||' \
			-i kget/desktop/kget.desktop || die
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with bittorrent KTorrent)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with sqlite)
		$(cmake-utils_use_with webkit KWebKitPart)
	)
	kde4-meta_src_configure
}
