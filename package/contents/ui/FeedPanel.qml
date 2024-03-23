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
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmaExtras.Representation {
    
    focus: true
    header: PlasmaExtras.PlasmoidHeading {
        contentItem: Kirigami.Padding {
            padding: Kirigami.Units.smallSpacing
            contentItem: PlasmaExtras.Heading {
                level: 3
                opacity: 0.6
                text: mainItem.subtext
            }
        }
    }
    
    contentItem: PlasmaComponents.ScrollView {
        
        contentItem: ListView {
            id: inboxView
            
            clip: true
            model: xmlModel
            currentIndex: -1
            boundsBehavior: Flickable.StopAtBounds
            highlight: PlasmaExtras.Highlight {
                pressed: inboxView.currentItem && inboxView.currentItem.pressed
            }
            highlightMoveDuration: 0
            highlightResizeDuration: 0
            reuseItems: true
            delegate: MessageDelegate {
                width: inboxView.width
                onContainsMouseChanged: {
                    if (containsMouse) {
                        inboxView.currentIndex = index
                    }
                }
            }
            HoverHandler {
                acceptedDevices: PointerDevice.AllDevices
                onHoveredChanged: if (!hovered) inboxView.currentIndex = -1
            }
        }
    }

    Keys.onUpPressed: (event) => {
        if (inboxView.currentIndex === 0) {
            inboxView.currentIndex = -1
        }
        event.accepted = false
    }
    Keys.forwardTo: [inboxView, inboxView.currentItem]
} 
 
