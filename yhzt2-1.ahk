#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir
SetTitleMatchMode 2

global Toggle := false
global ClickInterval := 30  ; 点击间隔（毫秒）

; 指示器GUI
global indicatorGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
indicatorGui.MarginX := 0
indicatorGui.MarginY := 0
indicatorGui.SetFont("s8", "Segoe UI")
global indicatorText := indicatorGui.AddText("w80 h20 Center +0x200 cWhite", "OFF")
indicatorGui.BackColor := "Gray"
indicatorGui.Show("x" (A_ScreenWidth//2 - 40) " y800 w80 h20 NoActivate")

; 绑定`键开关
`:: {
    global Toggle
    Toggle := !Toggle
    if (Toggle) {
        SetTimer(AutoClickLoop, ClickInterval)
        SoundBeep(1200, 120)
    } else {
        SetTimer(AutoClickLoop, 0)
        SoundBeep(500, 150)
    }
    SetTimer(() => ToolTip(), -1500)
    UpdateIndicator()
}

; 自动点击循环：两次左键一次右键
AutoClickLoop() {
    static clickCount := 0
    
    ; 激活游戏窗口
    if !WinActive("AION2") {
        WinActivate("AION2")
        Sleep(10)
    }
    
    clickCount++
    if (clickCount <= 3) {
        Click("Left")  ; 左键
        UpdateIndicator(false, "左键" clickCount)
    } else {
        Click("Right") ; 右键
        UpdateIndicator(true, "右键")
        clickCount := 0 ; 重置计数
    }
}

; 更新指示器状态
UpdateIndicator(isRight := false, status := "") {
    global indicatorGui, indicatorText, Toggle
    if (Toggle) {
        ; if (isRight) {
        ;     indicatorGui.BackColor := "Blue"
        ;     indicatorText.Value := status
        ; } else {
        indicatorGui.BackColor := "Green"
        indicatorText.Value := '开启'
        ; }
    } else {
        indicatorGui.BackColor := "Gray"
        indicatorText.Value := "关闭"
    }
}

Esc::ExitApp