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
import QtQuick.XmlListModel 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.gmailfeed 0.1

Item {
    id: mainItem
    
    property string subtext: ""
    property string title: Plasmoid.title
    
    Plasmoid.toolTipSubText: subtext
    Plasmoid.icon: xmlModel.count > 0 ? "mail-unread-new" : "mail-unread"
    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}
    Plasmoid.switchWidth: units.gridUnit * 8
    Plasmoid.switchHeight: units.gridUnit * 8
    
    NetworkStatus {
        id: networkStatus
        
        onIsOnlineChanged: checkMailOneShotTimer.start()
    }
    
    Timer {
        id: checkMailOneShotTimer
        
        interval: 500
        onTriggered: action_checkMail()
    }
    
    Notification {
        id: notification
    }
    
    XmlListModel {
        id: xmlModel
        
        property int newMailCount: 0
        property int newMailId: -1

        source: "https://gmail.google.com/gmail/feed/atom"
        namespaceDeclarations: "declare default element namespace 'http://purl.org/atom/ns#';"
        query: "/feed/entry"

        XmlRole { name: "author"; query: "author/name/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/@href/string()" }
        XmlRole { name: "id"; query: "id/string()"; isKey: true }
        
        onRowsInserted: {
            newMailCount += last-first+1
            newMailId = first
        }
        
        onStatusChanged: {
            switch (status) {
                case XmlListModel.Null:
                    mainItem.subtext = "Null model"
                    break
                case XmlListModel.Ready:
                    plasmoid.status = (xmlModel.count > 0) ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus
                    if (xmlModel.count > 0) {
                        mainItem.subtext = i18np("1 unread message", "%1 unread messages", xmlModel.count)
                    } else {
                        mainItem.subtext = i18n("No unread messages")
                    }
                    if (newMailCount > 0) {
                        var message
                        if (newMailCount == 1) 
                            message = "<b>"+get(newMailId).author+": "+"</b>"+get(newMailId).title
                        else 
                            message =  i18np("1 new message", "%1 new messages", newMailCount)
                        notification.send("new-mail-arrived", mainItem.title, message, "gmailfeed", "gmailfeed")
                        newMailCount = 0
                    }
                    break
                case XmlListModel.Loading:
                    mainItem.subtext = i18n("Checking for new messages...")
                    break
                case XmlListModel.Error:
                    mainItem.subtext = errorString()
                    break
                default:
                    console.log(status)
                    break
            }
        }
    }
        
    Timer {
        id: polltimer
        
        repeat: true
        triggeredOnStart: true
        interval: plasmoid.configuration.pollinterval * 60000
        onTriggered: networkStatus.isOnline ? xmlModel.reload() : mainItem.subtext = i18n("Offline")
    }
    
    function action_checkMail() {
        polltimer.restart()
    }
    
    function action_openInbox() {
        Qt.openUrlExternally("https://mail.google.com")
    }
    
    Component.onCompleted: { 
        plasmoid.status = PlasmaCore.Types.PassiveStatus
        plasmoid.setAction("openInbox", i18n("Open inbox"), "folder-mail")
        plasmoid.setAction("checkMail", i18n("Check mail"), "mail-receive")
        plasmoid.setActionSeparator("separator0")
        polltimer.start()
    }
    
}
