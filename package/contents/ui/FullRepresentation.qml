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

import QtQuick 2.0
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    
    focus: true
    
    PlasmaExtras.Heading {
        id: heading
        
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: inboxIcon.left
        level: 3
        opacity: 0.6
        text: mainItem.subtext
    }
    
    PlasmaComponents.ToolButton {
        id: inboxIcon
        
        anchors.right: parent.right
        anchors.top: parent.top
        height: units.iconSizes.medium
        iconSource: "folder-mail"
        tooltip: i18n("Open inbox")
        onClicked: mainItem.action_openInbox()
    }
    
    PlasmaExtras.ScrollArea {
        id: scrollView;

        anchors.top: heading.height > inboxIcon.height ? heading.bottom : inboxIcon.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        
        ListView {
            id: inboxView;
            anchors.fill: parent;
            clip: true
            model: xmlModel;
            currentIndex: -1;
            boundsBehavior: Flickable.StopAtBounds;
            focus: true
            highlight: PlasmaComponents.Highlight {}
            delegate: MessageDelegate {
                anchors.left: parent.left
                anchors.right: parent.right
                authorName: author
                message: title
                onContainsMouseChanged: inboxView.currentIndex = containsMouse ? index : -1
            }
        }
    }
    
    Keys.onPressed: {
        switch(event.key) {
            case Qt.Key_Up: {
                if (inboxView.currentIndex > 0) --inboxView.currentIndex;
                event.accepted = true;
                break;
            }
            case Qt.Key_Down: {
                if (inboxView.currentIndex < inboxView.count-1) ++inboxView.currentIndex;
                event.accepted = true;
                break;
            }
            
            case Qt.Key_Enter:
            case Qt.Key_Return: {
                if (inboxView.currentIndex != -1) inboxView.currentItem.activate();
                event.accepted = true;
                break;
            }
            default: 
                break;
        }
    }
} 
