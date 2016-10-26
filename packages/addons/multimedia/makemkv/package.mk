PKG_NAME="makemkv"
PKG_VERSION="1.10.8"
PKG_REV="0-"$PKG_VERSION
PKG_ARCH="x86_64"
PKG_LICENSE="OSS"
PKG_SITE="http://www.makemkv.com/forum2/viewforum.php?f=3"
PKG_URL="http://www.makemkv.com/download/${PKG_NAME}-oss-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl expat ffmpeg"
PKG_PRIORITY="optional"
PKG_SECTION="lib/multimedia"
PKG_SHORTDESC="MakeMKV converts the video clips from proprietary (and usually encrypted) disc into a set of MKV files, preserving most information but not changing it in any way."
PKG_LONGDESC="MakeMKV can instantly stream decrypted video without intermediate conversion to wide range of players, so you may watch Blu-ray and DVD discs with your favorite player on your favorite OS or on your favorite device."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-gui --enable-noec"

post_unpack() {
  mv $BUILD/${PKG_NAME}-oss-${PKG_VERSION} $BUILD/$PKG_NAME-$PKG_VERSION

  # download and extract bin package
  BIN_PACKAGE_FILE=${PKG_NAME}-bin-${PKG_VERSION}.tar.gz
  BIN_PACKAGE="$SOURCES/$PKG_NAME/$BIN_PACKAGE_FILE"

  if [ ! -f "$BIN_PACKAGE" ]; then
    cd $SOURCES/$PKG_NAME
    wget --timeout=30 --tries=3 http://www.makemkv.com/download/$BIN_PACKAGE_FILE
  fi

  cd $PKG_BUILD
  tar -xzf $BIN_PACKAGE
  mv ./${PKG_NAME}-bin-${PKG_VERSION} bin
  rm -rf ./${PKG_NAME}-bin-${PKG_VERSION}
  cd $ROOT
}

pre_configure_target() {
# makemkv fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/lib
  install -m 0755 -D bin/bin/amd64/makemkvcon $INSTALL/usr/bin
  cp out/libmakemkv.so.[0-9] $INSTALL/usr/lib
  cp out/libdriveio.so.[0-9] $INSTALL/usr/lib
  cp out/libmmbd.so.[0-9] $INSTALL/usr/lib
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/bin/bin/amd64/makemkvcon $ADDON_BUILD/$PKG_ADDON_ID/bin/makemkvcon.bin
  chmod 755 $ADDON_BUILD/$PKG_ADDON_ID/bin/makemkvcon.bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $PKG_BUILD/out/libmakemkv.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $PKG_BUILD/out/libdriveio.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $PKG_BUILD/out/libmmbd.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
}
