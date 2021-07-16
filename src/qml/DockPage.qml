import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Heera.Settings 1.0
import HeeraUI 1.0 as HeeraUI

ItemPage {
    headerTitle: qsTr("Dock")

    Appearance {
        id: appearance
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            // Dock
            Section {
                Label {
                    text: qsTr("Position on screen")
                    color: HeeraUI.Theme.disabledTextColor
                    Layout.bottomMargin: HeeraUI.Units.largeSpacing
                }

                RowLayout {
                    spacing: HeeraUI.Units.largeSpacing * 2

                    IconCheckBox {
                        source: "qrc:/images/dock_left.svg"
                        text: qsTr("Left")
                        checked: appearance.dockDirection === 0
                        onClicked: appearance.setDockDirection(0)
                    }

                    IconCheckBox {
                        source: "qrc:/images/dock_bottom.svg"
                        text: qsTr("Bottom")
                        checked: appearance.dockDirection === 1
                        onClicked: appearance.setDockDirection(1)
                    }
                }
            }

            Section {
                Label {
                    text: qsTr("Size")
                    color: HeeraUI.Theme.disabledTextColor
                    bottomPadding: HeeraUI.Units.smallSpacing
                }

                TabBar {
                    id: dockSizeTabbar
                    Layout.fillWidth: true

                    TabButton {
                        text: qsTr("Small")
                    }

                    TabButton {
                        text: qsTr("Medium")
                    }

                    TabButton {
                        text: qsTr("Large")
                    }

                    TabButton {
                        text: qsTr("Huge")
                    }

                    currentIndex: {
                        var index = 0

                        if (appearance.dockIconSize <= 48)
                            index = 0
                        else if (appearance.dockIconSize <= 64)
                            index = 1
                        else if (appearance.dockIconSize <= 88)
                            index = 2
                        else if (appearance.dockIconSize <= 128)
                            index = 3

                        return index
                    }

                    onCurrentIndexChanged: {
                        var iconSize = 0

                        switch (currentIndex) {
                        case 0:
                            iconSize = 48
                            break;
                        case 1:
                            iconSize = 64
                            break;
                        case 2:
                            iconSize = 88
                            break;
                        case 3:
                            iconSize = 128
                            break;
                        }

                        appearance.setDockIconSize(iconSize)
                    }
                }
            }
            
            Section {
                RowLayout {
                    Label {
                        text: qsTr("Dock Transparency")
                        color: HeeraUI.Theme.disabledTextColor
                        bottomPadding: HeeraUI.Units.smallSpacing
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
        
                    Switch {
                        id: dockTransparencySwitch
                        Layout.fillHeight: true
                        checked: appearance.dockTransparency
                        leftPadding: 0
                        rightPadding: 0
                        onCheckedChanged: appearance.dockTransparency = checked
                    }
                }
            }
        }
    }
}
