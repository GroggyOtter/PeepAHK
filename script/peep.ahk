; Peep(AHK)                                                                                         ;
; Created by: GroggyOtter                                                                           ;
; 20230420                                                                                          ;
; Allows you to view the contents of almost any object in AHKv2 (COM objects not supported)         ;
;=====  USAGE  =====================================================================================;
; Use: Pass any variable or object to Peep() to create a visual display of its contents             ;
;      Originally designed for quick troubleshooting while debugging code as it allows you to look  ;
;      at the contents of any object and pause the code as you do so.                               ;
;                                                                                                   ;
;   Example: Peep(varOrObject)                                                                      ;
;                                                                                                   ;
;=====  RETURN  ====================================================================================;
; Returns a string containing the text representation of the provided Object                        ;
;                                                                                                   ;
;=====  PROPERTIES  ================================================================================;
; ind_type [str]            ; Character set to represent each level of indentation                  ;
;       Examples:    "    " ; 4 spaces                                                              ;
;                    "  "   ; 2 spaces                                                              ;
;                    "`t"   ; Tab                                                                   ;
;                    "|   " ; Adds a trailing bar between each indentation level                    ;
;                    "|---" ; Creates a grid effect                                                 ;
;___________________________________________________________________________________________________;
; include_prim_type [bool]  ; If true, includes primitive type next to primitives                   ;
;       Examples:      true ; Hello World <String>                                                  ;
;                     false ; Hello World                                                           ;
;___________________________________________________________________________________________________;
; key_val_inline [bool]     ; If true, values are placed on same line as key.                       ;
;       Examples:      true ; Object{                                                               ;
;                           ;    key: value                                                         ;
;                           ;  }                                                                    ;
;                     false ; Object{                                                               ;
;                           ;   key:                                                                ;
;                           ;       value                                                           ;
;                           ; }                                                                     ;
;___________________________________________________________________________________________________;
; display_text [num]        ; Disables displaying text or sets display type                         ;
;       Examples          0 ; Disables displaying text (text is still returned)                     ;
;                         1 ; Use the custom-built GUI to display the text                          ;
;                        -1 ; Use the default MsgBox() function                                     ;
;___________________________________________________________________________________________________;
; gui_pause_code [bool]     ; If true, code flow pauses when custom GUI shows (similar to MsgBox()) ;
;___________________________________________________________________________________________________;
; include_properties [bool] ; If true, includes the built-in properties of the object               ;
;___________________________________________________________________________________________________;
; default_gui_btn [str]     ; Set the default button when the custom GUI is used                    ;
;                                                                                                   ;
;___________________________________________________________________________________________________;
; array_values_inline [bool]; If true, array values are written inline with no index and object     ;
;                           ; properties are omitted.                                               ;
;                           ; Warning: This can deform output if you have objects inside arraysl    ;
;       Examples:  true     ; myArray[a, b]                                                         ;
;                 false     ; myArray[                                                              ;
;                           ;     1: a                                                              ;
;                           ;     2: b                                                              ;
;                           ; ]                                                                     ;
;___________________________________________________________________________________________________;
;=====  REMARKS  ===================================================================================;
; The "Resume Code" button on the custom GUI unpauses the script but keeps the GUI up.              ;
;     This is only applicable when using the custom gui and gui_pause_code is true.                 ;
; showcase_options() method demonstrates the different effects of each property.                    ;
; showcase() method goes through all the different types of AHK objects.                            ;
; demo() method runs both of the above mentioned methods.                                           ;
;===================================================================================================;

; === Examples ===
; Peep.demo()

class Peep
{
    #Requires AutoHotkey v2.0+
    static version  := "1.0"
    
    ; ===== Custom Properties =====
    static ind_type             := '    '
    static include_prim_type    := 0
    static display_text         := 1
    static key_val_inline       := 1
    static gui_pause_code       := 1
    static include_properties   := 1
    static array_values_inline   := 0
    static default_gui_btn      := "close"
    
    _is_enumerable      := {array:1, map:1, gui:1, regexmatchinfo:1}
    _is_prim            := {float:1, integer:1, number:1, string:1, unset:1}
    _is_valid           := {array:1, boundfunc:1, buffer:1, class:1, error:1, file:1, func:1, gui:1, guicontrol:1, inputhook:1, map:1, menu:1, object:1, prototype:1, regexmatchinfo:1,  varref:1}
    is_enumerable[_type] => this._is_enumerable.HasOwnProp(_type)
    is_prim[_type]       => this._is_prim.HasOwnProp(_type)
    is_valid[_type]      => this._is_valid.HasOwnProp(_type)
    
