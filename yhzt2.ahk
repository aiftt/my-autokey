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
; 原 step 变量移除
; global nextStep := 1
; 新的序列控制变量（已简化，移除重入控制）
; global burstRunning := false
global cycleInterval := 60  ; 每轮发送“左、右”的周期（毫秒）
global perClickDelay := 30   ; 左右之间的间隔（毫秒）

; 指示器 GUI（置顶小方块显示 ON/OFF）
global indicatorGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
indicatorGui.MarginX := 0
indicatorGui.MarginY := 0
indicatorGui.SetFont("s8", "Segoe UI")
global indicatorText := indicatorGui.AddText("w30 h20 Center +0x200 cWhite", "OFF")
indicatorGui.BackColor := "Gray"
indicatorGui.Show("x" (A_ScreenWidth//2 - 15) " y800 w30 h20 NoActivate")
UpdateIndicator()

SC029::{
    global isRunning, cycleInterval
    isRunning := !isRunning
    if (isRunning) {
        SetTimer SimpleRoutine, cycleInterval
        SoundBeep(1200, 120)
    } else {
        SetTimer SimpleRoutine, 0
        SoundBeep(500, 150)
    }
    UpdateIndicator()
}

SimpleRoutine() {
    global isRunning, perClickDelay
    if (!isRunning) {
        return
    }
    Send "{LButton}"
    Sleep(perClickDelay)
    Send "{RButton}"
    Send "q"
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