import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import HeeraUI 1.0 as HeeraUI
import Heera.NetworkManagement 1.0 as NM

Dialog {
    id: control
    title: model.itemUniqueName

    width: Math.max(detailsLayout.implicitWidth, footer.implicitWidth)

    x: (rootWindow.width - width) / 4
    y: (rootWindow.height - height) / 4
    modal: true
    padding: HeeraUI.Units.largeSpacing * 2

    signal forgetBtnClicked()

    NM.WirelessItemSettings {
        id: settings
    }

    Component.onCompleted: {
        if (model.connectionPath) {
            settings.path = model.connectionPath
            autoJoinSwitch.checked = settings.autoConnect
            autoJoinSwitch.visible = true
            autoJoinLabel.visible = true
        }
    }

    ColumnLayout {
        id: detailsLayout
        // I couldn't find a way of making the GridLayout resize.
        anchors.centerIn: parent
        GridLayout {
            id: gridLayout
            columns: 2
            columnSpacing: HeeraUI.Units.largeSpacing
            rowSpacing: HeeraUI.Units.smallSpacing

            Label {
                id: autoJoinLabel
                text: qsTr("Auto-Join")
                visible: false
                color: HeeraUI.Theme.disabledTextColor
            }

            Switch {
                id: autoJoinSwitch
                rightPadding: 0
                Layout.fillHeight: true
                visible: false
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: settings.autoConnect = checked
            }

            Label {
                text: qsTr("Security")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: securityLabel
                text: model.securityTypeString
                Layout.alignment: Qt.AlignRight
            }

            Label {
                text: qsTr("Signal")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: signalLabel
                text: model.signal
                Layout.alignment: Qt.AlignRight
            }

            Label {
                text: qsTr("IPv4 Address")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: ipv4AddressLabel
                // text: model.ipV4Address
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("IPv6 Address")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: ipV6AddressLabel
                // text: model.ipV6Address
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("MAC Address")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: macAddressLabel
                // text: model.macAddress
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("Gateway")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: routerLabel
                // text: model.gateway
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("DNS")
                color: HeeraUI.Theme.disabledTextColor
            }

            Label {
                id: dnsLabel
                // text: model.nameServer
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    footer: DialogButtonBox {
        padding: HeeraUI.Units.largeSpacing * 2
        Button {
            text: qsTr("Forget this network")
            Layout.alignment: Qt.AlignHCenter
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            onClicked: control.forgetBtnClicked()
        }

        Button {
            text: qsTr("Close")
            Layout.alignment: Qt.AlignHCenter
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            onClicked: control.reject()
        }
    }
}
