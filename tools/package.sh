#!/bin/bash
# Builds the packages of the Aquarium for Linux, Windows and macOS from the
# official Squeak 6.0 downloads, as in the releases on GitHub:
#
#   tools/package.sh [version]          into build/
#
# Downloads Squeak's All-in-One, its Linux and its Windows bundles; builds
# Aquarium.image with the Linux VM (on the display, or on a hidden one with
# xvfb-run when there is none); and puts it beside each Squeak, which is left
# as it is: the macOS app stays as the Squeak team signed it. Needs curl,
# unzip, zip, and on a machine without a display xvfb-run.
set -e
cd "$(dirname "$0")/.."
VERSION=${1:-1.0}
SQUEAK=Squeak6.0-22156-64bit
STAMP=202606270913
URL=https://files.squeak.org/6.0/$SQUEAK
OUT=$PWD/build
mkdir -p "$OUT/downloads"
cd "$OUT/downloads"
for f in $SQUEAK-All-in-One.zip $SQUEAK-$STAMP-Linux-x64.tar.gz $SQUEAK-$STAMP-Windows-x64.zip; do
    [ -f "$f" ] || curl -fsSO "$URL/$f"
done
rm -rf aio lin win && mkdir aio lin win
unzip -q $SQUEAK-All-in-One.zip -d aio
tar -xzf $SQUEAK-$STAMP-Linux-x64.tar.gz -C lin
unzip -q $SQUEAK-$STAMP-Windows-x64.zip -d win
APP=aio/$SQUEAK-All-in-One.app

# The image: a fresh Squeak 6.0 with the Aquarium loaded and open
IMG=$OUT/image && rm -rf "$IMG" && mkdir -p "$IMG"
cp "$APP/Contents/Resources/$SQUEAK.image" "$IMG/Aquarium.image"
cp "$APP/Contents/Resources/$SQUEAK.changes" "$IMG/Aquarium.changes"
cp "$APP/Contents/Resources/SqueakV60.sources" "$OUT/../Aquarium.st" "$OUT/../mcmFish.morph" \
    "$OUT/../tools/build-image.st" "$IMG/"
VM=$PWD/$APP/Contents/Linux-x86_64/squeak
RUN=()
[ -z "$DISPLAY" ] && RUN=(xvfb-run -a -s "-screen 0 1024x768x24")
(cd "$IMG" && "${RUN[@]}" "$VM" Aquarium.image "$IMG/build-image.st")
grep -q built "$IMG/report.txt" || { cat "$IMG/report.txt"; exit 1; }

cd "$OUT"
rm -rf aquarium-for-squeak-$VERSION-*
README=../tools/package-readme.txt

L=aquarium-for-squeak-$VERSION-linux-x64
cp -r downloads/lin/$SQUEAK-$STAMP-Linux-x64 $L
rm $L/shared/$SQUEAK.image $L/shared/$SQUEAK.changes
cp image/Aquarium.image image/Aquarium.changes $L/shared/
cp ../LICENSE $L/LICENSE.txt
chmod 644 $L/LICENSE.txt $L/README.txt 2>/dev/null || true
{ cat $README; printf '\nLinux: run ./Aquarium.sh.\n'; } > $L/README.txt
printf '#!/bin/bash\n# Starts the Aquarium in the Squeak 6.0 of this folder.\ncd "$(dirname "$(readlink -f "$0")")" || exit 1\nexec ./squeak.sh "$PWD/shared/Aquarium.image"\n' > $L/Aquarium.sh
chmod +x $L/Aquarium.sh
tar -czf $L.tar.gz $L

W=aquarium-for-squeak-$VERSION-windows-x64
cp -r downloads/win/$SQUEAK-$STAMP-Windows-x64 $W
rm $W/$SQUEAK.image $W/$SQUEAK.changes
cp image/Aquarium.image image/Aquarium.changes $W/
cp ../LICENSE $W/LICENSE.txt
chmod 644 $W/LICENSE.txt $W/README.txt 2>/dev/null || true
{ cat $README; printf '\nWindows: double-click Aquarium.bat. Windows may warn about a program from the\ninternet: choose More info, then Run anyway.\n'; } | sed 's/$/\r/' > $W/README.txt
printf '@echo off\r\nREM Starts the Aquarium in the Squeak 6.0 of this folder.\r\ncd /d "%%~dp0"\r\nstart "" Squeak.exe Aquarium.image\r\n' > $W/Aquarium.bat
zip -qr $W.zip $W

M=aquarium-for-squeak-$VERSION-macos
mkdir $M
cp -a downloads/$APP $M/Squeak.app
cp image/Aquarium.image image/Aquarium.changes downloads/$APP/Contents/Resources/SqueakV60.sources $M/
cp ../LICENSE $M/LICENSE.txt
chmod 644 $M/LICENSE.txt $M/README.txt 2>/dev/null || true
{ cat $README; printf '\nmacOS: drag Aquarium.image onto Squeak.app, or double-click Aquarium.command.\nThe first time, macOS may refuse Aquarium.command, a script from the internet:\nright-click it and choose Open. Squeak.app itself is signed by the Squeak team.\n'; } > $M/README.txt
printf '#!/bin/bash\n# Starts the Aquarium with the Squeak.app beside it.\nDIR="$(cd "$(dirname "$0")" && pwd)"\nexec "$DIR/Squeak.app/Contents/MacOS/Squeak" "$DIR/Aquarium.image"\n' > $M/Aquarium.command
chmod +x $M/Aquarium.command
zip -qry $M.zip $M

ls -la "$OUT"/aquarium-for-squeak-$VERSION-*.{tar.gz,zip}
