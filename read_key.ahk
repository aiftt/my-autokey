#Requires AutoHotkey v2.0

; read_key.ahk
; 功能：脚本运行后，在屏幕左上角显示最近一次按下键的虚拟键码(VK)、扫描码(SC)及名称。
; 说明：使用 InputHook 的 OnKeyDown 回调捕获所有键，不拦截游戏输入，仅显示信息。

; 创建悬浮显示窗口
indicatorGui := Gui()
indicatorGui.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20") ; 置顶、去标题、工具窗口、点击穿透
indicatorGui.SetFont("s10", "Consolas")
infoText := indicatorGui.AddText("vInfo cWhite BackgroundTrans w420", "read_key 已启动，按任意键显示编码…")
indicatorGui.BackColor := "Black"
indicatorGui.Show("x10 y10 NoActivate")

; 设置键盘输入钩子，通知所有按键
ih := InputHook()
ih.KeyOpt("{All}", "N") ; N: 每次按下/抬起都通知 OnKeyDown/OnKeyUp

; 仅使用按下事件
ih.OnKeyDown := (ih, vk, sc) => ShowKey(vk, sc)
ih.Start()

ShowKey(vk, sc) {
    vkHex := Format("{:02X}", vk)
    scHex := Format("{:03X}", sc)

    nameVk := ""
    nameSc := ""
    try nameVk := GetKeyName("vk" vkHex)
    try nameSc := GetKeyName("sc" scHex)

    info := ""
    if (nameVk != "") {
        info := Format("VK: 0x{1} ({2})", vkHex, nameVk)
    } else {
        info := Format("VK: 0x{1}", vkHex)
    }
    if (nameSc != "") {
        info := info "  |  " Format("SC: 0x{1} ({2})", scHex, nameSc)
    } else {
        info := info "  |  " Format("SC: 0x{1}", scHex)
    }

    infoText.Value := info
}

; 快速退出脚本（如需）
Esc::ExitApp

; 鼠标按钮与滚轮监听（传递原始输入）
~LButton:: {
    ShowMouseKey("LButton")
}
~RButton:: {
    ShowMouseKey("RButton")
}
~MButton:: {
    ShowMouseKey("MButton")
}
~XButton1:: {
    ShowMouseKey("XButton1")
}
~XButton2:: {
    ShowMouseKey("XButton2")
}

; 鼠标滚轮
~WheelUp:: {
    ShowMouseKey("WheelUp")
}
~WheelDown:: {
    ShowMouseKey("WheelDown")
}
~WheelLeft:: {
    ShowMouseKey("WheelLeft")
}
~WheelRight:: {
    ShowMouseKey("WheelRight")
}

ShowMouseKey(name) {
    vk := GetKeyVK(name)
    sc := GetKeySC(name)
    ShowKey(vk, sc)
}