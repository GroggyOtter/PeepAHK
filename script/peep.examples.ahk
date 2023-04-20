; ===== Examples =====
; All of this demonstrates different aspects of Peep()
; None of it is required for Peep() to operate.
#include peep.ahk

demo()

demo() {
    showcase_options()
    showcase()
}

showcase_options() {
    obj := {key_arr:["alpha", "bravo", "charlie"]
        , key_map: Map("true",1, "false",0, "Jell","O", "Big","Lebowski")
        , key_2x2_matrix:[[1,2],[1,2]]
        , key_literal_obj:{c_to_f:"temp * 9 / 5 + 32", f_to_c:"temp - 32 * 5 / 9"}}
    Peep.ind_type := '    '
    Peep.include_prim_type := 0
    Peep.display_text := -1
    Peep.key_val_inline := 0
    Peep.gui_pause_code := 1
    Peep.include_properties := 1
    
    MsgBox("Property:"
        . "`n`nPeep.ind_type := `"    `""
        . "`n`nDefines a character set for indenting text."
        . "`nThis can be spaces, a tab, or include other chars."
        . "`n4 space = `"    `""
        . "`n1 tab = `"``t`""
        . "`n`nThis is 2 spaces:")
    Peep.ind_type := '  '
    Peep(obj)
    MsgBox("4 spaces:")
    Peep.ind_type := '    '
    Peep(obj)
    MsgBox("You can do different things by adjusting the indent."
        . "`nAdding a pipe as the first char makes lines connecting each element."
        . "`n`nPeep.ind_type := `"|   `""
        . "`n`nUsing a pipe and some dashes produces a grid effect left of the data."
        . "`n`nPeep.ind_type := `"|---`"" )
    Peep.ind_type := '|    '
    Peep(obj)
    
    MsgBox("Property:"
        . "`n`nPeep.include_prim_type := 1"
        . "`n`nThis will include the primitive type next to the value."
        . "`nHere is what it looks like with prim types showing: ")
    Peep.ind_type := '    '
    Peep.include_prim_type := 1
    Peep(obj)
    
    MsgBox("Property:"
        . "`n`nPeep.display_text := 1"
        . "`n`n1 uses the custom built GUI."
        . "`n0 will suspend displaying anything but still returns the text"
        . "`n-1 uses the default message box."
        . "`n`nWe've used messagebox so far."
        . "`nThis is the custom GUI:")
    Peep.include_prim_type := 0
    Peep.display_text := 1
    Peep(obj)
    
    MsgBox("Property:"
        . "`n`nPeep.key_val_inline := 1"
        . "`n`nWhen set to true, keys and their values reside on the same line."
        . "`nThis is what it looks like turned on:")
    Peep.key_val_inline := 1
    Peep(obj)
    
    MsgBox("Property:"
        . "`n`nPeep.gui_pause_code := 0"
        . "`n`nWhen set to true, the flow of code is paused when the custom GUI pops up."
        . "`nThis creates a similar effect to MsgBox() and "
        . " allows Peep() to be used for troubleshooting code."
        . "`nIt has been enabled so far but will be disabled for the next popup."
        . "`nThat means the custom GUI will come up and the next message box will pop up "
        . "immediately after."
        . "`n`nBe careful disabling this property when using Peep() inside a loop/timer as "
        . "it can inadvertently flood your system with GUI windows.")
    Peep.key_val_inline := 0
    Peep.gui_pause_code := 0
    Peep(obj)
    
    MsgBox("(Make sure to read the Peep.gui_pause_code custom GUI pop up before going on.)"
        . "`n`nProperty:"
        . "`n`nPeep.include_properties := 0"
        . "`n`nSetting this to true includes an object's built-in properties and marks them as such."
        . "`nBuilt-in properties are properties provided by the AHK object, such as:"
        . "`n    Array.Length"
        . "`n    Buffer.Ptr"
        . "`n    RegExMatchInfo.Subpatterns"
        . "`n    Etc..."
        . "`n`nThis is with built-in properties disabled and objects should be noticeably shorter:")
    Peep.gui_pause_code := 1
    Peep.include_properties := 0
    Peep(Obj)
    
    MsgBox("Property:"
        . "`n`nPeep.array_values_inline := 1"
        . "`n`nThis forces array values to stay on one line."
        . "`n`nThis is a niche property and should normally be set to false."
        . "`nIf the array contains other objects, it can strongly distort/disfigure the "
        . "text output.")
    Peep.include_properties := 1
    Peep.array_values_inline := 1
    Peep(Obj)
    
    MsgBox("Property:"
        . "`n`nPeep.default_gui_btn := `"resume`""
        . "`n`nSet the default button when using the custom GUI."
        . "`nThis value can be: close resume clipboard" )
    Peep.array_values_inline := 0
    Peep.default_gui_btn := "resume"
    Peep(Obj)
    Peep.default_gui_btn := "close"
    MsgBox("End of options demo.")
}

showcase() {
    ; Primitives
    MsgBox("Showcase of the different types of objects in AHK."
        . "`nStarting with: Primitives")
    AHK := {string:"Hello, world!", integer:1000, float:3.14159}
    Peep(AHK)
    ; obj
    MsgBox("It works with all kinds of different AHK objects:`n    - array `n    - map `n    - buffer"
        . "`n    - class `n    - file `n    - inputhook `n    - menu `n    - menubar `n    - regex"
        . "`n    - error `n    - funcobj `n    - gui `n    - guicontrol `n    - varref")
    
    ; arr
    ahk := {}
    arr := [80, 101, 101, 112, 65, 72, 75]
    arr.default := "Even does array default values!"
    ahk.array := arr
    ; map
    ahk.map := Map("Peep", "AHK")
    ahk.map.default := "Don't forget map default value."
    ; buffer
    ahk.buffer := Buffer(StrPut("Peep(AHK)"), 0)
    ; class
    ahk.class := peep
    ; File
    ahk.file := FileOpen(A_ScriptFullPath, 0)
    Peep(ahk)
    
    MsgBox("But wait, there's more!")
    ; InputHook
    ahk := {}
    ahk.hook := InputHook()
    ; Menu
    ahk.menu := Menu()
    ahk.menubar := MenuBar()
    ; RegEx Obj
    RegExMatch("AHK", "(?<subpattern_firstchar>.)(.)(?'sub_charNum3'.)", &ro)
    ahk.regex := ro
    ; Error
    try throw ValueError("Error message", "Location of error (func/method)", "Extra information")
    catch ValueError as err
    ahk.error := err
    ; FuncObj
    ahk.funcObj := MsgBox.bind("Peep AHK, not neighbors")
    ; Bound Method
    ahk.boundMethod := ObjBindMethod(Peep, "test", "Clever")
    ; GUI / GUI Control
    ahk.gui := Gui()
    ahk.guicontrol := ahk.gui.AddButton("x5 y5 w100 h30")
    ; VarRef
    some_var := 1
    ahk.VarRef := &some_var
    Peep(ahk)
    
    ; Complex test
    MsgBox("A slightly more complex object")
    try 
        throw Error("x", "y", "z")
    catch as err
        y := gui(), y.AddButton, y.AddEdit, y.AddText
    Peep({key1:[{x_value:(x := 0),x_var_ref:&x},{gui_obj:y,gui_var_ref:&y}]
        , key2:Map("map1", Map("Error",err), "map2", Map("color","Green", "smell","Earthy", "strain","kush"))
        , key3:{jenny:8675309}})
    
    MsgBox("This demonstration was made possible by contributions to your PBS station."
        . "`nFrom viewers like you!!")
    MsgBox("No, wait. That's PBS. I don't get anything from them."
        . "`nThat's my bad.`nI mean Big Bird gets a slice but he doesn't bother teaching AHK "
        . "to those little kids. Wasted opportunity and yet they're still cutting him a check.")
    MsgBox("Do I need to point out he's a bird?!"
        . "`nWhere's the otter's check?`nJust b/c I'm groggy doesn't mean I'm not putting in "
        . "the hours like Mr Yellow Bird."
        . "`nNow I see why Oscar is so pissed all the time."
        . "`nDamn bird is always taking the spotlight.")
    MsgBox("In a weird way I really feel for Wile E Coyote right now.`nWhy's the roadrunner "
        . "always gotta win?")
    MsgBox("Sorry for the tangent.`n`nAnyway, hope you enjoyed the showcase/demonstration of Peep()")
}
