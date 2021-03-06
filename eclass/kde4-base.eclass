# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: kde4-base.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: This eclass provides functions for kde 4.X ebuilds
# @DESCRIPTION:
# The kde4-base.eclass provides support for building KDE4 based ebuilds
# and KDE4 applications.
#
# NOTE: KDE 4 ebuilds currently support EAPI "3".  This will be reviewed
# over time as new EAPI versions are approved.

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
#  Do we need an X server? Valid values are "always", "optional", and "manual".
#  "tests" is a synonym for "optional". While virtualx.eclass supports in principle
#  also the use of an X server during other ebuild phases, we only use it in
#  src_test here. Most likely you'll want to set "optional", which introduces the
#  use-flag "test" (if not already present), adds dependencies conditional on that
#  use-flag, and automatically runs (only) the ebuild test phase with a virtual X server
#  present. This makes things a lot more comfortable than the bare virtualx eclass.

# In case the variable is not set in the ebuild, let virtualx eclass not do anything
: ${VIRTUALX_REQUIRED:=manual}

inherit kde4-functions base virtualx eutils

if [[ ${BUILD_TYPE} = live ]]; then
	case ${KDE_SCM} in
		svn) inherit subversion ;;
		git) inherit git-2 ;;
	esac
fi

# @ECLASS-VARIABLE: CMAKE_REQUIRED
# @DESCRIPTION:
# Specify if cmake buildsystem is being used. Possible values are 'always' and 'never'.
# Please note that if it's set to 'never' you need to explicitly override following phases:
# src_configure, src_compile, src_test and src_install.
# Defaults to 'always'.
: ${CMAKE_REQUIRED:=always}
if [[ ${CMAKE_REQUIRED} = always ]]; then
	buildsystem_eclass="cmake-utils"
	export_fns="src_configure src_compile src_test src_install"
fi

# Verify KDE_MINIMAL (display QA notice in pkg_setup, still we need to fix it here)
if [[ -n ${KDE_MINIMAL} ]]; then
	for slot in ${KDE_SLOTS[@]} ${KDE_LIVE_SLOTS[@]}; do
		[[ ${KDE_MINIMAL} = ${slot} ]] && KDE_MINIMAL_VALID=1 && break
	done
	unset slot
	[[ -z ${KDE_MINIMAL_VALID} ]] && unset KDE_MINIMAL
else
	KDE_MINIMAL_VALID=1
fi

# @ECLASS-VARIABLE: KDE_MINIMAL
# @DESCRIPTION:
# This variable is used when KDE_REQUIRED is set, to specify required KDE minimal
# version for apps to work. Currently defaults to 4.4
# One may override this variable to raise version requirements.
# For possible values look at KDE_SLOTS and KDE_LIVE_SLOTS variables.
# Note that it is fixed to ${SLOT} for kde-base packages.
KDE_MINIMAL="${KDE_MINIMAL:-4.4}"

# Set slot for KDEBASE known packages
case ${KDEBASE} in
	kde-base)
		# Determine SLOT from PVs
		case ${PV} in
			*.9999*) SLOT="${PV/.9999*/}" ;; # stable live
			4.6* | 4.5.[6-9][0-9]*) SLOT="4.6" ;;
			4.5* | 4.4.[6-9][0-9]*) SLOT="4.5" ;;
			4.4* | 4.3.[6-9][0-9]*) SLOT="4.4" ;;
			9999*) SLOT="live" ;; # regular live
			*) die "Unsupported ${PV}" ;;
		esac
		KDE_MINIMAL="${SLOT}"
		;;
	koffice)
		SLOT="2"
		;;
	kdevelop)
		if [[ ${BUILD_TYPE} = live ]]; then
			# @ECLASS-VARIABLE: KDEVELOP_VERSION
			# @DESCRIPTION:
			# Specifies KDevelop version. Default is 4.0.0 for tagged packages and 9999 for live packages.
			# Applies to KDEBASE=kdevelop only.
			KDEVELOP_VERSION="${KDEVELOP_VERSION:-9999}"
			# @ECLASS-VARIABLE: KDEVPLATFORM_VERSION
			# @DESCRIPTION:
			# Specifies KDevplatform version. Default is 1.0.0 for tagged packages and 9999 for live packages.
			# Applies to KDEBASE=kdevelop only.
			KDEVPLATFORM_VERSION="${KDEVPLATFORM_VERSION:-9999}"
		else
			case ${PN} in
				kdevelop|quanta)
					KDEVELOP_VERSION=${PV}
					KDEVPLATFORM_VERSION="$(($(get_major_version)-3)).$(get_after_major_version)"
					;;
				kdevplatform)
					KDEVELOP_VERSION="$(($(get_major_version)+3)).$(get_after_major_version)"
					KDEVPLATFORM_VERSION=${PV}
					;;
				*)
					KDEVELOP_VERSION="${KDEVELOP_VERSION:-4.0.0}"
					KDEVPLATFORM_VERSION="${KDEVPLATFORM_VERSION:-1.0.0}"
			esac
		fi
		SLOT="4"
		;;
