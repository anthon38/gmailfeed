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

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kcmutils // KCMLauncher
import org.kde.plasma.private.gmailfeed

SimpleKCM {
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

    RowLayout {

        PlasmaComponents.Label {
            text: i18n("Current account: ")
        }

        PlasmaComponents.ComboBox {
            id: comboBox

            model: accountsModel
            textRole: "name"
            onActivated: cfg_accountId = accountsModel.getId(comboBox.currentIndex)
        }

        Item {
            Layout.fillWidth: true
        }

        PlasmaComponents.Button {

            icon.name: "applications-internet"
            text: i18n("Manage accounts...")
            onClicked: KCMLauncher.openInfoCenter("kcm_kaccounts")
        }
    }
} 
