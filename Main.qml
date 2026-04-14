// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import "content"
import "content/calculator.js" as CalcEngine

Window {
    visible: true
    width: 390
    height: 760
    color: "#000000"
    minimumWidth: root.isPortraitMode ? 360 : 720
    minimumHeight: root.isPortraitMode ? 680 : 420
    title: qsTr("Calculator")

    Item {
        id: root
        anchors.fill: parent
        focus: true

        readonly property int padding: isPortraitMode ? 18 : 20
        readonly property int sectionSpacing: isPortraitMode ? 16 : 18
        readonly property int minLandscapeModeWidth: 720
        property bool isPortraitMode: width < minLandscapeModeWidth
        property string activeOperator: ""
        property bool memoryActive: false
        property string angleMode: "DEG"

        function refreshUi() {
            const state = CalcEngine.getState()
            display.displayText = state.displayText
            display.historyText = state.historyText
            display.memoryActive = state.memoryActive
            display.angleMode = state.angleMode
            activeOperator = state.activeOperator
            memoryActive = state.memoryActive
            angleMode = state.angleMode
        }

        function operatorPressed(operatorText) {
            CalcEngine.perform(operatorText)
            refreshUi()
        }

        function digitPressed(digitText) {
            CalcEngine.input(digitText)
            refreshUi()
        }

        Component.onCompleted: {
            CalcEngine.reset()
            refreshUi()
            root.forceActiveFocus()
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
        }

        Item {
            anchors.fill: parent
            anchors.margins: root.padding

            Display {
                id: display
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: numberPad.top
                anchors.bottomMargin: root.sectionSpacing
                implicitHeight: root.isPortraitMode ? 210 : 176
                onBackspaceRequested: root.operatorPressed("⌫")
            }

            NumberPad {
                id: numberPad
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                activeOperator: root.activeOperator
                angleMode: root.angleMode
            }
        }

        Keys.onPressed: function(event) {
            if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                digitPressed(String.fromCharCode(event.key))
                event.accepted = true
                return
            }

            switch (event.key) {
            case Qt.Key_Comma:
            case Qt.Key_Period:
                digitPressed(".")
                break
            case Qt.Key_Plus:
                operatorPressed("+")
                break
            case Qt.Key_Minus:
                operatorPressed("−")
                break
            case Qt.Key_Asterisk:
                operatorPressed("×")
                break
            case Qt.Key_Slash:
                operatorPressed("÷")
                break
            case Qt.Key_Return:
            case Qt.Key_Enter:
                operatorPressed("=")
                break
            case Qt.Key_Backspace:
                operatorPressed("⌫")
                break
            case Qt.Key_Percent:
                operatorPressed("%")
                break
            default:
                return
            }

            event.accepted = true
        }
    }
}
