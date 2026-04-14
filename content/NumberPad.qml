// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    id: controller

    property bool isPortraitMode: root.isPortraitMode
    property string activeOperator: ""
    property string angleMode: "DEG"

    readonly property int portraitButtonSize: 80
    readonly property int landscapeButtonSize: 66
    readonly property int scientificButtonSize: 54
    readonly property int portraitSpacing: 10
    readonly property int landscapeSpacing: 8
    readonly property int mainButtonSize: isPortraitMode ? portraitButtonSize : landscapeButtonSize
    readonly property int spacing: isPortraitMode ? portraitSpacing : landscapeSpacing
    readonly property int portraitModeWidth: mainGrid.implicitWidth
    readonly property int landscapeModeWidth: scientificGrid.implicitWidth + mainGrid.implicitWidth + spacing

    implicitWidth: isPortraitMode ? portraitModeWidth : landscapeModeWidth
    implicitHeight: isPortraitMode ? mainGrid.implicitHeight : Math.max(scientificGrid.implicitHeight, mainGrid.implicitHeight)

    component MainButton: CalculatorButton {
        implicitWidth: controller.mainButtonSize
        implicitHeight: controller.mainButtonSize
    }

    component ScientificButton: CalculatorButton {
        buttonRole: "scientific"
        implicitWidth: controller.scientificButtonSize
        implicitHeight: controller.scientificButtonSize
    }

    RowLayout {
        anchors.fill: parent
        spacing: controller.spacing

        GridLayout {
            id: scientificGrid
            columns: 5
            rowSpacing: controller.spacing
            columnSpacing: controller.spacing
            visible: !controller.isPortraitMode

            ScientificButton { text: "mc"; onClicked: root.operatorPressed("mc") }
            ScientificButton { text: "m+"; onClicked: root.operatorPressed("m+") }
            ScientificButton { text: "m-"; onClicked: root.operatorPressed("m-") }
            ScientificButton { text: "mr"; onClicked: root.operatorPressed("mr") }
            ScientificButton { text: "⌫"; onClicked: root.operatorPressed("⌫") }

            ScientificButton { text: "x²"; onClicked: root.operatorPressed("x²") }
            ScientificButton { text: "x³"; onClicked: root.operatorPressed("x³") }
            ScientificButton {
                text: "xʸ"
                activeState: controller.activeOperator === "xʸ"
                onClicked: root.operatorPressed("xʸ")
            }
            ScientificButton { text: "eˣ"; onClicked: root.operatorPressed("eˣ") }
            ScientificButton { text: "10ˣ"; onClicked: root.operatorPressed("10ˣ") }

            ScientificButton { text: "1/x"; onClicked: root.operatorPressed("1/x") }
            ScientificButton { text: "²√x"; onClicked: root.operatorPressed("²√x") }
            ScientificButton { text: "³√x"; onClicked: root.operatorPressed("³√x") }
            ScientificButton {
                text: "ʸ√x"
                activeState: controller.activeOperator === "ʸ√x"
                onClicked: root.operatorPressed("ʸ√x")
            }
            ScientificButton { text: "x!"; onClicked: root.operatorPressed("x!") }

            ScientificButton { text: "ln"; onClicked: root.operatorPressed("ln") }
            ScientificButton { text: "log"; onClicked: root.operatorPressed("log") }
            ScientificButton { text: "sin"; onClicked: root.operatorPressed("sin") }
            ScientificButton { text: "cos"; onClicked: root.operatorPressed("cos") }
            ScientificButton { text: "tan"; onClicked: root.operatorPressed("tan") }

            ScientificButton { text: "π"; onClicked: root.operatorPressed("π") }
            ScientificButton { text: "e"; onClicked: root.operatorPressed("e") }
            ScientificButton { text: "RND"; onClicked: root.operatorPressed("RND") }
            ScientificButton { text: controller.angleMode; onClicked: root.operatorPressed("angle") }
            ScientificButton { text: "%"; onClicked: root.operatorPressed("%") }
        }

        GridLayout {
            id: mainGrid
            columns: 4
            rowSpacing: controller.spacing
            columnSpacing: controller.spacing

            MainButton { text: "AC"; buttonRole: "utility"; onClicked: root.operatorPressed("AC") }
            MainButton { text: "±"; buttonRole: "utility"; onClicked: root.operatorPressed("±") }
            MainButton { text: "%"; buttonRole: "utility"; onClicked: root.operatorPressed("%") }
            MainButton {
                text: "÷"
                buttonRole: "operator"
                activeState: controller.activeOperator === "÷"
                onClicked: root.operatorPressed("÷")
            }

            MainButton { text: "7"; onClicked: root.digitPressed("7") }
            MainButton { text: "8"; onClicked: root.digitPressed("8") }
            MainButton { text: "9"; onClicked: root.digitPressed("9") }
            MainButton {
                text: "×"
                buttonRole: "operator"
                activeState: controller.activeOperator === "×"
                onClicked: root.operatorPressed("×")
            }

            MainButton { text: "4"; onClicked: root.digitPressed("4") }
            MainButton { text: "5"; onClicked: root.digitPressed("5") }
            MainButton { text: "6"; onClicked: root.digitPressed("6") }
            MainButton {
                text: "−"
                buttonRole: "operator"
                activeState: controller.activeOperator === "−"
                onClicked: root.operatorPressed("−")
            }

            MainButton { text: "1"; onClicked: root.digitPressed("1") }
            MainButton { text: "2"; onClicked: root.digitPressed("2") }
            MainButton { text: "3"; onClicked: root.digitPressed("3") }
            MainButton {
                text: "+"
                buttonRole: "operator"
                activeState: controller.activeOperator === "+"
                onClicked: root.operatorPressed("+")
            }

            MainButton {
                text: "0"
                wide: true
                Layout.columnSpan: 2
                Layout.fillWidth: true
                onClicked: root.digitPressed("0")
            }
            MainButton { text: "."; onClicked: root.digitPressed(".") }
            MainButton { text: "="; buttonRole: "operator"; onClicked: root.operatorPressed("=") }
        }

        Item {
            Layout.fillWidth: true
            visible: !controller.isPortraitMode
        }
    }
}
