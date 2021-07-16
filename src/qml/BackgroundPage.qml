import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Heera.Settings 1.0
import HeeraUI 1.0 as HeeraUI

ItemPage {
    headerTitle: qsTr("Wallpaper")

    Background {
        id: background
    }

    GridView {
        anchors.fill: parent
        leftMargin: HeeraUI.Units.smallSpacing

        cellWidth: 320
        cellHeight: 180

        clip: true
        model: background.backgrounds

        currentIndex: -1

        ScrollBar.vertical: ScrollBar {}

        delegate: Item {
            id: item

            required property variant modelData
            property bool isSelected: modelData === background.currentBackgroundPath

            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: HeeraUI.Units.largeSpacing
                anchors.rightMargin: HeeraUI.Units.largeSpacing
                anchors.topMargin: HeeraUI.Units.smallSpacing
                anchors.bottomMargin: HeeraUI.Units.smallSpacing
                color: "transparent"
                radius: HeeraUI.Units.largeRadius + HeeraUI.Units.smallSpacing / 2

                border.color: HeeraUI.Theme.highlightColor
                border.width: image.status == Image.Ready & isSelected ? 3 : 0

                Image {
                    id: image
                    anchors.fill: parent
                    anchors.margins: HeeraUI.Units.smallSpacing
                    source: "file://" + modelData
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    mipmap: true
                    cache: true
                    opacity: 1.0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 125
                            easing.type: Easing.InOutCubic
                        }
                    }

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: image.width
                            height: image.height

                            Rectangle {
                                anchors.fill: parent
                                radius: HeeraUI.Units.largeRadius
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    hoverEnabled: true

                    onClicked: background.setBackground(item.modelData)

                    onEntered: function() {
                        image.opacity = 0.7
                    }
                    onExited: function() {
                        image.opacity = 1.0
                    }
                }
            }
        }
    }
}
