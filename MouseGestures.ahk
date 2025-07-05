#SingleInstance Force

; Variables for gesture tracking
gestureActive := false
startX := 0
startY := 0
minDistance := 50  ; Minimum pixels to move down before triggering Ctrl+W
gestureTriggered := false

; Track shaded windows
shadedWindows := Map()

; Right mouse button handler (for gestures and normal clicks)
RButton::
{
    ; Check if left mouse button is being held down
    if (GetKeyState("LButton", "P")) {
        ; Left button is pressed, just do a normal right-click without gestures
        Click("Right")
        return
    }
    
    ; Get starting mouse position and window info
    MouseGetPos(&startX, &startY, &winID, &control)
    gestureActive := true
    gestureTriggered := false
    
    ; Wait for button release or gesture completion
    movementDetected := false
    while GetKeyState("RButton", "P") {
        ; Double-check that left button isn't pressed during gesture
        if (GetKeyState("LButton", "P")) {
            ; Left button was pressed during gesture, cancel gesture and do normal right-click
            gestureActive := false
            Click("Right")
            return
        }
        
        MouseGetPos(&currentX, &currentY)
        
        ; Calculate movement from start position
        deltaY := currentY - startY
        deltaX := Abs(currentX - startX)
        
        ; Check if there's any significant movement
        if (deltaX > 5 || Abs(deltaY) > 5) {
            movementDetected := true
        }
        
        ; Check for downward gesture (Ctrl+W)
        if (deltaY >= minDistance && !gestureTriggered) {
            Send("^w")
            gestureTriggered := true
            Sleep(200)
        }
        
        Sleep(10)
    }
    
    gestureActive := false
    
    ; Determine what action to take
    if (gestureTriggered) {
        ; Gesture was performed, don't do anything else
        return
    } else {
        ; Normal right-click
        Click("Right")
    }
    
    return
}

; Ctrl+Right-click for window shading
Ctrl & RButton::
{
    ; Check if left mouse button is being held down
    if (GetKeyState("LButton", "P")) {
        ; Left button is pressed, don't perform shading
        return
    }
    
    ; Get mouse position and window info
    MouseGetPos(&mouseX, &mouseY, &winID, &control)
    
    if (winID != 0) {
        try {
            winClass := WinGetClass(winID)
            
            ; Skip certain system windows/classes
            if (winClass != "Shell_TrayWnd" && winClass != "DV2ControlHost" && winClass != "WorkerW") {
                ; Simplified approach: just shade any window when Ctrl+Right-click is used
                ; No position checking - if you're Ctrl+Right-clicking, you probably want to shade
                ToggleWindowShade(winID)
                return
            }
        } catch {
            ; Handle any errors silently
        }
    }
    
    ; If not a valid window, do nothing
    return
}

; Function to toggle window shading
ToggleWindowShade(winID) {
    try {
        ; Check if window is already shaded
        if (shadedWindows.Has(winID)) {
            ; Unshade: restore original height and remove always-on-top
            originalHeight := shadedWindows[winID]
            WinGetPos(&x, &y, &w, , winID)
            WinMove(x, y, w, originalHeight, winID)
            
            ; Remove always-on-top
            WinSetAlwaysOnTop(false, winID)
            
            shadedWindows.Delete(winID)
        } else {
            ; Shade: store original height and minimize to title bar
            WinGetPos(&x, &y, &w, &h, winID)
            
            ; Store original height
            shadedWindows[winID] := h
            
            ; Calculate title bar height more accurately
            titleBarHeight := GetTitleBarHeight(winID)
            
            ; Make shaded window exactly the title bar size
            shadedHeight := titleBarHeight
            if (shadedHeight < 25) shadedHeight := 25  ; Minimum height for functionality
            if (shadedHeight > 35) shadedHeight := 35  ; Maximum height to keep it compact
            
            ; Resize window to just the title bar
            WinMove(x, y, w, shadedHeight, winID)
            
            ; Set always-on-top for shaded windows
            WinSetAlwaysOnTop(true, winID)
        }
    } catch {
        ; If error occurs, remove from tracking
        if (shadedWindows.Has(winID)) {
            shadedWindows.Delete(winID)
        }
    }
}

; Function to get more accurate title bar height
GetTitleBarHeight(winID) {
    try {
        ; Get window and client area
        WinGetPos(, , , &winHeight, winID)
        WinGetClientPos(, , , &clientHeight, winID)
        
        ; Calculate title bar height (window height - client height)
        titleBarHeight := winHeight - clientHeight
        
        ; Ensure minimum height
        if (titleBarHeight < 25) {
            titleBarHeight := 30
        }
        
        return titleBarHeight
    } catch {
        return 30  ; Default fallback
    }
}

; Optional: Add hotkey to unshade all windows
^!u:: {  ; Ctrl+Alt+U to unshade all windows
    for winID, originalHeight in shadedWindows.Clone() {
        try {
            WinGetPos(&x, &y, &w, , winID)
            WinMove(x, y, w, originalHeight, winID)
            ; Remove always-on-top when unshading
            WinSetAlwaysOnTop(false, winID)
        }
    }
    shadedWindows.Clear()
}