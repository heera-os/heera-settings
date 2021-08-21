import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import HeeraUI 1.0 as HeeraUI
import Heera.Settings 1.0 as Settings

ItemPage {
    headerTitle: qsTr("Language")

    Settings.Language {
        id: language
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: HeeraUI.Units.smallSpacing

        ListView {
            id: listView

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: language.languages
            clip: true

            topMargin: HeeraUI.Units.largeSpacing
            bottomMargin: HeeraUI.Units.largeSpacing * 2
            leftMargin: HeeraUI.Units.largeSpacing * 2
            rightMargin: HeeraUI.Units.largeSpacing * 2
            spacing: HeeraUI.Units.largeSpacing

            currentIndex: language.currentLanguage

            ScrollBar.vertical: ScrollBar {}

            delegate: MouseArea {
                property bool isSelected: index === listView.currentIndex

                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: 50
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    language.setCurrentLanguage(index)
                }

                Rectangle {
                    anchors.fill: parent
                    color: isSelected ? HeeraUI.Theme.highlightColor : item.containsMouse ? HeeraUI.Theme.disabledTextColor : "transparent"                    
                    opacity: isSelected ? 1 : 0.1
                    Behavior on color {
                        ColorAnimation {
                            duration: 125
                            easing.type: Easing.InOutCubic
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 125
                            easing.type: Easing.InOutCubic
                        }
                    }
                    radius: HeeraUI.Units.smallRadius
                }

                Label {
                    anchors.fill: parent
                    anchors.leftMargin: HeeraUI.Units.largeSpacing * 2
                    anchors.rightMargin: HeeraUI.Units.largeSpacing * 2
                    color: isSelected ? HeeraUI.Theme.highlightedTextColor : HeeraUI.Theme.textColor
                    Behavior on color {
                        ColorAnimation {
                            duration: 125
                            easing.type: Easing.InOutCubic
                        }
                    }
                    text: modelData
                }
            }
        }
    }
}