esac

inherit ${buildsystem_eclass}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare ${export_fns} pkg_postinst pkg_postrm

unset buildsystem_eclass
unset export_fns

# @ECLASS-VARIABLE: DECLARATIVE_REQUIRED
# @DESCRIPTION:
# Is qt-declarative required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
DECLARATIVE_REQUIRED="${DECLARATIVE_REQUIRED:-never}"

# @ECLASS-VARIABLE: QTHELP_REQUIRED
# @DESCRIPTION:
# Is qt-assistant required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
QTHELP_REQUIRED="${QTHELP_REQUIRED:-never}"

# @ECLASS-VARIABLE: OPENGL_REQUIRED
# @DESCRIPTION:
# Is qt-opengl required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
OPENGL_REQUIRED="${OPENGL_REQUIRED:-never}"

# @ECLASS-VARIABLE: MULTIMEDIA_REQUIRED
# @DESCRIPTION:
# Is qt-multimedia required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
MULTIMEDIA_REQUIRED="${MULTIMEDIA_REQUIRED:-never}"

# @ECLASS-VARIABLE: WEBKIT_REQUIRED
# @DESCRIPTION:
# Is qt-webkit requred? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
WEBKIT_REQUIRED="${WEBKIT_REQUIRED:-never}"

# @ECLASS-VARIABLE: CPPUNIT_REQUIRED
# @DESCRIPTION:
# Is cppunit required for tests? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
CPPUNIT_REQUIRED="${CPPUNIT_REQUIRED:-never}"

# @ECLASS-VARIABLE: KDE_REQUIRED
# @DESCRIPTION:
# Is kde required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'always'
# If set to 'always' or 'optional', KDE_MINIMAL may be overriden as well.
# Note that for kde-base packages this variable is fixed to 'always'.
KDE_REQUIRED="${KDE_REQUIRED:-always}"

# @ECLASS-VARIABLE: KDE_HANDBOOK
# @DESCRIPTION:
# Set to enable handbook in application. Possible values are 'always', 'optional'
# (handbook USE flag) and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
# It adds default handbook dirs for kde-base packages to KMEXTRA and in any case it
# ensures buildtime and runtime dependencies.
KDE_HANDBOOK="${KDE_HANDBOOK:-never}"

# @ECLASS-VARIABLE: KDE_LINGUAS_LIVE_OVERRIDE
# @DESCRIPTION:
# Set this varible if you want your live package to manage its
# translations. (Mostly all kde ebuilds does not ship documentation
# and translations in live ebuilds)
if [[ ${BUILD_TYPE} == live && -z ${KDE_LINGUAS_LIVE_OVERRIDE} && ${KDEBASE} != "kde-base" ]]; then
	KDE_HANDBOOK=never
	KDE_LINGUAS=""
fi

# Setup packages inheriting this eclass
case ${KDEBASE} in
	kde-base)
		HOMEPAGE="http://www.kde.org/"
		LICENSE="GPL-2"
		if [[ $BUILD_TYPE = live ]]; then
			# Disable tests for live ebuilds
			RESTRICT+=" test"
			# Live ebuilds in kde-base default to kdeprefix by default
			IUSE+=" +kdeprefix"
		else
			# All other ebuild types default to -kdeprefix as before
			IUSE+=" kdeprefix"
		fi
		# This code is to prevent portage from searching GENTOO_MIRRORS for
		# packages that will never be mirrored. (As they only will ever be in
		# the overlay).
		case ${PV} in
			*9999* | 4.?.[6-9]?)
				RESTRICT+=" mirror"
				;;
		esac
		# Block installation of other SLOTS unless kdeprefix
		RDEPEND+=" $(block_other_slots)"
		;;
	koffice)
		HOMEPAGE="http://www.koffice.org/"
		LICENSE="GPL-2"
		;;
	kdevelop)
		HOMEPAGE="http://www.kdevelop.org/"
		LICENSE="GPL-2"
		;;
