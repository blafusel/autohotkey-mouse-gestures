;# = win
;! = alt
;^ = ctrl
;+ = shift

; AUTOHOTKEY
!^+r::Reload ; reload script

; TEXT EXPANSION
::@@::road.runner@acme.org ; expand @@ to email address
#SingleInstance Force

; LAUNCHER
#include Launcher.ahk

; WINDOW MANAGEMENT
!esc::WinClose "A" ; close active window
#include MouseGestures.ahk ; right-click down drag to close window
                           ; ctrl right-click on title bar to shade window
