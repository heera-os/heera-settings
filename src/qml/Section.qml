import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import HeeraUI 1.0 as HeeraUI

Item {
    id: control
    default property alias content: layout.data
    property alias spacing: layout.spacing
    Layout.fillWidth: true
    // Layout.topMargin: HeeraUI.Units.largeSpacing
    Layout.bottomMargin: HeeraUI.Units.largeSpacing * 2
    implicitHeight: layout.implicitHeight + HeeraUI.Units.largeSpacing * 4

    Rectangle {
        id: background
        anchors.fill: parent
        color: HeeraUI.Theme.primaryBackgroundColor
        Behavior on color {
            ColorAnimation {
                duration: 125
                easing.type: Easing.InOutCubic
            }
        }
        radius: HeeraUI.Units.largeRadius
    }

    ColumnLayout {
        id: layout
        width: parent.width - HeeraUI.Units.largeSpacing * 4
        anchors.centerIn: parent
    }
}