esac

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Determine version of qt we enforce as minimal for the package.
if slot_is_at_least 4.6 "${KDE_MINIMAL}"; then
	QT_MINIMAL="${QT_MINIMAL:-4.7.0}"
else
	QT_MINIMAL="${QT_MINIMAL:-4.6.3}"
fi

# Declarative dependencies
qtdeclarativedepend="
	>=x11-libs/qt-declarative-${QT_MINIMAL}:4
"
case ${DECLARATIVE_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtdeclarativedepend}"
		;;
	optional)
		IUSE+=" declarative"
		COMMONDEPEND+=" declarative? ( ${qtdeclarativedepend} )"
		;;
	*) ;;
esac
unset qtdeclarativedepend

# QtHelp dependencies
qthelpdepend="
	>=x11-libs/qt-assistant-${QT_MINIMAL}:4
"
case ${QTHELP_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qthelpdepend}"
		;;
	optional)
		IUSE+=" qthelp"
		COMMONDEPEND+=" qthelp? ( ${qthelpdepend} )"
		;;
esac
unset qthelpdepend

# OpenGL dependencies
qtopengldepend="
	>=x11-libs/qt-opengl-${QT_MINIMAL}:4
"
case ${OPENGL_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtopengldepend}"
		;;
	optional)
		IUSE+=" opengl"
		COMMONDEPEND+=" opengl? ( ${qtopengldepend} )"
		;;
	*) ;;
esac
unset qtopengldepend

# MultiMedia dependencies
qtmultimediadepend="
	>=x11-libs/qt-multimedia-${QT_MINIMAL}:4
"
case ${MULTIMEDIA_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtmultimediadepend}"
		;;
	optional)
		IUSE+=" multimedia"
		COMMONDEPEND+=" multimedia? ( ${qtmultimediadepend} )"
		;;
	*) ;;
esac
unset qtmultimediadepend

# WebKit dependencies
case ${KDE_REQUIRED} in
	always)
		qtwebkitusedeps="[kde]"
		;;
	optional)
		qtwebkitusedeps="[kde?]"
		;;
	*) ;;
esac
qtwebkitdepend="
	>=x11-libs/qt-webkit-${QT_MINIMAL}:4${qtwebkitusedeps}
"
unset qtwebkitusedeps
case ${WEBKIT_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtwebkitdepend}"
		;;
	optional)
		IUSE+=" webkit"
		COMMONDEPEND+=" webkit? ( ${qtwebkitdepend} )"
		;;
	*) ;;
esac
unset qtwebkitdepend

# CppUnit dependencies
cppuintdepend="
	dev-util/cppunit
"
case ${CPPUNIT_REQUIRED} in
	always)
		DEPEND+=" ${cppuintdepend}"
		;;
	optional)
		IUSE+=" test"
		DEPEND+=" test? ( ${cppuintdepend} )"
		;;
	*) ;;
esac
unset cppuintdepend

# KDE dependencies
# Qt accessibility classes are needed in various places, bug 325461
kdecommondepend="
	dev-lang/perl
	>=x11-libs/qt-core-${QT_MINIMAL}:4[qt3support,ssl]
	>=x11-libs/qt-gui-${QT_MINIMAL}:4[accessibility,dbus]
	>=x11-libs/qt-qt3support-${QT_MINIMAL}:4[accessibility,kde]
	>=x11-libs/qt-script-${QT_MINIMAL}:4
	>=x11-libs/qt-sql-${QT_MINIMAL}:4[qt3support]
	>=x11-libs/qt-svg-${QT_MINIMAL}:4
	>=x11-libs/qt-test-${QT_MINIMAL}:4
	!aqua? (
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libXxf86vm
	)
"

if [[ ${PN} != kdelibs ]]; then
	kdecommondepend+=" $(add_kdebase_dep kdelibs)"
	if [[ ${KDEBASE} = kdevelop ]]; then
		if [[ ${PN} != kdevplatform ]]; then
			# @ECLASS-VARIABLE: KDEVPLATFORM_REQUIRED
			# @DESCRIPTION:
			# Specifies whether kdevplatform is required. Possible values are 'always' (default) and 'never'.
			# Applies to KDEBASE=kdevelop only.
			KDEVPLATFORM_REQUIRED="${KDEVPLATFORM_REQUIRED:-always}"
			case ${KDEVPLATFORM_REQUIRED} in
				always)
					kdecommondepend+="
						>=dev-util/kdevplatform-${KDEVPLATFORM_VERSION}
					"
					;;
				*) ;;
			esac
		fi
	fi
fi

