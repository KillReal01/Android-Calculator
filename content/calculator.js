// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

.pragma library

let currentValue = "0"
let storedValue = null
let pendingOperator = ""
let statusText = ""
let waitingForOperand = true
let justEvaluated = false
let memoryValue = 0
let angleMode = "DEG"

const errorText = "Error"

function reset() {
    currentValue = "0"
    storedValue = null
    pendingOperator = ""
    statusText = ""
    waitingForOperand = true
    justEvaluated = false
    memoryValue = 0
    angleMode = "DEG"
}

function getState() {
    return {
        displayText: currentValue,
        historyText: statusText,
        activeOperator: pendingOperator,
        memoryActive: memoryValue !== 0,
        angleMode: angleMode
    }
}

function isErrorState() {
    return currentValue === errorText
}

function getCurrentNumber() {
    return Number(currentValue)
}

function setError() {
    currentValue = errorText
    statusText = ""
    storedValue = null
    pendingOperator = ""
    waitingForOperand = true
    justEvaluated = true
}

function formatNumber(value) {
    if (!isFinite(value))
        return errorText

    if (Object.is(value, -0))
        value = 0

    if (value === 0)
        return "0"

    const abs = Math.abs(value)
    let text = Number(value.toPrecision(12)).toString()
    if (abs >= 1e12 || abs < 1e-9)
        text = value.toExponential(7).replace("e", "E")
    if (text.length > 14)
        text = value.toExponential(6).replace("e", "E")

    return text
}

function setDisplayNumber(value) {
    const text = formatNumber(value)
    if (text === errorText) {
        setError()
        return false
    }

    currentValue = text
    return true
}

function toRadians(value) {
    return angleMode === "DEG" ? value * Math.PI / 180 : value
}

function factorial(value) {
    if (!Number.isInteger(value) || value < 0 || value > 170)
        return NaN

    let result = 1
    for (let i = 2; i <= value; ++i)
        result *= i
    return result
}

function startNewEntry(text) {
    currentValue = text
    waitingForOperand = false
    justEvaluated = false
}

function input(token) {
    if (token.length !== 1 && token !== ".")
        return

    if (isErrorState()) {
        currentValue = "0"
        waitingForOperand = true
        justEvaluated = false
    }

    if (waitingForOperand || (justEvaluated && pendingOperator === "")) {
        if (token === ".") {
            startNewEntry("0.")
        } else {
            startNewEntry(token)
        }
        return
    }

    if (token === "." && currentValue.indexOf(".") !== -1)
        return

    if (currentValue === "0" && token !== ".") {
        currentValue = token
    } else {
        currentValue += token
    }
}

function applyConstant(name) {
    if (name === "π")
        setDisplayNumber(Math.PI)
    else if (name === "e")
        setDisplayNumber(Math.E)
    else if (name === "Rand" || name === "RND")
        setDisplayNumber(Math.random())

    waitingForOperand = false
    justEvaluated = false
}

function applyUnaryOperation(op) {
    const value = getCurrentNumber()
    let result = NaN

    switch (op) {
    case "±":
        result = value * -1
        break
    case "%":
        if (pendingOperator !== "" && storedValue !== null)
            result = storedValue * value / 100
        else
            result = value / 100
        break
    case "1/x":
        result = value === 0 ? NaN : 1 / value
        break
    case "x²":
        result = value * value
        break
    case "x³":
        result = value * value * value
        break
    case "²√x":
        result = value < 0 ? NaN : Math.sqrt(value)
        break
    case "³√x":
        result = Math.cbrt(value)
        break
    case "eˣ":
        result = Math.exp(value)
        break
    case "10ˣ":
        result = Math.pow(10, value)
        break
    case "ln":
        result = value <= 0 ? NaN : Math.log(value)
        break
    case "log10":
    case "log":
        result = value <= 0 ? NaN : Math.log10(value)
        break
    case "sin":
        result = Math.sin(toRadians(value))
        break
    case "cos":
        result = Math.cos(toRadians(value))
        break
    case "tan":
        result = Math.tan(toRadians(value))
        break
    case "x!":
        result = factorial(value)
        break
    default:
        return
    }

    if (!setDisplayNumber(result))
        return

    const operandLabel = pendingOperator !== "" && storedValue !== null
            ? formatNumber(storedValue) + " " + pendingOperator
            : ""
    statusText = operandLabel !== "" ? operandLabel + " " + op : op
    waitingForOperand = false
}

function executeBinary(left, right, op) {
    switch (op) {
    case "+":
        return left + right
    case "−":
        return left - right
    case "×":
        return left * right
    case "÷":
        return right === 0 ? NaN : left / right
    case "xʸ":
        return Math.pow(left, right)
    case "y√x":
    case "ʸ√x":
        return left === 0 ? NaN : Math.pow(right, 1 / left)
    default:
        return right
    }
}

function setBinaryOperation(op) {
    if (isErrorState())
        return

    const inputValue = getCurrentNumber()

    if (pendingOperator !== "" && storedValue !== null && !waitingForOperand) {
        const chainedResult = executeBinary(storedValue, inputValue, pendingOperator)
        if (!setDisplayNumber(chainedResult))
            return
        storedValue = getCurrentNumber()
    } else if (storedValue === null || !waitingForOperand) {
        storedValue = inputValue
    }

    pendingOperator = op
    statusText = formatNumber(storedValue) + " " + op
    waitingForOperand = true
    justEvaluated = false
}

function evaluate() {
    if (pendingOperator === "" || storedValue === null || isErrorState())
        return

    const rightValue = getCurrentNumber()
    const leftValue = storedValue
    const expression = formatNumber(leftValue) + " " + pendingOperator + " " + formatNumber(rightValue) + " ="
    const result = executeBinary(leftValue, rightValue, pendingOperator)

    if (!setDisplayNumber(result))
        return

    statusText = expression
    storedValue = null
    pendingOperator = ""
    waitingForOperand = true
    justEvaluated = true
}

function handleMemory(op) {
    if (isErrorState())
        return

    const value = getCurrentNumber()
    if (op === "mc") {
        memoryValue = 0
    } else if (op === "m+") {
        memoryValue += value
    } else if (op === "m-") {
        memoryValue -= value
    } else if (op === "mr") {
        setDisplayNumber(memoryValue)
        waitingForOperand = false
        justEvaluated = false
    }
}

function perform(op) {
    if (op === "AC") {
        reset()
        return
    }

    if (op === "angle") {
        angleMode = angleMode === "DEG" ? "RAD" : "DEG"
        return
    }

    if (isErrorState() && op !== "AC")
        return

    if (op === "⌫") {
        if (waitingForOperand || justEvaluated)
            return

        currentValue = currentValue.slice(0, -1)
        if (currentValue === "" || currentValue === "-")
            currentValue = "0"
        return
    }

    if (op === "π" || op === "e" || op === "Rand" || op === "RND") {
        applyConstant(op)
        return
    }

    if (op === "mc" || op === "m+" || op === "m-" || op === "mr") {
        handleMemory(op)
        return
    }

    if (op === "=") {
        evaluate()
        return
    }

    if (op === "+" || op === "−" || op === "×" || op === "÷" || op === "xʸ" || op === "y√x" || op === "ʸ√x") {
        setBinaryOperation(op)
        return
    }

    applyUnaryOperation(op)
}