    props   := {array         :["Length", "Capacity"]
               ,boundfunc     :["Name", "IsBuiltIn", "IsVariadic", "MinParams", "MaxParams"]
               ,buffer        :["Ptr", "Size"]
               ,file          :["Pos", "Length", "AtEOF", "Encoding", "Handle"]
               ,func          :["Name", "IsBuiltIn", "IsVariadic", "MinParams", "MaxParams"]
               ,gui           :["BackColor", "FocusedCtrl", "Hwnd", "MarginX","MarginY", "MenuBar", "Name", "Title"]
               ,guicontrol    :["ClassNN", "Enabled", "Focused", "Gui", "Hwnd","Name", "Text", "Type", "Value", "Visible"]
               ,inputhook     :["EndKey", "EndMods", "EndReason", "InProgress", "Input","Match", "OnEnd", "OnChar", "OnKeyDown", "OnKeyUp","BackspaceIsUndo", "CaseSensitive", "FindAnywhere", "MinSendLevel","NotifyNonText", "Timeout", "VisibleNonText", "VisibleText"]
               ,map           :["Count", "Capacity", "CaseSense"]
               ,menu          :["ClickCount", "Default", "Handle"]
               ,regexmatchinfo:["Pos", "Len", "Count", "Mark"] }
    
    user_settings() {
        str := ""
        for k, v in Peep.OwnProps()
            if (k != "Prototype")
                this._%k% := v
    }
    
    __New(item, opt:="") {
        this.user_settings()
        this.inda := ["", Peep.ind_type]
        if IsSet(item)
            return this.__Call(item, opt)
        else return ";;UNSET"
    }
    
    __Call(item, opt:="") {
        txt := this.checker(item, 1)
        ,txt := Trim(txt, " `t`n`r" Peep.ind_type)
        ,(Peep.display_text > 0) ? this.gui_display(txt)
        :(Peep.display_text < 0) ? MsgBox(txt) : 0 
        return txt
    }
    
    checker(item, ent) {
        _type := !IsSet(item) ? "unset" : Type(item)
        ,gen := InStr(_type, "error") ? "error"
            :   InStr(_type, "gui.")  ? "guicontrol"
            :   InStr(_type, "menu")  ? "menu"
            :   _type
        
        switch {
            case this.is_prim[gen]:  return this.primitive(item, _type)
            case this.is_valid[gen]: return this.extract(item, _type, gen, ent)
            default:                 return MsgBox((txt := "Unsupported Type -> " _type)) ? txt : txt
        }
    }
    
    primitive(prim, _type) {
        return (_type = "unset")      ? ";;UNSET"
            : (prim = "")             ? ";;EMPTY_STR"
            : !Peep.include_prim_type ? prim
            : prim " <" _type ">"
    }
    
    extract(item, _type, gen, ent) {
        ; OPENER
        (Peep.key_val_inline && ent > 1) ? ent-- : 0
        str := _type this.bracket(_type, "o"), ent++
        mid := ""
        
        ; ENUMERABLE
        If this.is_enumerable[_type]
            for k, v in item
                mid .= (Peep.array_values_inline && _type = "array")
                        ? (A_Index > 1 ? ", " : "") this.checker(v, ent+1)
                    : "`n" this.ind(ent) k ":"
                    . (Peep.key_val_inline ? " " : "`n" this.ind(ent+1))
                    . this.checker(v, ent+1)
        
        if (Peep.array_values_inline && _type = "array")
            return str mid "]"
        
        ; OWNPROPS
        if (_type = "VarRef")
            mid .= "`n" this.ind(ent) ";;NO_PROPERTIES"
        else
            for k, v in item.OwnProps()
                mid .= "`n" this.ind(ent) k ":"
                    . (Peep.key_val_inline ? " " : "`n" this.ind(ent+1))
                    . ((k = "Stack" && gen = "error")
                        ? this.checker(stack_indent(v, ent+1), ent+1)
                    : this.checker(v, ent+1) )
        
        ; PROPERTIES
        if (Peep.include_properties && this.props.HasProp(gen)) {
            mid .= "`n" this.ind(ent) "`;;OBJECT_PROPERTIES", ent++
            for i, p in this.props.%gen%
                mid .= "`n" this.ind(ent) p ":"
                    . (Peep.key_val_inline ? " " : "`n" this.ind(ent+1))
                    . (p = "Gui" && gen = "guicontrol"
                        ? item.gui.hwnd ; Return hwnd to avoid recursion
                    : this.checker(item.%p%, ent+1))
            
            ; GUI XYWH 
            If InStr(_type, "gui") {
                item.GetPos(&x, &y, &w, &h)
                for k, v in Map("x",x, "y",y, "width",w, "height",h)
                    mid .= "`n" this.ind(ent) k ":"
                        . (Peep.key_val_inline ? " " : "`n" this.ind(ent+1))
                        . this.checker(v, ent+1)
            }
            ent--
        }
        
        ; CLOSER
        return str mid "`n" this.ind(--ent) this.bracket(_type, "c")
        
        stack_indent(txt, ent) {
            txt := StrReplace(txt, "`n", "`n" this.ind(ent))
            return RTrim(txt, " `t`n`r" Peep.ind_type)
        }
    } 
    
