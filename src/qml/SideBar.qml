import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import HeeraUI 1.0 as HeeraUI

Item {
    implicitWidth: 260

    property int itemRadiusV: 8

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    Rectangle {
        anchors.fill: parent
        color: HeeraUI.Theme.tertiaryBackgroundColor

        Behavior on color {
            ColorAnimation {
                duration: 125
                easing.type: Easing.InOutCubic
            }
        }
    }

    ListModel {
        id: listModel

        ListElement {
            title: qsTr("Accounts")
            name: "accounts"
            page: "qrc:/qml/AccountsPage.qml"
            iconSource: "image://icontheme/avatar-default-symbolic"
        }

        ListElement {
            title: qsTr("Display")
            name: "display"
            page: "qrc:/qml/DisplayPage.qml"
            iconSource: "image://icontheme/display"
        }

        ListElement {
            title: qsTr("Network")
            name: "network"
            page: "qrc:/qml/NetworkPage.qml"
            iconSource: "image://icontheme/network-wired-symbolic"
        }

        ListElement {
            title: qsTr("Appearance")
            name: "appearance"
            page: "qrc:/qml/AppearancePage.qml"
            iconSource: "image://icontheme/applications-graphics-symbolic"
        }

        ListElement {
            title: qsTr("Wallpaper")
            name: "wallpaper"
            page: "qrc:/qml/BackgroundPage.qml"
            iconSource: "image://icontheme/cs-backgrounds-symbolic"
        }

        ListElement {
            title: qsTr("Dock")
            name: "dock"
            page: "qrc:/qml/DockPage.qml"
            iconSource: "image://icontheme/user-desktop-symbolic"
        }

        ListElement {
            title: qsTr("Language")
            name: "language"
            page: "qrc:/qml/LanguagePage.qml"
            iconSource: "image://icontheme/globe-symbolic"
        }

        ListElement {
            title: qsTr("Battery")
            name: "battery"
            page: "qrc:/qml/BatteryPage.qml"
            iconSource: "image://icontheme/battery-full-symbolic"
        }

        ListElement {
            title: qsTr("About")
            name: "about"
            page: "qrc:/qml/AboutPage.qml"
            iconSource: "image://icontheme/dialog-information-symbolic"
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: HeeraUI.Units.largeSpacing
            topMargin: 0
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: listModel

            spacing: HeeraUI.Units.smallSpacing * 1.5

            ScrollBar.vertical: ScrollBar {}

            delegate: Item {
                id: item
                implicitWidth: listView.width
                implicitHeight: 48

                property bool isCurrent: listView.currentIndex === index

                Rectangle {
                    anchors.fill: parent

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: listView.currentIndex = index
                    }

                    radius: HeeraUI.Units.largeRadius
                    color: isCurrent ?
                        HeeraUI.Theme.highlightColor
                        : mouseArea.containsMouse ?
                            Qt.rgba(HeeraUI.Theme.textColor.r,
                                    HeeraUI.Theme.textColor.g,
                                    HeeraUI.Theme.textColor.b,
                                    0.1)
                            : "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: 125
                            easing.type: Easing.InOutCubic
                        }
                    }
                    smooth: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: HeeraUI.Units.largeSpacing * 2
                    spacing: HeeraUI.Units.largeSpacing

                    Image {
                        id: icon
                        width: 16
                        height: width
                        source: model.iconSource
                        sourceSize: Qt.size(width, height)

                        /* ColorOverlay {
                            id: colorOverlay
                            anchors.fill: icon
                            source: icon
                            color: isCurrent ? HeeraUI.Theme.highlightedTextColor : HeeraUI.Theme.textColor
                            Behavior on color {
                                ColorAnimation {
                                    duration: 125
                                    easing.type: Easing.InOutCubic
                                }
                            }
                            //opacity: 1
                            //visible: HeeraUI.Theme.darkMode || isCurrent
                        } */
                    }

                    Label {
                        id: itemTitle
                        text: model.title
                        color: isCurrent ? HeeraUI.Theme.highlightedTextColor : HeeraUI.Theme.textColor
                        Behavior on color {
                            ColorAnimation {
                                duration: 125
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
