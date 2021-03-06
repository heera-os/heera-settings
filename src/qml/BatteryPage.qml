import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import HeeraUI 1.0 as HeeraUI
import Heera.Settings 1.0

ItemPage {
    headerTitle: qsTr("Battery")

    Battery {
        id: battery

        Component.onCompleted: {
            battery.refresh()
            batteryBackground.value = battery.chargePercent
        }
    }

    Connections {
        target: battery

        function onChargePercentChanged(value) {
            batteryBackground.value = battery.chargePercent
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight
        visible: battery.available

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: HeeraUI.Units.largeSpacing

            // Battery Info
            BatteryItem {
                id: batteryBackground
                Layout.fillWidth: true
                Layout.bottomMargin: HeeraUI.Units.largeSpacing
                enableAnimation: !battery.onBattery
                height: 55

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: batteryBackground.radius

                    Item {
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        Label {
                            id: percentLabel
                            text: battery.chargePercent
                            color: "white"
                            font.pointSize: 25
                        }

                        Label {
                            text: "%"
                            color: "white"
                            font.pointSize: 12
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        Image {
                            id: sensorsVoltage
                            width: 22
                            height: width
                            sourceSize: Qt.size(width, height)
                            source: "qrc:/images/sensors-voltage-symbolic.svg"
                            visible: !battery.onBattery
                        }
                        Label {
                            text: battery.statusString
                            color: "white"
                        }

                    }


                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            Section {
                Label {
                    text: qsTr("History")
                    color: HeeraUI.Theme.disabledTextColor
                }

                Item {
                    height: HeeraUI.Units.smallSpacing
                }

                Canvas {
                    id: canvas
                    Layout.fillWidth: true
                    height: 200

                    // Refer to the code of ubuntu touch.
                    onPaint: {
                        var ctx = canvas.getContext('2d');
                        ctx.save();

                        ctx.clearRect(0, 0, canvas.width, canvas.height)

                        var axisWidth = 1
                        var axisHeight = 1

                        /* Space to write the legend */
                        var bottomMargin = 50
                        var rightMargin = 1
                        var lineHeight = 6

                        drawAxes(ctx, axisWidth, axisHeight, bottomMargin, rightMargin, lineHeight)

                        /* Display the charge history */
                        ctx.beginPath();

                        ctx.lineWidth = 2

                        /* Needed to avoid rendering glitches with point with the same x value
                        (#1461624/QTBUG-34339) */
                        ctx.lineJoin = "round"

                        ctx.translate(0, height)
                        // Invert the y axis so we draw from the bottom left
                        ctx.scale(1, -1)
                        // Move the origin to just above the axes
                        ctx.translate(axisWidth, axisHeight + bottomMargin - ctx.lineWidth)
                        // Scale to avoid the axes so we can draw as if they aren't
                        // there
                        ctx.scale(1 - ((axisWidth + rightMargin) / width),
                                1 - (axisHeight + bottomMargin) / height)

                        // var gradient = ctx.createLinearGradient(0, 0, 0, height);
                        // gradient.addColorStop(1, "green");
                        // gradient.addColorStop(0.5, "yellow");
                        // gradient.addColorStop(0, "red");
                        // ctx.strokeStyle = gradient
                        ctx.strokeStyle = HeeraUI.Theme.highlightColor

                        /* Get infos from battery0, on a day (60*24*24=86400 seconds), with 150 points on the graph.
                        * To ensure we get a valid starting point, we query the values up to two days ago */
                        var chargeDatas = battery.getHistory(86400 * 2, 150)

                        /* time is the offset in seconds compared to the current time (negative value)
                        we display the charge on a day, which is 86400 seconds, the value is the % */
                        ctx.moveTo(width,
                                (chargeDatas[0].value / 100) * height)
                        for (var i = 1; i < chargeDatas.length; i++) {
                            /* when device is power cycled, value will drop to 0 regardless of the battery state
                               this purposefully ignores any values that are 0 to stop the spikes */
                            if (chargeDatas[i].value === 0)
                                continue;
                            
                            ctx.lineTo((86400-chargeDatas[i].time) / 86400 * width,
                                    (chargeDatas[i].value / 100) * height)
                        }
                        
                        ctx.stroke()
                        ctx.restore()
                    }

                    function drawAxes(ctx, axisWidth, axisHeight, bottomMargin, rightMargin, lineHeight) {
                        var currentHour = Qt.formatDateTime(new Date(), "h")
                        var currentMinutes = Qt.formatDateTime(new Date(), "m")
                        var displayHour
                        var labelWidth
                        var zeroMark

                        ctx.save()
                        ctx.beginPath()
                        ctx.strokeStyle = HeeraUI.Theme.disabledTextColor
                        ctx.fillStyle = HeeraUI.Theme.disabledTextColor

                        ctx.lineWidth = 1

                        var fontHeight = 15
                        ctx.font = `${fontHeight}px ${percentLabel.font.family}`

                        ctx.translate(0, 1)

                        // 10 ticks
                        for (var i = 0; i <= 9; i++) {
                            var x = Math.floor(axisWidth / 2)
                            var y = (i / 10) * (height - axisHeight - bottomMargin - ctx.lineWidth)
                            ctx.moveTo(x, y)
                            ctx.lineTo(axisWidth, y)
                            ctx.lineTo(axisWidth + lineHeight, y)
                        }

                        ctx.translate(axisWidth + ctx.lineWidth / 2,
                                    height - axisHeight - bottomMargin - ctx.lineWidth / 2)

                        ctx.moveTo(0, 0)
                        ctx.lineTo(lineHeight, -lineHeight)

                        // 24 ticks with 6, 12, 18, 24 being big
                        for (i = 0; i <= 24; i++) {
                            /* the marks need to be shifted on the hours */
                            x = ((i - currentMinutes / 60) / 24) * (width - axisWidth - ctx.lineWidth - rightMargin)
                            if (x < lineHeight + HeeraUI.Units.smallSpacing)
                                continue
                            y = (i % 6 == 0) ? axisHeight : axisHeight -
                                                Math.floor(axisHeight / 2)
                            ctx.moveTo(x, 0)
                            ctx.lineTo(x, y)
                            ctx.lineTo(x, y - lineHeight)

                            /* Determine the hour to display */
                            displayHour = (currentHour - (24-i))
                            if (displayHour < 0)
                                displayHour = displayHour + 24
                            /* Store the x for the day change line */
                            if (displayHour === 0)
                                zeroMark = x

                            /* Write the x-axis legend */
                            if (i % 6 == 0) {
                                labelWidth = context.measureText("%1".arg(displayHour)).width;
                                ctx.fillText("%1".arg(displayHour),
                                            x - labelWidth / 2,
                                            axisHeight + 1 + fontHeight)
                            }
                        }

                        labelWidth = context.measureText(qsTr("Yesterday")).width;
                        if (labelWidth < zeroMark)
                            ctx.fillText(qsTr("Yesterday"),
                                        (zeroMark - labelWidth)/2,
                                        axisHeight + 6 + 2 * fontHeight)

                        // ctx.fillText("|", zeroMark, axisHeight + 6 + 2*fontHeight)

                        labelWidth = context.measureText(qsTr("Today")).width;
                        if (labelWidth < (width - zeroMark - rightMargin - axisWidth - ctx.lineWidth))
                            ctx.fillText(qsTr("Today"),
                                        zeroMark + (width - zeroMark - labelWidth)/2,
                                        axisHeight + 6 + 2 * fontHeight)

                        ctx.stroke()
                        ctx.restore()
                    }
                }
            }

            Section {
                Label {
                    text: qsTr("Statistics")
                    color: HeeraUI.Theme.disabledTextColor
                    Layout.bottomMargin: HeeraUI.Units.largeSpacing
                }

                StandardItem {
                    key: qsTr("Last Charged to") + " " + battery.lastChargedPercent + "%"
                    value: battery.lastChargedTime
                    visible: battery.lastChargedPercent !== 0
                }

                StandardItem {
                    key: qsTr("Maximum Capacity")
                    value: battery.capacity + "%"
                }
            }

            Item {
                height: HeeraUI.Units.smallSpacing
            }
        }
    }

    Label {
        anchors.centerIn: parent
        text: qsTr("No battery found")
        visible: !battery.available
    }
}
