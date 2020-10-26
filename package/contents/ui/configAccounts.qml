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
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons
import org.kde.plasma.private.gmailfeed 0.1

Item {
    id: accountsPage

    property int cfg_accountId

    onCfg_accountIdChanged: comboBox.currentIndex = accountsModel.indexOf(cfg_accountId)
    
    AccountsModel {
        id: accountsModel
        
        onRowsInserted: {
            comboBox.currentIndex = first
            cfg_accountId = accountsModel.getId(first)
        }
        onRowsRemoved: {
            comboBox.currentIndex = -1
            cfg_accountId = 0
        }
    }

    QtLayouts.RowLayout {
        id: currentAccountGroup

        PlasmaComponents.Label {
            text: i18n("Current account: ")
        }

        PlasmaComponents.ComboBox {
            id: comboBox

            model: accountsModel
            textRole: "name"
            onActivated: cfg_accountId = accountsModel.getId(index)
        }
    }

    PlasmaComponents.Button {
        anchors.right: parent.right
        anchors.top: currentAccountGroup.top
        anchors.bottom: currentAccountGroup.bottom

        iconSource: "applications-internet"
        text: i18n("Manage accounts...")
        onClicked: KQuickControlsAddons.KCMShell.open("kcm_kaccounts")
    }
} 
