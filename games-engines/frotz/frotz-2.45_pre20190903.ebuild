# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="57e915b5f5b8997d1e4a1e0dac4ace2e62b7f6e9"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Interpreter for Z-code based text games"
HOMEPAGE="https://661.org/proj/if/frotz/"
SRC_URI="https://gitlab.com/DavidGriffith/${PN}/-/archive/${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ncurses sdl sound unicode"
REQUIRED_USE="sound? ( || ( ncurses sdl ) )"

DEPEND="
	ncurses? (
		sys-libs/ncurses:0=[unicode?]
		sound? ( media-libs/libao )
	)
	sdl? (
		media-libs/freetype:2
		media-libs/libpng:0=
		media-libs/libsdl2[sound,threads,video]
		media-libs/sdl2-mixer
		sys-libs/zlib
		virtual/jpeg:0=
	)
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake \
		dumb \
		$(use ncurses && echo ncurses) \
		$(use sdl && echo sdl) \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		RANLIB="$(tc-getRANLIB)" \
		CURSES=$(usex unicode ncursesw ncurses) \
		USE_UTF8=$(usex unicode yes "") \
		SOUND=$(usex sound ao none) \
		PREFIX="${EPREFIX}/usr" \
		SYSCONFDIR="${EPREFIX}/etc"
}

src_install () {
	emake \
		install_dumb \
		$(use ncurses && echo install) \
		$(use sdl && echo install_sdl) \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}"

	dodoc \
		AUTHORS ChangeLog CONTRIBUTORS DUMB HOW_TO_PLAY README TODO \
		doc/frotz.conf-{big,small}
}

pkg_postinst() {
	echo
	elog "Global config file can be installed in ${EPREFIX}/etc/frotz.conf"
	elog "Sample config files are in ${EPREFIX}/usr/share/doc/${PF}"
	echo
}
