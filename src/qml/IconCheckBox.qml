import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import HeeraUI 1.0 as HeeraUI

Item {
    id: control

    property var iconSpacing: HeeraUI.Units.smallSpacing * 0.8
    property alias source: icon.source
    property alias text: label.text
    property bool checked: false

    signal clicked

    implicitHeight: mainLayout.implicitHeight
    implicitWidth: mainLayout.implicitWidth

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        Rectangle {
            id: _box
            width: 128
            height: width
            color: "transparent"
            border.width: 3
            border.color: control.checked ? HeeraUI.Theme.highlightColor : "transparent"
            Behavior on border.color {
                ColorAnimation {
                    duration: 125
                    easing.type: Easing.InOutCubic
                }
            }
            radius: HeeraUI.Units.largeRadius + control.iconSpacing
            visible: true

            Image {
                id: icon
                anchors.fill: parent
                anchors.margins: HeeraUI.Units.smallSpacing
                sourceSize: Qt.size(icon.width, icon.height)

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: icon.width
                        height: icon.height

                        Rectangle {
                            anchors.fill: parent
                            radius: HeeraUI.Units.largeRadius
                        }
                    }
                }
            }
        }

        Label {
            id: label
            color: control.checked ? HeeraUI.Theme.highlightColor : HeeraUI.Theme.textColor
            Layout.alignment: Qt.AlignHCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()
    }
}
