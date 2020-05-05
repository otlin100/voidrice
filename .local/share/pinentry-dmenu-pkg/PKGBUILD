# Maintainer:  Moritz Lüdecke <ritze@skweez.net>
# Contributor: Maxim 'maximbaz' Baz
# Contributor: Håvard Pettersson <mail@haavard.me>
# Contributor: Sergej Pupykin <pupykin.s+arch@gmail.com>
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>
# Contributor: Thorsten Töpper <atsutane-tu@freethoughts.de>
# Contributor: Thayer Williams <thayer@archlinux.org>
# Contributor: Jeff 'codemac' Mickey <jeff@archlinux.org>

pkgname=pinentry-dmenu
pkgver=0.2.2
pkgrel=1
pkgdesc="A pinentry program with the charm of dmenu"
url="https://github.com/otlin100/pinentry-dmenu"
arch=('i686' 'x86_64')
license=('GPL2')
depends=('sh' 'libconfig'  'libxinerama' 'libxft')
provides=('pinentry')
source=(https://github.com/otlin100/pinentry-dmenu/archive/$pkgver.zip)
sha256sums=('78795659c9d7d2eb0cd916019ada91af930d2c235a70537acb1a526d791473b5')

prepare() {
	cd $pkgname-$pkgver
	# to use a custom config.h, place it in the package directory
	if [[ -f ${SRCDEST}/config.h ]]; then
		cp "${SRCDEST}/config.h" .
	fi
}

build(){
	cd $pkgname-$pkgver
	make \
		X11INC=/usr/include/X11 \
		X11LIB=/usr/lib/X11
}

package() {
	cd $pkgname-$pkgver
	make PREFIX=/usr DESTDIR="$pkgdir" install
}