kdedepend="
	dev-util/automoc
	dev-util/pkgconfig
	!aqua? (
		>=x11-libs/libXtst-1.1.0
		x11-proto/xf86vidmodeproto
	)
"

kderdepend=""

# all packages needs oxygen icons for basic iconset
if [[ ${PN} != oxygen-icons ]]; then
	kderdepend+=" $(add_kdebase_dep oxygen-icons)"
fi

# add dependency over kde-l10n if EAPI4 is around
if [[ KDEBASE != "kde-base" && -n ${KDE_LINGUAS} ]] && has "${EAPI:-0}" 4; then
	for _lingua in ${KDE_LINGUAS}; do
		# if our package has lignuas pull in kde-l10n with selected lingua
		kderdepend+=" $(add_kdebase_dep kde-l10n "[linguas_${_lingua}(+)]")"
	done
fi

kdehandbookdepend="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
"
kdehandbookrdepend="
	$(add_kdebase_dep kdelibs 'handbook')
"
case ${KDE_HANDBOOK} in
	always)
		kdedepend+=" ${kdehandbookdepend}"
		[[ ${PN} != kdelibs ]] && kderdepend+=" ${kdehandbookrdepend}"
		;;
	optional)
		IUSE+=" +handbook"
		kdedepend+=" handbook? ( ${kdehandbookdepend} )"
		[[ ${PN} != kdelibs ]] && kderdepend+=" handbook? ( ${kdehandbookrdepend} )"
		;;
	*) ;;
esac
unset kdehandbookdepend kdehandbookrdepend

case ${KDE_REQUIRED} in
	always)
		IUSE+=" aqua"
		[[ -n ${kdecommondepend} ]] && COMMONDEPEND+=" ${kdecommondepend}"
		[[ -n ${kdedepend} ]] && DEPEND+=" ${kdedepend}"
		[[ -n ${kderdepend} ]] && RDEPEND+=" ${kderdepend}"
		;;
	optional)
		IUSE+=" aqua kde"
		[[ -n ${kdecommondepend} ]] && COMMONDEPEND+=" kde? ( ${kdecommondepend} )"
		[[ -n ${kdedepend} ]] && DEPEND+=" kde? ( ${kdedepend} )"
		[[ -n ${kderdepend} ]] && RDEPEND+=" kde? ( ${kderdepend} )"
		;;
	*) ;;
esac

unset kdecommondepend kdedepend kderdepend

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: COMMONDEPEND is ${COMMONDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND (only) is ${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND (only) is ${RDEPEND}"

# Accumulate dependencies set by this eclass
DEPEND+=" ${COMMONDEPEND}"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

# Add experimental kdeenablefinal, masked by default
IUSE+=" kdeenablefinal"

# Fetch section - If the ebuild's category is not 'kde-base' and if it is not a
# koffice ebuild, the URI should be set in the ebuild itself
_calculate_src_uri() {
	debug-print-function ${FUNCNAME} "$@"

	local _kmname _kmname_pv

	# we calculate URI only for known KDEBASE modules
	[[ -n ${KDEBASE} ]] || return

	# calculate tarball module name
	if [[ -n ${KMNAME} ]]; then
		# fixup kdebase-apps name
		case ${KMNAME} in
			kdebase-apps)
				_kmname="kdebase" ;;
			*)
				_kmname="${KMNAME}" ;;
		esac
	else
		_kmname=${PN}
	fi
	_kmname_pv="${_kmname}-${PV}"
	case ${KDEBASE} in
		kde-base)
			case ${PV} in
				4.[456].8[05] | 4.[456].9[023568] | 4.5.94.1)
					# Unstable KDE SC releases
					SRC_URI="mirror://kde/unstable/${PV}/src/${_kmname_pv}.tar.bz2"
					# KDEPIM IS SPECIAL
					[[ ${KMNAME} == "kdepim" || ${KMNAME} == "kdepim-runtime" ]] && SRC_URI="mirror://kde/unstable/kdepim/${PV}/src/${_kmname_pv}.tar.bz2"
					;;
				4.4.[6789] | 4.4.1?)
					# Stable kdepim releases
					SRC_URI="mirror://kde/stable/kdepim-${PV}/src/${_kmname_pv}.tar.bz2"
					;;
				*)
					# Stable KDE SC releases
					SRC_URI="mirror://kde/stable/${PV}/src/${_kmname_pv}.tar.bz2"
					;;
			esac
			;;
		koffice)
			case ${PV} in
				2.[1234].[6-9]*) SRC_URI="mirror://kde/unstable/${_kmname_pv}/${_kmname_pv}.tar.bz2" ;;
				*) SRC_URI="mirror://kde/stable/${_kmname_pv}/${_kmname_pv}.tar.bz2" ;;
			esac
			;;
		kdevelop)
			SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.bz2"
			;;
	esac
}

