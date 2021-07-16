import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.15
import HeeraUI 1.0 as HeeraUI

HeeraUI.Window {
    id: rootWindow
    title: qsTr("Settings")
    visible: true
    width: 950
    height: 650
    backgroundColor: HeeraUI.Theme.secondaryBackgroundColor

    minimumWidth: 900
    minimumHeight: 600
    headerBarHeight: 50

    headerBar: Item {
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            implicitWidth: sideBar.width
            color: HeeraUI.Theme.tertiaryBackgroundColor

            Behavior on color {
                ColorAnimation {
                    duration: 125
                    easing.type: Easing.InOutCubic
                }
            }
        }

        RowLayout {
            anchors.fill: parent

            Label {
                text: rootWindow.title
                leftPadding: HeeraUI.Units.largeSpacing * 2 + HeeraUI.Units.smallSpacing
                topPadding: HeeraUI.Units.smallSpacing
                font.pointSize: parent.height / 3
                Layout.preferredWidth: sideBar.width
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: stackView.currentItem.headerTitle
                font.pointSize: parent.height / 3
                leftPadding: HeeraUI.Units.largeSpacing * 2
                topPadding: HeeraUI.Units.smallSpacing
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }

    RowLayout {
        anchors.fill: parent

        SideBar {
            id: sideBar
            Layout.fillHeight: true

            onCurrentIndexChanged: {
                switchPageFromIndex(currentIndex)
            }
        }

        StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: Qt.resolvedUrl(sideBar.model.get(0).page)
            clip: true

            pushEnter: Transition {
                OpacityAnimator {
                    from: 0
                    to: 1
                    duration: 600
                    easing.type: Easing.InOutCubic
                }
            }

            pushExit: Transition {
                OpacityAnimator {
                    from: 1
                    to: 0
                    duration: 300
                    easing.type: Easing.InOutCubic
                }
            }
        }
    }

    function switchPageFromIndex(index) {
        stackView.push(Qt.resolvedUrl(sideBar.model.get(index).page))
    }

    function switchPageFromName(pageName) {
        for (var i = 0; i < sideBar.model.count; ++i) {
            if (pageName === sideBar.model.get(i).name) {
                switchPageFromIndex(i)
                sideBar.view.currentIndex = i
            }
        }

        // If the window is minimized, it needs to be displayed agin.
        rootWindow.show()
        rootWindow.raise()
    }
}
