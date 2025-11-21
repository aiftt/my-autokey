#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir
SetTitleMatchMode 2
SetControlDelay -1
SetKeyDelay -1
SendMode "Input"
SetDefaultMouseSpeed 0

; 管理员权限（可选）
if !A_IsAdmin {
    try {
        Run '*RunAs "' A_ScriptFullPath '"'
        ExitApp
    }
}

global Toggle := false
global ClickInterval := 50
; 蓝量检测配置
global manaCheckPosX := 980    ; 蓝条检测位置X坐标
global manaCheckPosY := 536    ; 蓝条检测位置Y坐标
global manaColor := "0AC9EB"   ; 有蓝时的颜色值（RGB，不带#）
global noManaColor := "080E0F" ; 无蓝时的颜色值（RGB，不带#）
global colorTolerance := 15    ; 颜色容差

; 指示器 GUI
global indicatorGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
indicatorGui.MarginX := 0
indicatorGui.MarginY := 0
indicatorGui.SetFont("s8", "Segoe UI")
global indicatorText := indicatorGui.AddText("w60 h20 Center +0x200 cWhite", "OFF")
indicatorGui.BackColor := "Gray"
indicatorGui.Show("x" (A_ScreenWidth//2 - 30) " y800 w60 h20 NoActivate")
UpdateIndicator()

; 绑定`键开关
`:: {
    global Toggle
    Toggle := !Toggle
    if (Toggle) {
        ToolTip("自动点击已开启")
        SetTimer(AutoClick, ClickInterval)
        SoundBeep(1200, 120)
    } else {
        ToolTip("自动点击已关闭")
        SetTimer(AutoClick, 0)
        SoundBeep(500, 150)
    }
    SetTimer(() => ToolTip(), -1500)
    UpdateIndicator()
}

; 智能点击函数（带蓝量检测）
AutoClick() {
    global manaCheckPosX, manaCheckPosY, manaColor, noManaColor, colorTolerance
    
    ; 激活游戏窗口
    if !WinActive("AION2") {
        WinActivate("AION2")
        Sleep(10)
    }
    
    ; 检测蓝量状态
    hasMana := CheckManaStatus(manaCheckPosX, manaCheckPosY, manaColor, noManaColor, colorTolerance)
    
    if (hasMana) {
        ; 有蓝时：执行完整点击序列
        Click("Left")
        Sleep(5)
        Click("Right")
        Sleep(5)
        Click("Right")
        Sleep(5)
        Click("Left")
    } else {
        ; 无蓝时：仅左键回复蓝量
        Click("Left")
        Sleep(10)
        ; 更新指示器显示无蓝状态
        UpdateIndicator(true)
    }
}

; 蓝量检测函数
CheckManaStatus(checkX, checkY, targetColor, emptyColor, tolerance) {
    try {
        currentColor := PixelGetColor(checkX, checkY, "RGB")
        currentColor := StrReplace(currentColor, "#")  ; 去除#号
        
        ; 检查是否是无蓝颜色
        if (ColorsAreSimilar(currentColor, emptyColor, tolerance)) {
            return false
        }
        
        ; 检查是否是有蓝颜色
        ; return ColorsAreSimilar(currentColor, targetColor, tolerance)
        return true
    } catch {
        return true  ; 获取颜色失败时默认有蓝
    }
}

; 颜色相似度比较
ColorsAreSimilar(color1, color2, tolerance) {
    ; 确保颜色字符串是6位
    color1 := SubStr("000000" color1, -5)
    color2 := SubStr("000000" color2, -5)
    
    ; 分解RGB分量并转换为数值
    r1 := "0x" SubStr(color1, 1, 2) + 0, g1 := "0x" SubStr(color1, 3, 2) + 0, b1 := "0x" SubStr(color1, 5, 2) + 0
    r2 := "0x" SubStr(color2, 1, 2) + 0, g2 := "0x" SubStr(color2, 3, 2) + 0, b2 := "0x" SubStr(color2, 5, 2) + 0
    
    ; 检查每个分量的差值是否在容差范围内
    if (Abs(r1 - r2) > tolerance)
        return false
    if (Abs(g1 - g2) > tolerance)
        return false
    if (Abs(b1 - b2) > tolerance)
        return false
    
    return true
}

; 更新指示器状态（支持无蓝提示）
UpdateIndicator(noMana := false) {
    global indicatorGui, indicatorText, Toggle
    if (Toggle) {
        if (noMana) {
            indicatorGui.BackColor := "Orange"
            indicatorText.Value := "NO MANA"
        } else {
            indicatorGui.BackColor := "Green"
            indicatorText.Value := "ON"
        }
    } else {
        indicatorGui.BackColor := "Gray"
        indicatorText.Value := "OFF"
    }
}

Esc::ExitApp