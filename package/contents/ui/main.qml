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
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.notification
import org.kde.plasma.private.gmailfeed

PlasmoidItem {
    id: mainItem
    
    property string subtext: ""
    
    Plasmoid.icon: "gmailfeed"
    Plasmoid.busy: xmlModel.status === GxmlModel.Loading
    toolTipSubText: subtext
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}
    switchWidth: Kirigami.Units.gridUnit * 8
    switchHeight: Kirigami.Units.gridUnit * 8
    
    Account {
        id: account
        
        accountId: plasmoid.configuration.accountId
        onAccountIdChanged: {
            if (accountId == 0) {
                Plasmoid.status = PlasmaCore.Types.ActiveStatus
            } else {
                Plasmoid.status = PlasmaCore.Types.PassiveStatus
                action_checkMail()
            }
        }
    }

    NetworkStatus {
        id: networkStatus
        
        onIsOnlineChanged: checkMailOneShotTimer.start()
    }
    
    Timer {
        id: checkMailOneShotTimer
        
        interval: 1000
        onTriggered: action_checkMail()
    }

    Notification {
        id: newMailNotification

        componentName: "gmailfeed"
        eventId: "new-mail-arrived"
        iconName: "gmailfeed"
        title: Plasmoid.title
    }

    GxmlModel {
        id: xmlModel

        xml: account.feed

        onNewMessage: (author, title) => {
            newMailNotification.text = "<b>"+author+": "+"</b>"+title
            newMailNotification.sendEvent()
        }

        onNewMessages: (count) => {
            newMailNotification.text = i18np("1 new message", "%1 new messages", count)
            newMailNotification.sendEvent()
        }
        
        onStatusChanged: {
            switch (status) {
                case GxmlModel.Null:
                    mainItem.subtext = "Null model"
                    break
                case GxmlModel.Ready:
                    Plasmoid.status = (xmlModel.count > 0) ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus
                    if (xmlModel.fullcount > 0) {
                        mainItem.subtext = i18np("1 unread message", "%1 unread messages", xmlModel.fullcount)
                    } else {
                        mainItem.subtext = i18n("No unread messages")
                    }
                    break
                case GxmlModel.Loading:
                    mainItem.subtext = i18n("Checking for new messages...")
                    break
                case GxmlModel.Error:
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
        onTriggered: networkStatus.isOnline ? account.updateFeed() : mainItem.subtext = i18n("Offline")
    }
    
    function action_checkMail() {
        polltimer.restart()
    }
    
    function action_openInbox() {
        Qt.openUrlExternally("https://mail.google.com")
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Open inbox")
            icon.name: "gmailfeed"
            visible: true
            onTriggered: action_openInbox()
        },
        PlasmaCore.Action {
            text: i18n("Check mail")
            icon.name: "mail-receive"
            visible: true
            onTriggered: action_checkMail()
        }
    ]

    Component.onCompleted: { 
        Plasmoid.status = PlasmaCore.Types.ActiveStatus
    }
    
}
