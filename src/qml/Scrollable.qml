import QtQuick 2.4
import QtQuick.Controls 2.4
import HeeraUI 1.0 as HeeraUI

Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    // clip: true

    topMargin: HeeraUI.Units.largeSpacing
    leftMargin: HeeraUI.Units.largeSpacing * 2
    rightMargin: HeeraUI.Units.largeSpacing * 2

    contentWidth: width - (leftMargin + rightMargin)

    ScrollBar.vertical: ScrollBar {}
}
