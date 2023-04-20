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
; Returns a Peep object                                                                             ;
; The formatted text can be found in the .value property                                            ;
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
; add_string_quotes [bool]  ; If true, string primitives have quotation marks around them.          ;
;       Examples:      true ; "Some string"                                                         ;
;                     false ; Some string                                                           ;
;___________________________________________________________________________________________________;
; include_properties [bool] ; If true, includes the built-in properties of the object               ;
;___________________________________________________________________________________________________;
; display_text [num]        ; Disables displaying text or sets display type                         ;
;       Examples:         0 ; Disables displaying text (object is still returned)                   ;
;                         1 ; Use the custom-built GUI to display the text                          ;
;                        -1 ; Use the default MsgBox() function                                     ;
;___________________________________________________________________________________________________;
; gui_pause_code [bool]     ; If true, code flow pauses when custom GUI shows (similar to MsgBox()) ;
;___________________________________________________________________________________________________;
; disable_gui_escape [bool] ; If true, disables the "escape closes custom gui" hotkey               ;
;___________________________________________________________________________________________________;
; default_gui_btn [str]     ; Set the default button when the custom GUI is used                    ;
;___________________________________________________________________________________________________;
; array_values_inline [bool]; If true, array values are written inline with no index and object     ;
;                           ; properties are omitted.                                               ;
;                           ; WARNING: This can mangle output if you have objects inside arrays     ;
;       Examples:     true  ; myArray[a, b]                                                         ;
;                    false  ; myArray[                                                              ;
;                           ;     1: a                                                              ;
;                           ;     2: b                                                              ;
;                           ; ]                                                                     ;
;___________________________________________________________________________________________________;
;=====  REMARKS  ===================================================================================;
; The "Resume Code" button on the custom GUI unpauses the script but keeps the GUI up.              ;
;     This is only applicable when using the custom gui and gui_pause_code is true.                 ;
;===================================================================================================;

class Peep
{
    #Requires AutoHotkey 2.0+
    static version  := "1.0"
    
    ; ===== Custom Properties ============
    static ind_type             := '    '
    static include_prim_type    := 0
    static key_val_inline       := 1
    static add_string_quotes    := 1
    static include_properties   := 1
    static display_text         := 1
    static gui_pause_code       := 1
    static disable_gui_escape   := 0
    static default_gui_btn      := "close"
    static array_values_inline  := 0
    ; ====================================
    
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
    
    ind_type {
        get => Peep.ind_type
        set => Peep._ind_type := (StrLen(value) > 0) ? value : "    "
    }
    
    include_prim_type {
        get => Peep.include_prim_type
        set => Peep._include_prim_type := (value) ? 1 : 0
    }
    
    display_text {
        get => Peep.display_text
        set => Peep._display_text := (value > 0) ? 1 : (value = 0) ? 0 : -1
    }
    
    key_val_inline {
        get => Peep.key_val_inline
        set => Peep._key_val_inline := (value) ? 1 : 0
    }
    
    gui_pause_code {
        get => Peep.gui_pause_code
        set => Peep.gui_pause_code := (value) ? 1 : 0
    }
    
    include_properties {
        get => Peep.include_properties
        set => Peep._include_properties := (value) ? 1 : 0
    }
    
    array_values_inline {
        get => Peep.array_values_inline
        set => Peep._array_values_inline := (value) ? 1 : 0
    }
    
    add_string_quotes {
        get => Peep.add_string_quotes
        set => Peep._add_string_quotes := (value) ? 1 : 0
    }
    
    default_gui_btn {
        get => Peep.default_gui_btn
        set => Peep._default_gui_btn := InStr(value, "clip") ? "clipboard"
                                      : InStr(value, "res") ? "resume" : "close"
    }
    
    disable_gui_escape {
        get => Peep.disable_gui_escape
        set => Peep._disable_gui_escape := (value) ? 1 : 0
    }
    
    __New(item, opt:="") {
        this.inda := ["", Peep.ind_type]
        this.value := ""
        if !IsSet(item)
            this.value := "<UNSET>"
        this.value := this.__Call(item, opt)
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
        
        return this.is_prim[gen]
            ? this.primitive(item, _type)
            : this.extract(item, _type, gen, ent)
        
        ; switch {
        ;     case this.is_prim[gen]:  return this.primitive(item, _type)
        ;     default:                 return this.extract(item, _type, gen, ent)
        ; }
    }
    
    primitive(prim, _type) {
        (_type = "string" && this.add_string_quotes) ? prim := '"' prim '"' : 0
        return (_type = "unset")      ? "<UNSET>"
            : (prim = "")             ? "<EMPTY_STR>"
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
            mid .= "`n" this.ind(ent) "<NO_PROPERTIES>"
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
                    . (p = "Gui" && gen = "guicontrol" ? item.gui.hwnd ; Return hwnd to avoid recursion
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
        ,happy:=420
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
        ; Escape closes gui
        If !(this.disable_gui_escape)
            obm := ObjBindMethod(this, "destroy")
            ,Hotkey("*Escape", obm)
        HotIf()
    }
    
    gui_display(txt) {
        this.make_gui()
        ,this.gui.edit_box.value := txt
        ,this.gui.show()
        switch Peep.default_gui_btn {
            case "clipboard": this.gui.btn_clipboard.Focus()
            case "resume": this.gui.btn_resume.Focus()
            default: this.gui.btn_close.Focus()
        }
        (Peep.gui_pause_code) ? Pause() : 0
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
}
