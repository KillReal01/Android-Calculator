// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: display

    signal backspaceRequested()

    property string displayText: "0"
    property string historyText: ""
    property bool memoryActive: false
    property string angleMode: "DEG"
    readonly property int maxValueFontSize: 94
    readonly property int minValueFontSize: 34
    property real valueScale: 1.0

    implicitWidth: 320
    implicitHeight: 190

    function preferredValueFontSize() {
        const length = displayText.length
        if (length <= 6)
            return maxValueFontSize
        if (length <= 8)
            return 84
        if (length <= 10)
            return 72
        if (length <= 12)
            return 60
        if (length <= 14)
            return 50
        return 42
    }

    Rectangle {
        anchors.fill: parent
        radius: 32
        color: "#050505"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        property real pressX: 0
        property real pressY: 0

        onPressed: function(mouse) {
            pressX = mouse.x
            pressY = mouse.y
        }

        onReleased: function(mouse) {
            const deltaX = mouse.x - pressX
            const deltaY = Math.abs(mouse.y - pressY)
            if (Math.abs(deltaX) > 44 && deltaY < 32)
                display.backspaceRequested()
        }
    }

    onDisplayTextChanged: valuePulse.restart()

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Item {
            width: parent.width
            height: 28

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Rectangle {
                    visible: display.memoryActive
                    width: visible ? 26 : 0
                    height: 22
                    radius: 11
                    color: "#2C2C2E"

                    Text {
                        anchors.centerIn: parent
                        text: "M"
                        color: "#F2F2F7"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                }

                Rectangle {
                    width: 42
                    height: 22
                    radius: 11
                    color: "#2C2C2E"

                    Text {
                        anchors.centerIn: parent
                        text: display.angleMode
                        color: "#AFAFB4"
                        font.pixelSize: 11
                        font.weight: Font.Medium
                    }
                }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.72
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideLeft
                text: display.historyText
                color: "#8E8E93"
                font.pixelSize: 16
                font.weight: Font.Medium
            }
        }

        Item {
            id: valueViewport
            width: parent.width
            height: parent.parent.height - 58
            clip: true

            Text {
                id: displayValue
                anchors.fill: parent
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
                text: display.displayText
                color: "#F2F2F7"
                font.pixelSize: display.preferredValueFontSize()
                minimumPixelSize: display.minValueFontSize
                fontSizeMode: Text.Fit
                font.weight: Font.Light
                wrapMode: Text.NoWrap
                scale: display.valueScale
                transformOrigin: Item.Right

                Behavior on scale {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.min(parent.width * 0.18, 56)
                visible: displayValue.paintedWidth > valueViewport.width
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#050505" }
                    GradientStop { position: 0.38; color: "#050505" }
                    GradientStop { position: 1.0; color: "#00000000" }
                }
            }
        }
    }

    SequentialAnimation {
        id: valuePulse
        running: false

        NumberAnimation {
            target: display
            property: "valueScale"
            to: 1.018
            duration: 70
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: display
            property: "valueScale"
            to: 1.0
            duration: 120
            easing.type: Easing.OutCubic
        }
    }
}