    ind(num) {
        while (this.inda.Length < num)
            this.inda.Push(this.inda[this.inda.Length] Peep.ind_type)
        return this.inda[num]
    }
    
    bracket(_type, oc) {
        return InStr("Object Class Prototype", _type) ? (oc = "o") ? "{" : "}"
            : (_type = "Array") ? (oc = "o") ? "[" : "]"
            : (oc = "o") ? "(" : ")"
    }
    
    static test(*) {
        MsgBox("Test working!")
    }
    
    ; ===== GUI Stuff =====
    make_gui() {
        gw  := 500
        ,gh := 600
        ,m  := 5
        ,bh := 30
        ,bw := 130
        ,edr:= 30
        ,edh:= gh - m*2 - bh
        ,bg_color := 0x101010
        
        ; Gui
            goo := Gui()
            ,goo.MarginX := goo.MarginY := m
            ,goo.BackColor := bg_color
            ,goo.SetFont("s10")
            ,obm := ObjBindMethod(goo, "Destroy")
            ,goo.OnEvent("Close", obm)

        ; Edit box
            opt := " ReadOnly -Wrap +0x300000 -WantReturn -WantTab"
            ,gce := goo.AddEdit("xm ym w" gw-m*2 " r" edr opt)
            ,gce.SetFont("s10 c010101 bold","Consolas")
            ,obm := ObjBindMethod(Peep, "test")
            ,gce.OnEvent("Change", obm)
            ,goo.edit_box := gce
        
        ; Close/resume/clipboard buttons
            btn_arr := [["Close"             ,"xm y+" m "           " ,"destroy"      ,"close"    ]
                       ,["Resume Code"       ,"x" (gw/2 - bw/2) " yp" ,"resume_code"  ,"resume"   ]
                       ,["Save to Clipboard" ,"x" (gw - m - bw) " yp" ,"save_to_clip" ,"clipboard"] ]
            
            for k, v in btn_arr {
                name := v[4]
                ,gcb := goo.AddButton(v[2] " w" bw " h" bh " Center Border 0x200", v[1])
                ,gcb.SetFont("s10 cFFFFFF")
                ,obm := ObjBindMethod(this, v[3])
                ,gcb.OnEnter := obm
                ,gcb.OnEvent("Click", obm)
                ,goo.btn_%name% := gcb
            }
        
        ; Save gui to object
        this.gui := goo
        
        ; Mouse movement event listener
        obm := ObjBindMethod(this, "WM_MOUSEMOVE", )
        ,OnMessage(0x200, obm)
        
        ; Enter/NumpadEnter will activate focused button
        HotIfWinactive("ahk_id " this.gui.hwnd)
        ,obm := ObjBindMethod(this, "enter_pressed")
        ,Hotkey("*Enter", obm)
        ,Hotkey("*NumpadEnter", obm)
        ,HotIf()
    }
    
    gui_display(txt) {
        defbtn := Peep.default_gui_btn
        this.make_gui()
        ,this.gui.edit_box.value := txt
        ,this.gui.show()
        ,(defbtn = "clipboard") ? this.gui.btn_clipboard.Focus()
        : (defbtn = "resume")   ? this.gui.btn_resume.Focus()
        :                         this.gui.btn_close.Focus()
        ,Peep.gui_pause_code ? Pause() : 0
    }
    
