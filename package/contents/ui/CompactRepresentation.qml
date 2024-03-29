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
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Kirigami.Icon {
    
    source: xmlModel.count > 0 ? "mail-unread-new-symbolic" : "mail-unread-symbolic"
    
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: (mouse) => {
            if (mouse.button == Qt.MiddleButton) {
                mainItem.action_openInbox()
            } else {
                mainItem.expanded = !mainItem.expanded
            }
        }
    }

    Kirigami.Icon {

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        source: "emblem-important"
        visible: !account.isConfigured
    }
}
