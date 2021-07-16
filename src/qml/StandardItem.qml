import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import HeeraUI 1.0 as HeeraUI

Item {
    id: control

    height: mainLayout.implicitHeight + HeeraUI.Units.smallSpacing

    property alias key: keyLabel.text
    property alias value: valueLabel.text

    Layout.fillWidth: true

    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        radius: HeeraUI.Units.smallRadius
    }

    RowLayout {
        id: mainLayout
        anchors.fill: parent

        Label {
            id: keyLabel
            color: HeeraUI.Theme.textColor
        }

        Item {
            Layout.fillWidth: true
        }

        Label {
            id: valueLabel
            color: HeeraUI.Theme.disabledTextColor
        }
    }
}