    enter_pressed(*) {
        fc := this.gui.FocusedCtrl
        ,fc.HasOwnProp("OnEnter") ? fc.OnEnter.Call() : 0
    }
    
    mouse_up_on_button(hwnd) {
        KeyWait("LButton", "P")
        MouseGetPos(,,,&con,2)
        return (hwnd = con) ? 1 : 0
    }
    
    WM_MOUSEMOVE(wparam, lparam, msg, hwnd) {
        static WM_NCLBUTTONDOWN := 0xA1
        MouseGetPos(,,,&mc)
        ,(wparam = 1) ; && !InStr(mc, "static")) ; Click+Drag functionality
            ? PostMessage(WM_NCLBUTTONDOWN, 2,,, "ahk_id " hwnd) : 0
    }
    
    destroy(*) {
        KeyWait("LButton", "P")
        if A_IsPaused
            this.resume_code()
        this.gui.destroy()
    }
    
    resume_code(*) {
        KeyWait("LButton", "P")
        pause(0)
    }
    
    save_to_clip(*) {
        A_Clipboard := this.gui.edit_box.value
        ,TrayTip("Text copied to clipboard", "Peep(AHK)", 0x10)
    }
    
    ; ===== Examples =====
    static demo() {
        this.showcase_options()
        this.showcase()
    }
    
    static showcase_options() {
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
        MsgBox("And 4 spaces:")
        Peep.ind_type := '    '
        Peep(obj)
        MsgBox("You can do different things by adjusting the indent."
            . "`nAdding a pipe as the first char makes lines connecting each element."
            . "`n`nPeep.ind_type := `"|   `""
            . "`n`nUsing a pipe and some dashes produces a grid effect left of the data."
            . "`n`nPeep.ind_type := `"|---`"" )
        Peep.ind_type := '|    '
        Peep(obj)
        MsgBox("With underscores:"
            . "`nPeep.ind_type := `"____`"")
        Peep.ind_type := "____"
        Peep(obj)
        
        MsgBox("Property:"
            . "`n`nPeep.include_prim_type := 1"
            . "`n`nThis will include the primitive type next to the value."
            . "`nThis is with primitives showing:")
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
            . "`n`nWhen set to true, key's and their values reside on the same line."
            . "`nThis is what it looks like on:")
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
            . "`nArray.Length"
            . "`nBuffer.Ptr"
            . "`nRegExMatchInfo.Subpatterns"
            . "`nEtc..."
            . "`n`nThis is without properties and should be noticeably shorter:")
        Peep.gui_pause_code := 1
        Peep.include_properties := 0
        Peep(Obj)
        
        MsgBox("Property:"
            . "`n`nPeep.array_values_inline := 1"
            . "`n`nThis forces array values to stay on one line."
            . "`n`nThis is a niche property and should normally be set to false."
            . "`nIf the array contains other objects, it can strongly distort/disfigure the "
            . "text output.")
        Peep.include_properties := 0
        Peep.array_values_inline := 1
        Peep(Obj)
        
        MsgBox("Property:"
            . "`n`nPeep.default_gui_btn := `"resume`""
            . "`n`nSet the default button when using the custom GUI."
            . "`nThis value can be: close resume clipboard" )
        Peep.array_values_inline := 0
        Peep.default_gui_btn := "resume"
        Peep(Obj)
        
        MsgBox("End of options demo.")
    }
    
    static showcase() {
        
        ; Primitives
        MsgBox("Showcase of the different types of objects in AHK."
            . "`nStarting with: Primitives")
        AHK := {string:"Hello, world!", integer:1000, float:3.14159}
        Peep(AHK)
        ; obj
        MsgBox("It works with all kinds of different AHK objects:`n-array `n-map `n-buffer"
            . "`n-class `n-file `n-inputhook `n-menu `n-menubar `n-regex"
            . "`n-error `n-funcobj `n-gui `n-guicontrol `n-varref")
        
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
        ahk.file := FileOpen(A_ScriptDir "\Peep.v2.ahk", 0)
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
        try throw Error("x", "y", "z")
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
        MsgBox("Anyway, hope you enjoyed the showcase/demonstration of Peep()")
    }
}
