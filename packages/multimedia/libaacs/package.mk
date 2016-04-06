# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libaacs"
PKG_VERSION="0.9.0"
PKG_SHA256="47e0bdc9c9f0f6146ed7b4cc78ed1527a04a537012cf540cf5211e06a248bace"
PKG_LICENSE="GPL"
PKG_SITE="http://www.videolan.org/developers/libaacs.html"
PKG_URL="http://download.videolan.org/pub/videolan/libaacs/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgcrypt"
PKG_LONGDESC="libaacs is a research project to implement the Advanced Access Content System specification."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-werror \
                           --disable-extra-warnings \
                           --disable-optimizations \
                           --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr \
                           --with-libgpg-error-prefix=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/aacs
    cp -P ../KEYDB.cfg $INSTALL/usr/config/aacs

# Hack! To dumb/lazy to do this in a clean way.
  mkdir -p $INSTALL/usr/lib/bd
  mv $INSTALL/usr/lib/libaacs.* $INSTALL/usr/lib/bd
  ln -sf /storage/bd/lib/libaacs.so.0 $INSTALL/usr/lib/libaacs.so.0
  ln -s /storage/bd/bin/makemkvcon $INSTALL/usr/bin/makemkvcon
}
