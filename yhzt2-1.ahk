#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir
SetTitleMatchMode 2
SetControlDelay -1
SetKeyDelay -1
SendMode "Input"
SetDefaultMouseSpeed 0

; 管理员权限（可选，根据需要启用）
if !A_IsAdmin {
    try {
        Run '*RunAs "' A_ScriptFullPath '"'
        ExitApp
    }
}

global Toggle := false
global ClickInterval := 50

; 指示器 GUI（置顶小方块显示 ON/OFF）
global indicatorGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
indicatorGui.MarginX := 0
indicatorGui.MarginY := 0
indicatorGui.SetFont("s8", "Segoe UI")
global indicatorText := indicatorGui.AddText("w30 h20 Center +0x200 cWhite", "OFF")
indicatorGui.BackColor := "Gray"
; 位置可根据需要调整（当前在屏幕下方中间）
indicatorGui.Show("x" (A_ScreenWidth//2 - 15) " y800 w30 h20 NoActivate")
UpdateIndicator()

; 绑定`键开关
`:: {
    global Toggle
    Toggle := !Toggle
    if (Toggle) {
        SetTimer(AutoClick, ClickInterval)
        SoundBeep(1200, 120)  ; 开启提示音
    } else {
        SetTimer(AutoClick, 0)
        SoundBeep(500, 150)   ; 关闭提示音
    }
    SetTimer(() => ToolTip(), -1500)
    UpdateIndicator()  ; 更新指示器状态
}

; 优化的点击函数
AutoClick() {
    ; 强制激活永恒之塔窗口（根据实际窗口名调整）
    if !WinActive("AION2") {
        WinActivate("AION2")
        Sleep(10)  ; 等待窗口激活
    }
    
    ; 你的点击逻辑
    Click("Left")
    Sleep(5)
    Click("Right")
    Sleep(5)
    Click("Right")
    Sleep(5)
    Click("Left")
}

; 更新指示器状态
UpdateIndicator() {
    global indicatorGui, indicatorText, Toggle
    if (Toggle) {
        indicatorGui.BackColor := "Green"
        indicatorText.Value := "ON"
    } else {
        indicatorGui.BackColor := "Gray"
        indicatorText.Value := "OFF"
    }
}

Esc::ExitApp