_calculate_live_repo() {
	debug-print-function ${FUNCNAME} "$@"

	SRC_URI=""
	case ${KDE_SCM} in
		svn)
			# Determine branch URL based on live type
			local branch_prefix
			case ${PV} in
				9999*)
					# trunk
					branch_prefix="trunk/KDE"
					;;
				*)
					# branch
					branch_prefix="branches/KDE/${SLOT}"
					# @ECLASS-VARIABLE: ESVN_PROJECT_SUFFIX
					# @DESCRIPTION
					# Suffix appended to ESVN_PROJECT depending on fetched branch.
					# Defaults is empty (for -9999 = trunk), and "-${PV}" otherwise.
					ESVN_PROJECT_SUFFIX="-${PV}"
					;;
			esac
			# @ECLASS-VARIABLE: ESVN_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anonsvn) with anything else you might want to use.
			ESVN_MIRROR=${ESVN_MIRROR:=svn://anonsvn.kde.org/home/kde}
			# Split ebuild, or extragear stuff
			if [[ -n ${KMNAME} ]]; then
				ESVN_PROJECT="${KMNAME}${ESVN_PROJECT_SUFFIX}"
				if [[ -z ${KMNOMODULE} ]] && [[ -z ${KMMODULE} ]]; then
					KMMODULE="${PN}"
				fi
				# Split kde-base/ ebuilds: (they reside in trunk/KDE)
				case ${KMNAME} in
					kdebase-*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdebase/${KMNAME#kdebase-}"
						;;
					kdelibs-*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdelibs/${KMNAME#kdelibs-}"
						;;
					kdereview*)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						;;
					kdesupport)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
						;;
					kde*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${KMNAME}"
						;;
					extragear*|playground*)
						# Unpack them in toplevel dir, so that they won't conflict with kde4-meta
						# build packages from same svn location.
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
						;;
					koffice)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}"
						;;
					*)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						;;
				esac
			else
				# kdelibs, kdepimlibs
				ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${PN}"
				ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
			fi
			# @ECLASS-VARIABLE: ESVN_UP_FREQ
			# @DESCRIPTION:
			# This variable is used for specifying the timeout between svn synces
			# for kde-base and koffice modules. Does not affect misc apps.
			# Default value is 1 hour.
			[[ ${KDEBASE} = kde-base || ${KDEBASE} = koffice ]] && ESVN_UP_FREQ=${ESVN_UP_FREQ:-1}
			;;
		git)
			local _kmname
			# @ECLASS-VARIABLE: EGIT_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anongit) with anything else you might want to use.
			EGIT_MIRROR=${EGIT_MIRROR:=git://anongit.kde.org}

			# @ECLASS-VARIABLE: EGIT_REPONAME
			# @DESCRIPTION:
			# This variable allows overriding of default repository
			# name. Specify only if this differ from PN and KMNAME.
			if [[ -n ${EGIT_REPONAME} ]]; then
				# the repository and kmname different
				_kmname=${EGIT_REPONAME}
			elif [[ -n ${KMNAME} ]]; then
				_kmname=${KMNAME}
			else
				_kmname=${PN}
			fi

			# default branching
			case ${PV} in
				9999*) ;;
				*)
					# set EGIT_BRANCH and EGIT_COMMIT to ${SLOT}
					case ${_kmname} in
						kdeplasma-addons | kdepim | kdepim-runtime | kdepimlibs)
							EGIT_BRANCH="${SLOT}"
							;;
						*) EGIT_BRANCH="KDE/${SLOT}" ;;
					esac
					;;
			esac

			case $_kmname in
				kdepim|kdepim-runtime)
					case ${PV} in
						# kdepim still did not branch
						4.6.9999)
							EGIT_BRANCH="master"
							;;
					esac
					;;
			esac
			EGIT_REPO_URI="${EGIT_MIRROR}/${_kmname}"

			debug-print "${FUNCNAME}: Repository: ${EGIT_REPO_URI}"
			debug-print "${FUNCNAME}: Branch: ${EGIT_BRANCH}"
			;;
	esac
}

case ${BUILD_TYPE} in
	live) _calculate_live_repo ;;
	*) _calculate_src_uri ;;
esac

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"

