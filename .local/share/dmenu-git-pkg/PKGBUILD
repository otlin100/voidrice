# Maintainer:  Håvard Pettersson <mail@haavard.me>
# Contributor: Sergej Pupykin <pupykin.s+arch@gmail.com>
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>
# Contributor: Thorsten Töpper <atsutane-tu@freethoughts.de>
# Contributor: Thayer Williams <thayer@archlinux.org>
# Contributor: Jeff 'codemac' Mickey <jeff@archlinux.org>

pkgname=dmenu-lin-git
_pkgname=dmenu-lin
pkgver=4.9.1a.r5.a018a58
pkgrel=1
pkgdesc="A generic menu for X"
url='https://github.com/otlin100/dmenu.git'
arch=('i686' 'x86_64')
license=('MIT')
depends=('sh' 'libxinerama' 'libxft')
makedepends=('git')
provides=('dmenu')
conflicts=('dmenu')
source=("${_pkgname}::git+$url")
sha256sums=('SKIP')

pkgver() {
  cd "${_pkgname}"
  _pkgver=$(awk '/VERSION/ {print $3}' config.mk|head -1)
  echo "${_pkgver}.r$(git rev-list --count HEAD).$(git rev-parse --short HEAD)"
}

prepare() {
  cd $_pkgname
  # to use a custom config.h, place it in the package directory
  if [[ -f ${SRCDEST}/config.h ]]; then
      cp "${SRCDEST}/config.h" .
  fi
}

build(){
  cd $_pkgname
  make \
    X11INC=/usr/include/X11 \
    X11LIB=/usr/lib/X11
}

package() {
  cd $_pkgname
  make PREFIX=/usr DESTDIR="$pkgdir" install
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
