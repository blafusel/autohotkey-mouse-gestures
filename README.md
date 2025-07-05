# AutoHotKey Window Management
A set of AutoHotkey scripts that add mouse gestures and window management functionality to Windows

## **Features**

### **Main Script, Text Expansions (`Main.ahk`)**
- **@@:** Expands to `road.runner@acme.org`
- **Alt + Ctrl + Shift +R:** Reload the script
- **Ctrl + Alt +U:** Unshade all currently shaded windows

### **Mouse Gestures & Window Management (`MouseGestures.ahk`)**
- **Right-click + Drag Down:** Quickly close the current window/tab (sends Ctrl-w)
- **Ctrl + Right-Click:** Toggle window shading (minimize to title bar only)
- **Alt + Esc:** Close active window
- **Always-on-Top Shading:** Shaded window stay on top for easy access

### **Application Launchers (`Launcher.ahk`)**
- **Shift + Ctrl + E:** Launch Microsoft Edge
- **Shift + Ctrl + S:** Launch Slack
- **Shift + Ctrl + T:** Launch PowerShell 7

## **Installation**
1. **Download and install AutoHotKey v2.0 or later**
    - Visit [AutoHotKey](https://autohotkey.com)
    - Download and install AutoHotkey v2.0 or later
2. **Download the Scripts**
   - Download all `.ahk` files from the repository
   - Keep them in the same folder
3. **Run the Main Script**
   - Double-click `Main.ahk` to run the entire set of scripts
   - The script will run in the background (look for the AutoHotKey icon in your system tray)
4. **Optional: Auto-start**
   - Place `Main.ahk` in your Windows Startup folder to run automatically
   - Or create a shortcut in `shell:startup`

## **Script Details**
### **Main.ahk**
The orchestrator script that:
- Includes and coordinates all other modules
- Defines global hotkeys for system control
- Manages the single instance behavior
- Provides the main text expansion functionality

### **MouseGestures.ahk**
- **Right-click Gestures:** Drag down to close windows/tabs
- **Window Shading:** Ctrl+Right-click to minimize windows to title bar
- **Gesture Detection:** Smart detection prevents conflicts with normal right-clicks
- **Window Tracking:** Remembners original dimensions for restoration

### **Launcher.ahk**
Quick application launcher
- **Consistent Hotkeys:** All use Shift+Ctrl+Alt+[Letter] pattern
- **Easy Customization:** Simple to add new application or modify paths

## **Excluded Windows (for shading)**
- Windows taskbar (`Shell_TrayWnd`)
- System control windows (`DV2ControlHost`)
- Desktop worker windows (`WorkerW`)