# @ECLASS-VARIABLE: PREFIX
# @DESCRIPTION:
# Set the installation PREFIX for non kde-base applications. It defaults to /usr.
# kde-base packages go into KDE4 installation directory (KDEDIR) by default.
# No matter the PREFIX, package will be built against KDE installed in KDEDIR.

# @FUNCTION: kde4-base_pkg_setup
# @DESCRIPTION:
# Do the basic kdeprefix KDEDIR settings and determine with which kde should
# optional applications link
kde4-base_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# QA ebuilds
	[[ -z ${KDE_MINIMAL_VALID} ]] && ewarn "QA Notice: ignoring invalid KDE_MINIMAL (defaulting to ${KDE_MINIMAL})."

	# Don't set KDEHOME during compilation, it will cause access violations
	unset KDEHOME

	if [[ ${KDEBASE} = kde-base ]]; then
		if use kdeprefix; then
			KDEDIR=/usr/kde/${SLOT}
		else
			KDEDIR=/usr
		fi
		: ${PREFIX:=${KDEDIR}}
	else
		# Determine KDEDIR by loooking for the closest match with KDE_MINIMAL
		KDEDIR=
		local kde_minimal_met
		for slot in ${KDE_SLOTS[@]} ${KDE_LIVE_SLOTS[@]}; do
			[[ -z ${kde_minimal_met} ]] && [[ ${slot} = ${KDE_MINIMAL} ]] && kde_minimal_met=1
			if [[ -n ${kde_minimal_met} ]] && has_version "kde-base/kdelibs:${slot}"; then
				if has_version "kde-base/kdelibs:${slot}[kdeprefix]"; then
					KDEDIR=/usr/kde/${slot}
				else
					KDEDIR=/usr
				fi
				break;
			fi
		done
		unset slot

		# Bail out if kdelibs required but not found
		if [[ ${KDE_REQUIRED} = always ]] || { [[ ${KDE_REQUIRED} = optional ]] && use kde; }; then
			[[ -z ${KDEDIR} ]] && die "Failed to determine KDEDIR!"
		else
			[[ -z ${KDEDIR} ]] && KDEDIR=/usr
		fi

		: ${PREFIX:=/usr}
	fi
	EKDEDIR=${EPREFIX}${KDEDIR}

	# Point pkg-config path to KDE *.pc files
	export PKG_CONFIG_PATH="${EKDEDIR}/$(get_libdir)/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
	# Point to correct QT plugins path
	QT_PLUGIN_PATH="${EKDEDIR}/$(get_libdir)/kde4/plugins/"

	# Fix XDG collision with sandbox
	export XDG_CONFIG_HOME="${T}"
}

# @FUNCTION: kde4-base_src_unpack
# @DESCRIPTION:
# This function unpacks the source tarballs for KDE4 applications.
kde4-base_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn)
				migrate_store_dir
				subversion_src_unpack
				;;
			git)
				git-2_src_unpack
				;;
		esac
	else
		unpack ${A}
	fi
}

