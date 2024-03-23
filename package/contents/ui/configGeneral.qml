/****************************************************************************
 *  Copyright (c) 2014 Anthony Vital <anthony.vital@gmail.com>              *
 *                                                                          *
 *  This file is part of Gmail Feed.                                        *
 *                                                                          *
 *  Gmail Feed is free software: you can redistribute it and/or modify      *
 *  it under the terms of the GNU General Public License as published by    *
 *  the Free Software Foundation, either version 3 of the License, or       *
 *  (at your option) any later version.                                     *
 *                                                                          *
 *  Gmail Feed is distributed in the hope that it will be useful,           *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *  GNU General Public License for more details.                            *
 *                                                                          *
 *  You should have received a copy of the GNU General Public License       *
 *  along with Gmail Feed.  If not, see <http://www.gnu.org/licenses/>.     *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kcmutils

SimpleKCM {
    id: generalPage

    property alias cfg_pollinterval: spinbox.value

    RowLayout {
        PlasmaComponents.Label {
            text: i18n("Polling interval: ")
        }

        PlasmaComponents.SpinBox {
            id: spinbox
            from: 1
            to: 90
            live: true
            textFromValue: (value, locale) => { return i18ncp("Polling interval in minutes", "%1 min", "%1 min", value) }
            valueFromText: (text, locale) => { return Number.fromLocaleString(locale, text.replace(/[^0-9]/g,"")) }
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
