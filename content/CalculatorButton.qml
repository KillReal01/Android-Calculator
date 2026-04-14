// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls

RoundButton {
    id: button

    property string buttonRole: "digit"
    property bool activeState: false
    property bool wide: false

    implicitWidth: 80
    implicitHeight: 80
    radius: height / 2
    hoverEnabled: true

    function backgroundColor() {
        if (buttonRole === "operator")
            return activeState ? "#F2F2F7" : "#FF9F0A"
        if (buttonRole === "utility")
            return "#A5A5AA"
        if (buttonRole === "scientific")
            return "#1C1C1E"
        return "#2C2C2E"
    }

    function foregroundColor() {
        if (buttonRole === "operator")
            return activeState ? "#FF9F0A" : "#FFFFFF"
        if (buttonRole === "utility")
            return "#000000"
        return "#FFFFFF"
    }

    function overlayColor() {
        if (buttonRole === "operator")
            return activeState ? "#14FF9F0A" : "#1FFFFFFF"
        if (buttonRole === "utility")
            return "#20FFFFFF"
        return "#18FFFFFF"
    }

    scale: pressed ? 0.96 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 120
            easing.type: Easing.OutCubic
        }
    }

    background: Rectangle {
        radius: button.height / 2
        color: button.backgroundColor()

        Behavior on color {
            ColorAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: button.overlayColor()
            opacity: button.hovered || button.pressed ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    contentItem: Text {
        anchors.fill: parent
        text: button.text
        color: button.foregroundColor()
        font.pixelSize: button.wide ? 34 : (button.buttonRole === "scientific" ? 21 : 32)
        font.weight: button.buttonRole === "utility" ? Font.DemiBold : Font.Medium
        horizontalAlignment: button.wide ? Text.AlignLeft : Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: button.wide ? 28 : 0
        rightPadding: 0

        Behavior on color {
            ColorAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }
    }
}