# @FUNCTION: kde4-base_src_prepare
# @DESCRIPTION:
# General pre-configure and pre-compile function for KDE4 applications.
# It also handles translations if KDE_LINGUAS is defined. See KDE_LINGUAS and
# enable_selected_linguas() and enable_selected_doc_linguas()
# in kde4-functions.eclass(5) for further details.
kde4-base_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	# enable handbook and linguas only when not using live ebuild

	# Only enable selected languages, used for KDE extragear apps.
	if [[ -n ${KDE_LINGUAS} ]]; then
		enable_selected_linguas
	fi

	# Enable/disable handbooks for kde4-base packages
	# kde-l10n inherits kde4-base but is metpackage, so no check for doc
	# kdelibs inherits kde4-base but handle installing the handbook itself
	if ! has kde4-meta ${INHERITED}; then
		has handbook ${IUSE//+} && [[ ${PN} != kde-l10n ]] && [[ ${PN} != kdelibs ]] && enable_selected_doc_linguas
	fi

	# SCM bootstrap
	if [[ ${BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn) subversion_src_prepare ;;
		esac
	fi

	# Apply patches
	base_src_prepare

	# Save library dependencies
	if [[ -n ${KMSAVELIBS} ]] ; then
		save_library_dependencies
	fi

	# Inject library dependencies
	if [[ -n ${KMLOADLIBS} ]] ; then
		load_library_dependencies
	fi

	# Replace KDE4Workspace library targets
	find "${S}" -name CMakeLists.txt \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_TASKMANAGER_(LIBRARY|LIBS)\}/taskmanager/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_KWORKSPACE_(LIBRARY|LIBS)\}/kworkspace/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_SOLIDCONTROLIFACES_(LIBRARY|LIBS)\}/solidcontrolifaces/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_SOLIDCONTROL_(LIBRARY|LIBS)\}/solidcontrol/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_PROCESSUI_(LIBRARY|LIBS)\}/processui/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_LSOFUI_(LIBRARY|LIBS)\}/lsofui/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_PLASMACLOCK_(LIBRARY|LIBS)\}/plasmaclock/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_NEPOMUKQUERYCLIENT_(LIBRARY|LIBS)\}/nepomukqueryclient/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_NEPOMUKQUERY_(LIBRARY|LIBS)\}/nepomukquery/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_KSCREENSAVER_(LIBRARY|LIBS)\}/kscreensaver/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_WEATHERION_(LIBRARY|LIBS)\}/weather_ion/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_KWINEFFECTS_(LIBRARY|LIBS)\}/kwineffects/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_KDECORATIONS_(LIBRARY|LIBS)\}/kdecorations/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_KSGRD_(LIBRARY|LIBS)\}/ksgrd/g' {} + \
		-exec sed -i -r -e 's/\$\{KDE4WORKSPACE_KEPHAL_(LIBRARY|LIBS)\}/kephal/g' {} + \
		|| die 'failed to replace KDE4Workspace library targets'

	# Hack for manuals relying on outdated DTD, only outside kde-base/koffice/...
	if [[ -z ${KDEBASE} ]]; then
		find "${S}" -name "*.docbook" \
			-exec sed -i -r \
				-e 's:-//KDE//DTD DocBook XML V4\.1(\..)?-Based Variant V1\.[01]//EN:-//KDE//DTD DocBook XML V4.2-Based Variant V1.1//EN:g' {} + \
			|| die 'failed to fix DocBook variant version'
	fi
}

# @FUNCTION: kde4-base_src_configure
# @DESCRIPTION:
# Function for configuring the build of KDE4 applications.
kde4-base_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Build tests in src_test only, where we override this value
	local cmakeargs=(-DKDE4_BUILD_TESTS=OFF)

	if has kdeenablefinal ${IUSE//+} && use kdeenablefinal; then
		cmakeargs+=(-DKDE4_ENABLE_FINAL=ON)
	fi

	if has debug ${IUSE//+} && use debug; then
		# Set "real" debug mode
		CMAKE_BUILD_TYPE="Debugfull"
	else
		# Handle common release builds
		append-cppflags -DQT_NO_DEBUG
	fi

	# Set distribution name
	[[ ${PN} = kdelibs ]] && cmakeargs+=(-DKDE_DISTRIBUTION_TEXT=Gentoo)

	# Here we set the install prefix
	tc-is-cross-compiler || cmakeargs+=(-DCMAKE_INSTALL_PREFIX="${EPREFIX}${PREFIX}")

	# Use colors
	QTEST_COLORED=1

	# Shadow existing /usr installations
	unset KDEDIRS

	# Handle kdeprefix-ed KDE
	if [[ ${KDEDIR} != /usr ]]; then
		# Override some environment variables - only when kdeprefix is different,
		# to not break ccache/distcc
		PATH="${EKDEDIR}/bin:${PATH}"

		# Append library search path
		append-ldflags -L"${EKDEDIR}/$(get_libdir)"

		# Append full RPATH
		cmakeargs+=(-DCMAKE_SKIP_RPATH=OFF)

		# Set cmake prefixes to allow buildsystem to locate valid KDE installation
		# when more are present
		cmakeargs+=(-DCMAKE_SYSTEM_PREFIX_PATH="${EKDEDIR}")
	fi

	#qmake -query QT_INSTALL_LIBS unavailable when cross-compiling
	tc-is-cross-compiler && cmakeargs+=(-DQT_LIBRARY_DIR=${ROOT}/usr/lib/qt4)
	#kde-config -path data unavailable when cross-compiling
	tc-is-cross-compiler && cmakeargs+=(-DKDE4_DATA_DIR=${ROOT}/usr/share/apps/)

	# Handle kdeprefix in application itself
	if ! has kdeprefix ${IUSE//+} || ! use kdeprefix; then
		# If prefix is /usr, sysconf needs to be /etc, not /usr/etc
		cmakeargs+=(-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc)
	fi

	if [[ $(declare -p mycmakeargs 2>&-) != "declare -a mycmakeargs="* ]]; then
		mycmakeargs=(${mycmakeargs})
	fi

	mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

	cmake-utils_src_configure
}

# @FUNCTION: kde4-base_src_compile
# @DESCRIPTION:
# General function for compiling KDE4 applications.
kde4-base_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake-utils_src_compile "$@"
}

# @FUNCTION: kde4-base_src_test
# @DESCRIPTION:
# Function for testing KDE4 applications.
kde4-base_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	# Override this value, set in kde4-base_src_configure()
	mycmakeargs+=(-DKDE4_BUILD_TESTS=ON)
	cmake-utils_src_configure
	kde4-base_src_compile

	# When run as normal user during ebuild development with the ebuild command, the
	# kde tests tend to access the session DBUS. This however is not possible in a real
	# emerge or on the tinderbox.
	# > make sure it does not happen, so bad tests can be recognized and disabled
	unset DBUS_SESSION_BUS_ADDRESS

	if [[ ${VIRTUALX_REQUIRED} == always ]] ||
		( [[ ${VIRTUALX_REQUIRED} != manual ]] && use test ); then

		if [[ ${maketype} ]]; then
			# surprise- we are already INSIDE virtualmake!!!
			ewarn "QA Notice: This version of kde4-base.eclass includes the virtualx functionality."
			ewarn "           You may NOT set maketype or call virtualmake from the ebuild. Applying workaround."
			cmake-utils_src_test
		else
			export maketype="cmake-utils_src_test"
			virtualmake
		fi
	else
		cmake-utils_src_test
	fi
}

