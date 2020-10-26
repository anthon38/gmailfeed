/****************************************************************************
 *  Copyright (c) 2015 Anthony Vital <anthony.vital@gmail.com>              *
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

import QtQuick 2.0
import QtQuick.Layouts 1.0 as QtLayouts
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    
    QtLayouts.ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        
        PlasmaComponents.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n("Please configure an account")
        }

//         PlasmaComponents.Button {
//             anchors.horizontalCenter: parent.horizontalCenter
//             iconSource: "configure"
//             text: i18n("Configure...")
// //             onClicked: 
//         }
    }
} 
 
