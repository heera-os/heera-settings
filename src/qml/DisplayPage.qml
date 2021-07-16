import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Heera.Settings 1.0
import Heera.Screen 1.0 as CS
import HeeraUI 1.0 as HeeraUI

ItemPage {
    headerTitle: qsTr("Display")

    Appearance {
        id: appearance
    }

    Brightness {
        id: brightness
    }

    Timer {
        id: brightnessTimer
        interval: 100
        onTriggered: {
            brightness.setValue(brightnessSlider.value)
        }
    }

    CS.Screen {
        id: screen
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            Section {
                visible: brightness.enabled

                Label {
                    text: qsTr("Brightness")
                    color: HeeraUI.Theme.disabledTextColor
                    bottomPadding: HeeraUI.Units.largeSpacing
                }

                RowLayout {
                    spacing: HeeraUI.Units.largeSpacing

                    Image {
                        width: brightnessSlider.height
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        source: "qrc:/images/" + (HeeraUI.Theme.darkMode ? "dark" : "light") + "/display-brightness-low-symbolic.svg"
                    }

                    Slider {
                        id: brightnessSlider
                        Layout.fillWidth: true
                        value: brightness.value
                        from: 0
                        to: 100
                        stepSize: 1
                        onMoved: brightnessTimer.start()
                    }

                    Image {
                        width: brightnessSlider.height
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        source: "qrc:/images/" + (HeeraUI.Theme.darkMode ? "dark" : "light") + "/display-brightness-symbolic.svg"
                    }
                }
            }

            Section {
                visible: _screenView.count > 0

                Label {
                    text: qsTr("Screen")
                    color: HeeraUI.Theme.disabledTextColor
                    bottomPadding: HeeraUI.Units.smallSpacing
                }

                ListView {
                    id: _screenView
                    Layout.fillWidth: true
                    model: screen.outputModel
                    orientation: ListView.Horizontal
                    interactive: false
                    clip: true

                    Layout.preferredHeight: currentItem ? currentItem.layout.implicitHeight : 0

                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            duration: 200
                        }
                    }

                    delegate: Item {
                        id: screenItem
                        height: ListView.view.height
                        width: ListView.view.width

                        property var element: model
                        property var layout: _mainLayout

                        ColumnLayout {
                            id: _mainLayout
                            anchors.fill: parent

                            // Label {
                            //     text: element.display
                            // }

                            GridLayout {
                                columns: 2
                                columnSpacing: HeeraUI.Units.largeSpacing * 1.5
                                rowSpacing: HeeraUI.Units.largeSpacing

                                Label {
                                    text: qsTr("Resolution")
                                }

                                ComboBox {
                                    Layout.fillWidth: true
                                    model: element.resolutions
                                    leftPadding: HeeraUI.Units.largeSpacing
                                    rightPadding: HeeraUI.Units.largeSpacing
                                    topInset: 0
                                    bottomInset: 0
                                    currentIndex: element.resolutionIndex !== undefined ?
                                                        element.resolutionIndex : -1
                                    onActivated: {
                                        element.resolutionIndex = currentIndex
                                        screen.save()
                                    }
                                }

                                Label {
                                    text: qsTr("Refresh rate")
                                }

                                ComboBox {
                                    id: refreshRate
                                    Layout.fillWidth: true
                                    model: element.refreshRates
                                    leftPadding: HeeraUI.Units.largeSpacing
                                    rightPadding: HeeraUI.Units.largeSpacing
                                    topInset: 0
                                    bottomInset: 0
                                    currentIndex: element.refreshRateIndex ? element.refreshRateIndex : 0
                                    onActivated: {
                                        element.refreshRateIndex = currentIndex
                                        screen.save()
                                    }
                                }

                                Label {
                                    text: qsTr("Rotation")
                                }

                                Item {
                                    id: rotationItem
                                    Layout.fillWidth: true
                                    height: rotationLayout.implicitHeight

                                    RowLayout {
                                        id: rotationLayout
                                        anchors.fill: parent

                                        RotationButton {
                                            value: 0
                                        }

                                        RotationButton {
                                            value: 90
                                        }

                                        RotationButton {
                                            value: 180
                                        }

                                        RotationButton {
                                            value: 270
                                        }
                                    }
                                }

                                Label {
                                    text: qsTr("Enabled")
                                    visible: enabledBox.visible
                                }

                                CheckBox {
                                    id: enabledBox
                                    checked: element.enabled
                                    visible: _screenView.count > 1
                                    onClicked: {
                                        element.enabled = checked
                                        screen.save()
                                    }
                                }
                            }
                        }
                    }
                }

                PageIndicator {
                    id: screenPageIndicator
                    Layout.alignment: Qt.AlignHCenter
                    count: _screenView.count
                    currentIndex: _screenView.currentIndex
                    onCurrentIndexChanged: _screenView.currentIndex = currentIndex
                    interactive: true
                    visible: count > 1
                }
            }

            Section {
                Label {
                    text: qsTr("Scale")
                    color: HeeraUI.Theme.disabledTextColor
                    bottomPadding: HeeraUI.Units.smallSpacing
                }

                TabBar {
                    id: dockSizeTabbar
                    Layout.fillWidth: true

                    TabButton {
                        text: "100%"
                    }

                    TabButton {
                        text: "125%"
                    }

                    TabButton {
                        text: "150%"
                    }

                    TabButton {
                        text: "175%"
                    }

                    TabButton {
                        text: "200%"
                    }

                    currentIndex: {
                        var index = 0

                        if (appearance.devicePixelRatio <= 1.0)
                            index = 0
                        else if (appearance.devicePixelRatio <= 1.25)
                            index = 1
                        else if (appearance.devicePixelRatio <= 1.50)
                            index = 2
                        else if (appearance.devicePixelRatio <= 1.75)
                            index = 3
                        else if (appearance.devicePixelRatio <= 2.0)
                            index = 4

                        return index
                    }

                    onCurrentIndexChanged: {
                        var value = 1.0

                        switch (currentIndex) {
                        case 0:
                            value = 1.0
                            break;
                        case 1:
                            value = 1.25
                            break;
                        case 2:
                            value = 1.50
                            break;
                        case 3:
                            value = 1.75
                            break;
                        case 4:
                            value = 2.0
                            break;
                        }

                        appearance.setDevicePixelRatio(value)
                    }
                }
            }
        }
    }
}