# @FUNCTION: kde4-base_src_install
# @DESCRIPTION:
# Function for installing KDE4 applications.
kde4-base_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${KMSAVELIBS} ]] ; then
		install_library_dependencies
	fi

	# Install common documentation of KDE4 applications
	local doc
	if ! has kde4-meta ${INHERITED}; then
		for doc in "${S}"/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
			[[ -f "${doc}" ]] && [[ -s "${doc}" ]] && dodoc "${doc}"
		done
		for doc in "${S}"/*/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
			[[ -f "${doc}" ]] && [[ -s "${doc}" ]] && newdoc "${doc}" "$(basename $(dirname ${doc})).$(basename ${doc})"
		done
	fi

	cmake-utils_src_install
}

# @FUNCTION: kde4-base_pkg_postinst
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been installed.
kde4-base_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	buildsycoca

	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		if has kdeenablefinal ${IUSE//+} && use kdeenablefinal; then
			echo
			ewarn "WARNING! you have kdeenable final useflag enabled."
			ewarn "This useflag needs to be enabled on ALL kde using packages and"
			ewarn "is known to cause issues."
			ewarn "You are using this setup at your own risk and the kde team does not"
			ewarn "take responsibilities for dead kittens."
			echo
		fi
		if [[ ${BUILD_TYPE} = live ]]; then
			echo
			einfo "WARNING! This is an experimental live ebuild of ${CATEGORY}/${PN}"
			einfo "Use it at your own risk."
			einfo "Do _NOT_ file bugs at bugs.gentoo.org because of this ebuild!"
			echo
		elif [[ ${BUILD_TYPE} != live ]] && has kdeprefix ${IUSE//+} && use kdeprefix; then
			# warning about kdeprefix for non-live users
			echo
			ewarn "WARNING! You have the kdeprefix useflag enabled."
			ewarn "This setting is strongly discouraged and might lead to potential trouble"
			ewarn "with KDE update strategies."
			ewarn "You are using this setup at your own risk and the kde team does not"
			ewarn "take responsibilities for dead kittens."
			echo
		fi
		# for all 3rd party soft tell user that he SHOULD install kdebase-startkde or kdebase-runtime-meta
		if [[ ${KDEBASE} != "kde-base" ]] && \
				! has_version 'kde-base/kdebase-runtime-meta' && \
				! has_version 'kde-base/kdebase-startkde'; then
			if [[ ${KDE_REQUIRED} == always ]] || ( [[ ${KDE_REQUIRED} == optional ]] && use kde ); then
				echo
				ewarn "WARNING! Your system configuration contains neither \"kde-base/kdebase-runtime-meta\""
				ewarn "nor \"kde-base/kdebase-startkde\". You need one of above."
				ewarn "With this setting you are unsupported by KDE team."
				ewarn "All missing features you report for misc packages will be probably ignored or closed as INVALID."
			fi
		fi
	fi
}

# @FUNCTION: kde4-base_pkg_postrm
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been removed.
kde4-base_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	buildsycoca
}
