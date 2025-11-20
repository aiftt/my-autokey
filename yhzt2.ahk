#Requires AutoHotkey v2.0
#SingleInstance Force

if !A_IsAdmin {
    try {
        Run '*RunAs "' A_ScriptFullPath '"'
        ExitApp
    }
}

; 按下 ` 键切换开启/关闭循环点击：左键、左键、右键（重复）
; 可根据需要调整点击间隔（毫秒）
global isRunning := false
global nextStep := 1
global clickInterval := 50  ; 每次点击之间的间隔，单位毫秒
global indicatorGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
indicatorGui.MarginX := 0
indicatorGui.MarginY := 0
indicatorGui.SetFont("s8", "Segoe UI")
global indicatorText := indicatorGui.AddText("w30 h20 Center +0x200 cWhite", "OFF")
indicatorGui.BackColor := "Gray"
indicatorGui.Show("x" (A_ScreenWidth//2 - 15) " y800 w30 h20 NoActivate")
UpdateIndicator()

SC029::{
    global isRunning, nextStep, clickInterval
    isRunning := !isRunning
    if (isRunning) {
        nextStep := 1  ; 每次开启时从“左键、左键、右键”的第一步开始
        SetTimer ClickRoutine, clickInterval
    } else {
        SetTimer ClickRoutine, 0
    }
    UpdateIndicator()
}

ClickRoutine() {
    global nextStep
    if (nextStep <= 2) {
        Click
    } else {
        RightClick()
    }
    nextStep := (nextStep = 3) ? 1 : (nextStep + 1)
}

RightClick() {
    ; 使用低级API注入右键（更容易被游戏识别）
    DllCall("mouse_event", "UInt", 0x0008, "Int", 0, "Int", 0, "UInt", 0, "UInt", 0) ; 右键按下
    Sleep 30
    DllCall("mouse_event", "UInt", 0x0010, "Int", 0, "Int", 0, "UInt", 0, "UInt", 0) ; 右键释放
}

UpdateIndicator() {
    global indicatorGui, indicatorText, isRunning
    if (isRunning) {
        indicatorGui.BackColor := "Green"
        indicatorText.Value := "ON"
    } else {
        indicatorGui.BackColor := "Gray"
        indicatorText.Value := "OFF"
    }
}