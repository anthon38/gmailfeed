#!/bin/sh

XGETTEXT="xgettext --from-code=UTF-8 -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 \
-ki18ncp:1c,2,3 -ktr2i18n:1 -kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale \
-kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3xgettext -ki18n -ki18nc
-ki18ncp -ki18np"
$XGETTEXT -L JavaScript `find . -name \*.qml` -o po/plasma_applet_gmail-feed.pot --package-name=gmailfeed --package-version=2.0

find . -name "plasma_applet_org.kde.plasma.gmailfeed*.po" -exec msgmerge --update --backup=none --previous {} po/plasma_applet_gmail-feed.pot \;
