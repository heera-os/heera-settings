import QtQuick 2.4
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.0
import HeeraUI 1.0 as HeeraUI

Item {
    id: control
    height: 150

    property int value: 0
    property int radius: height * 0.15
    property bool enableAnimation: false

    Rectangle {
        id: bgRect
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(HeeraUI.Theme.highlightColor.r, HeeraUI.Theme.highlightColor.g, HeeraUI.Theme.highlightColor.b, 0.7) }
            GradientStop { position: 1.0; color: Qt.rgba(HeeraUI.Theme.highlightColor.r, HeeraUI.Theme.highlightColor.g, HeeraUI.Theme.highlightColor.b, 0.5) }
        }
        radius: control.radius

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: bgRect.width
                height: bgRect.height

                Rectangle {
                    anchors.fill: parent
                    radius: control.radius
                }
            }
        }

        Rectangle {
            id: valueRect
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: control.width * (control.value / 100)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(HeeraUI.Theme.highlightColor.r, HeeraUI.Theme.highlightColor.g, HeeraUI.Theme.highlightColor.b, 1) }
                GradientStop { position: 1.0; color: Qt.rgba(HeeraUI.Theme.highlightColor.r, HeeraUI.Theme.highlightColor.g, HeeraUI.Theme.highlightColor.b, 0.7) }
            }
            opacity: 1

            Behavior on width {
                SmoothedAnimation {
                    velocity: 1000
                    easing.type: Easing.InOutCubic
                }
            }

            ParticleSystem {
                anchors.fill: parent

                Emitter {
                    id: emitter
                    anchors.fill: parent
                    emitRate: 7
                    lifeSpan: 2000
                    lifeSpanVariation: 500
                    size: 16
                    endSize: 32
                    enabled: control.enableAnimation

                    velocity: AngleDirection {
                        angle: 0
                        magnitude: 175
                        magnitudeVariation: 50
                    }
                }

                ItemParticle {
                    delegate: Rectangle {
                        id: particleRect
                        width: Math.ceil(Math.random() * (10 - 4)) + 4
                        height: width
                        radius: width
                        color: Qt.rgba(255, 255, 255, 0.3)
                    }
                }
            }
        }
    }
}
