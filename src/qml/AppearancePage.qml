import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Heera.Settings 1.0
import HeeraUI 1.0 as HeeraUI

ItemPage {
    headerTitle: qsTr("Appearance")

    FontsModel {
        id: fontsModel
    }

    Appearance {
        id: appearance
    }

    Connections {
        target: fontsModel

        function onLoadFinished() {
            for (var i in fontsModel.generalFonts) {
                if (fontsModel.systemGeneralFont === fontsModel.generalFonts[i]) {
                    generalFontComboBox.currentIndex = i
                    break;
                }
            }

            for (i in fontsModel.fixedFonts) {
                if (fontsModel.systemFixedFont === fontsModel.fixedFonts[i]) {
                    fixedFontComboBox.currentIndex = i
                    break;
                }
            }

            console.log("fonts load finished")
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            Section {
                Label {
                    text: qsTr("Theme")
                    color: HeeraUI.Theme.disabledTextColor
                    Layout.bottomMargin: HeeraUI.Units.largeSpacing
                }

                // Light Mode and Dark Mode
                RowLayout {
                    spacing: HeeraUI.Units.largeSpacing

                    IconCheckBox {
                        source: "qrc:/images/light_mode.svg"
                        text: qsTr("Light")
                        checked: !HeeraUI.Theme.darkMode
                        onClicked: appearance.switchDarkMode(false)
                    }

                    IconCheckBox {
                        source: "qrc:/images/dark_mode.svg"
                        text: qsTr("Dark")
                        checked: HeeraUI.Theme.darkMode
                        onClicked: appearance.switchDarkMode(true)
                    }
                }

                Item {
                    height: HeeraUI.Units.largeSpacing
                }

                RowLayout {
                    spacing: HeeraUI.Units.largeSpacing

                    Label {
                        id: dimsTipsLabel
                        text: qsTr("Dim the wallpaper in dark theme")
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: appearance.dimsWallpaper
                        height: dimsTipsLabel.height
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                        onCheckedChanged: appearance.setDimsWallpaper(checked)
                    }
                }
            }

            Section {
                Label {
                    text: qsTr("Accent color")
                    color: HeeraUI.Theme.disabledTextColor
                    Layout.bottomMargin: HeeraUI.Units.largeSpacing
                }

                GridView {
                    height: 25 + HeeraUI.Units.largeSpacing * 2
                    Layout.fillWidth: true
                    cellWidth: height
                    cellHeight: height
                    interactive: false
                    model: ListModel {}

                    Component.onCompleted: {
                        model.append({"accentColor": String(HeeraUI.Theme.blueColor)})
                        model.append({"accentColor": String(HeeraUI.Theme.redColor)})
                        model.append({"accentColor": String(HeeraUI.Theme.greenColor)})
                        model.append({"accentColor": String(HeeraUI.Theme.purpleColor)})
                        model.append({"accentColor": String(HeeraUI.Theme.pinkColor)})
                        model.append({"accentColor": String(HeeraUI.Theme.orangeColor)})
                    }

                    delegate: Rectangle {
                        property bool isSelected: Qt.colorEqual(HeeraUI.Theme.highlightColor, accentColor)

                        width: 25 + HeeraUI.Units.largeSpacing * 2
                        height: width
                        color: "transparent"
                        radius: width / 2
                        border.color: Qt.rgba(
                            _rect2.color.r,
                            _rect2.color.g,
                            _rect2.color.b,
                            HeeraUI.Theme.darkMode ? 0.5 : 0.7
                        )

                        border.width: isSelected ? 2.5 : 0
                        Behavior on border.width {
                            NumberAnimation {
                                duration: 125
                                easing.type: Easing.InOutCubic
                            }
                        }
                        id: _rect

                        Rectangle {
                            id: _rect2
                            color: accentColor
                            width: 20
                            height: width
                            anchors.centerIn: parent
                            radius: width / 2

                            MouseArea {
                                anchors.fill: parent
                                onClicked: appearance.setAccentColor(index)
                            }
                        }
                    }
                }
            }

            // Font
            Section {
                Label {
                    text: qsTr("Font")
                    color: HeeraUI.Theme.disabledTextColor
                    Layout.bottomMargin: HeeraUI.Units.largeSpacing * 0.8
                }

                GridLayout {
                    rows: 3
                    columns: 2

                    columnSpacing: HeeraUI.Units.largeSpacing * 2

                    Label {
                        text: qsTr("General Font")
                        bottomPadding: HeeraUI.Units.smallSpacing
                    }

                    ComboBox {
                        id: generalFontComboBox
                        model: fontsModel.generalFonts
                        enabled: true
                        Layout.fillWidth: true
                        onActivated: appearance.setGenericFontFamily(currentText)
                    }

                    Label {
                        text: qsTr("Fixed Font")
                        bottomPadding: HeeraUI.Units.smallSpacing
                    }

                    ComboBox {
                        id: fixedFontComboBox
                        model: fontsModel.fixedFonts
                        enabled: true
                        Layout.fillWidth: true
                        onActivated: appearance.setFixedFontFamily(currentText)
                    }

                    Label {
                        text: qsTr("Font Size")
                        bottomPadding: HeeraUI.Units.smallSpacing
                    }

                    TabBar {
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

                            if (appearance.fontPointSize <= 11)
                                index = 0
                            else if (appearance.fontPointSize <= 13)
                                index = 1
                            else if (appearance.fontPointSize <= 15)
                                index = 2
                            else if (appearance.fontPointSize <= 18)
                                index = 3

                            return index
                        }

                        onCurrentIndexChanged: {
                            var fontSize = 0

                            switch (currentIndex) {
                            case 0:
                                fontSize = 11
                                break;
                            case 1:
                                fontSize = 13
                                break;
                            case 2:
                                fontSize = 15
                                break;
                            case 3:
                                fontSize = 18
                                break;
                            }

                            appearance.setFontPointSize(fontSize)
                        }
                    }
                }
            }
        }
    }
}
