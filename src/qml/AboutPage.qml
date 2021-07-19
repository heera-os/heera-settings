import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import HeeraUI 1.0 as HeeraUI
import Heera.Settings 1.0

ItemPage {
    headerTitle: qsTr("About")

    About {
        id: about
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            Image {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                width: 128
                height: width
                sourceSize: Qt.size(width, height)
                source: "qrc:/images/logo.svg"
            }

            Label {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                text: "Heera Desktop 0.1"
                font.pointSize: 24
                font.bold: true
                bottomPadding: HeeraUI.Units.largeSpacing * 2
                leftPadding: HeeraUI.Units.largeSpacing * 2
                rightPadding: HeeraUI.Units.largeSpacing * 2
            }

            Section {
                Label {
                    text: qsTr("System Information")
                    color: HeeraUI.Theme.disabledTextColor
                    bottomPadding: HeeraUI.Units.smallSpacing
                }

                StandardItem {
                    key: qsTr("Operating System")
                    value: about.osName
                }

                StandardItem {
                    key: qsTr("Kernel Version")
                    value: about.kernelVersion
                }

                StandardItem {
                    key: qsTr("CPU")
                    value: about.cpuInfo
                }

                StandardItem {
                    key: qsTr("RAM Size")
                    value: about.memorySize
                }

                StandardItem {
                    key: qsTr("Username")
                    value: about.userName
                }

                StandardItem {
                    key: qsTr("Hostname")
                    value: about.hostname
                }
            }

                
            
            Section {
                Label {
                    text: qsTr("HeeraOS Team")
                    color: HeeraUI.Theme.disabledTextColor
                    bottomPadding: HeeraUI.Units.smallSpacing
                }

                StandardItem {
                    key: "Aditya Gupta"
                    value: "twitter@AdityaGupta150"
                }

                StandardItem {
                    key: "Rajan Pandey"
                    value: "pandey11rajan@gmail.com"
                }
                
                StandardItem {
                    key: "Khumnath"
                    value: "twitter@khumnath"
                }

            }
        }
    }
}
