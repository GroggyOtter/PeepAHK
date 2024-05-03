/**
 * @description {@link https://github.com/GroggyOtter/PeepAHK/|`Peep()`}
 * A callable class that will display the contents of any amount of objects/variables/items.  
 * @file Peep.v2.ahk
 * @author GroggyOtter
 * @date 2024/03/28
 * @version 1.3
 * @property {Integer} dark_mode  
 * - `true` = [Default] Use a dark colored theme.
 * - `false` = Use a light colored theme.
 * @property {String} indent_str  
 * The character set to use for each level of indentation.  
 * Spaces or tabs are commonly used.  
 * [Default]: 4 spaces  
 * @property {String} unset_value  
 * String to use when an {@link https://www.autohotkey.com/docs/v2/Language.htm#unset|unset value} is encountered.  
 * [Default]: `<UNSET>`
 * @property {String} var_ref_value  
 * String to use when a {@link https://www.autohotkey.com/docs/v2/Concepts.htm#variable-references|VarRef} is encountered.  
 * [Default]: `<VAR_REF>`
 * @property {String} duplicate_ref  
 * String to use when a duplicate reference is encountered.  
 * Default value: `<DUPLICATE_REF>`
 * @property {Integer} include_prim_type  
 * - `true` = Show a primitive value's type next to the value.  
 * - `false` = [Default] Show only the value.  
 * @property {Integer} include_string_quotes  
 * - `Positive number` = Strings will have double quotes around them.  
 * - `Negative number` = Strings will have single quotes around them.  
 * - `0` = [Default] Strings are shown as they're stored.  
 * @property {Integer} include_end_commas  
 * - `true` = [Default] A comma is used to separate items.  
 *   The last item (or single items) do not have a comma after them.   
 * - `false` =  Commas are not included between items.  
 *   This works well when key_value_inline is set to false.  
 * @property {Integer} include_array_index  
 * - `true` = Array items will include their index number before each value, starting at 1.  
 * - `false` = [Default] Array index is not included and only values are shown.  
 * @property {Integer} include_built_in  
 * - `true` = [Default] All native AHK objects will include their built-in AHK properties.  
 * - `false` = Built-in properties will not be included.  
 * @property {Integer} array_values_inline  
 * - `true` = Display array values on them same line.  
 *   Requires no objects to be in the array, `include_built_in` must be false, and the array must not have any own properties.  
 * - `false` = [Default] Array values are listed on individual lines.  
 * @property {Integer} key_value_inline  
 * - `true` = [Default] Keys and values will be displayed on the same line.  
 * - `false` = Keys and values are shown on separate lines and values are indented one additional level.  
 * @property {Integer} indent_closing_tag  
 * - `true` = Closing object tags are indented one additional level to align them with object keys/values.  
 * - `false` = [Default] Closing object tags are aligned with the line containing the opening tag.  
 * @property {Integer} gui_pauses_code  
 * - `true` = [Default] Code execution will pause when the Peep() GUI is shown. This acts similarly to how MsgBox() works.  
 *   Code is resumed when Continue or Unpause is clicked.
 * - `false` = Code execution continues immediately after displaying the Peep() GUI.
 * @property {Integer} disable_gui_escape  
 * - `true` = Pressing escape when the GUI is active will have no effect.  
 * - `false` = [Default] Pressing escape when the GUI is active acts the same as clicking the "Continue" button.  
 * @property {Integer} display_with_gui  
 * - `Positive number` = [Default] Use the built-in GUI to display Peep() information.  
 * - `Negative number` = Use AHK's {@link https://www.autohotkey.com/docs/v2/lib/MsgBox.htm|MsgBox()} to display Peep() information.  
 * - `0` = [Default] No information is displayed but a Peep object is returned. The text can be retrieved by calling it.  
 * 
 *     peep_obj := Peep(data)
 *     MsgBox(peep_obj())
 * @property {String} default_gui_btn  
 * Sets the default focused button when the GUI is shown.  
 * This is also the button that is activated when the Edit box has focus and "Enter" is pressed.  
 * This value can be one of the following values:  
 * - `continue` or `resume` = Closes the GUI and unpauses if script is paused state.  
 * - `reload` = Reloads the current running script. Useful when testing quick changes to a script.  
 * - `exit` = Closes the current running script.  
 * - `clipboard` = Save the displayed text to the clipboard.  
 * - `unpause` = Unpauses the script if it's currently in a paused state. The GUI will remain visible.
 * 
 * Default value: 'Close'
 * @property {Number} gui_w  
 * The default starting width of the GUI.  
 * Default: 600
 * @property {Number} gui_h  
 * The default starting height of the GUI.  
 * Default: 1000
 * @property {Number} gui_x  
 * The default starting width for the GUI.  
 * Default: A_ScreenWidth / 2 - (Peep.gui_w/2)
 * @property {Number} gui_y  
 * The default starting height for the GUI.  
 * Default: A_ScreenHeight / 2 - (Peep.gui_h/2)
 * @returns {Peep}
 * A Peep object is always returned.  
 * The Peep text can be retrieved by calling the returned object or accessing the `Text` property.  
 * 
 *     item := [1,2,3]
 *     pobj := Peep(item)
 *     MsgBox(pobj())
 *     Msgbox(pobj.Text)
 * @example <caption>Multiple Peep() examples.</caption>
 * #Include Peep.v2.ahk
 * 
 * goo := Gui(), goo.AddButton(), goo.AddCheckBox()
 * item := Map(
 *     'gui'   , goo,
 *     'err'   , Error('Message', A_ThisFunc, 'ExtraInfoGoesHere')
 *     'obj'   , {prop_int: 100, prop_float: 3.14, prop_str: 'Hello', propr_unset:unset},
 *     'matrix', [[1,2,3],[4,5,6],[7,8,9]],
 *     'map'   , Map('a','alpha', 'b','beta', 'c','charlie')
 * )
 * peepobj := Peep(item)
 * ; To view peep text again, call the returned object.
 * MsgBox(peepobj())
 */
class Peep {
    #Requires AutoHotkey 2.0.12+
    static version := '1.2'
    
    ; ====================================
    ; User settings
    ; ====================================
    /** @prop {Integer} dark_mode  
     * If true, a dark (black) colored GUI theme is used.  
     * If false, a light (white) colored GUI theme is used.  
     * Deafult is: 1
     */
    static dark_mode := 1
    
    ; Identifying values
    /** @prop {String} indent_str  
     * The character set to use for each level of indentation.
     * Default is 4 spaces.
     */
    static indent_str := '    '
    /** @prop {String} unset_value  
     * The indentifier used for unset values.  
     * Deafult is: <UNSET>
     */
    static unset_value := '<UNSET>'
    /** @prop {String} var_ref_value  
     * The indentifier used for variable reference values.  
     * Deafult is: <VAR_REF>
     */
    static var_ref_value := '<VAR_REF>'
    /** @prop {String} duplicate_ref_value  
     * The indentifier used for any object that has already been referenced.  
     * Deafult is: <DUPLICATE_REF>
     */
    static duplicate_ref_value := '<DUPLICATE_REF>'
    
    ; Include items
    /** @prop {Integer} include_prim_type  
     * If true, primitive types are inclueded next to their values.  
     * Deafult is: 1
     */
    static include_prim_type := 0
    /** @prop {Integer} include_string_quotes  
     * If set to a positive number, strings will have double quotes around them.  
     * If set to a negative number, strings will have single quotes around them.  
     * If set to zero, strings do not have any additional quotes put around them.  
     * Default is: 0
     */
    static include_string_quotes := 0
    /** @prop {Integer} include_end_commas  
     * If true, a comma separates multiple items. The last item of an item set does not have a comma after it.  
     * Default is: 1
     */
    static include_end_commas := 1
    /** @prop {Integer} include_array_index  
     * If true, array items will include their index number before each item, starting at 1.  
     * Default is: 0
     */
    static include_array_index := 0
    /** @prop {Integer} include_built_in  
     * If true, all native AHK objects will include their AHK assigned properties.  
     * Default is: 1
     */
    static include_built_in := 1
    
    ; Data alignment
    /** @prop {Integer} array_values_inline  
     * If true, arrays that don't contain objects are shown on one line.  
     * In addition, the `include_built_in` property must be false and the array can't contain any own properties.  
     * Default is: 0
     */
    static array_values_inline := 0
    /** @prop {Integer} key_value_inline  
     * If true, keys and values will be displayed on the same line.  
     * If false, keys and values are shown separate lines and values are indented one additional level.  
     * Default is: 1
     */
    static key_value_inline := 1
    /** @prop {Integer} indent_closing_tag  
     * If true, closing object tags are indented one additional level to align them with object keys/values.  
     * If false, closing object tags are aligned with the line containing the opening tag.  
     * Default is: 0
     */
    static indent_closing_tag := 0
    
    ; GUI stuff
    /** @prop {Integer} gui_pauses_code  
     * If true, code execution will pause when the Peep() GUI is shown. This acts similarly to how {@link https://www.autohotkey.com/docs/v2/lib/MsgBox.htm|MsgBox()} works.  
     * If false, code execution continues immediately after displaying the Peep() GUI.
     * Default is: 1
     */
    static gui_pauses_code := 1
    /** @prop {Integer} disable_gui_escape  
     * If true, pressing escape has no effect when the GUI is the active window.  
     * If false, pressing escape when the GUI is active will close the gui and unpause the script if it's paused.  
     * Default is: 0
     */
    static disable_gui_escape := 0
    /** @prop {Integer} display_with_gui  
     * If set to a positive number, Peep's custom GUI is used to display information.  
     * If set to a negative number, the standard MsgBox() is used.  
     * If set to zero, nothing is displayed. A Peep object is still returned for text retrieval. 
     * Default is: 1
     */
    static display_with_gui := 1
    /** @prop {String} default_gui_btn  
     * Sets the default button to focus on GUI display.  
     * This is also the button that will be activated when the Edit box has focus and enter is pressed.  
     * - `continue` or `resume` = Closes the GUI and unpauses if script is paused state.  
     * - `reload` = Reloads the current running script. Useful when testing quick changes to a script.  
     * - `exit` = Closes the current running script.  
     * - `clipboard` = Save the displayed text to the clipboard.  
     * - `unpause` = Unpauses the script if it's currently in a paused state. The GUI will remain visible.
     * 
     * Default is: resume
     */
    static default_gui_btn := 'resume'
    
    ; Starting GUI size/position
    /** @prop {Number} gui_w  
     * The default starting width for the GUI.
     * Default is: 600
     */
    static gui_w := 600
    /** @prop {Number} gui_h  
     * The default starting height for the GUI.
     * Default is: 1000
     */
    static gui_h := 1000
    /** @prop {Number} gui_x  
     * The default starting X coordinate.  
     * This is the x value of the upper left corner.  
     * Default is: A_ScreenWidth / 2 - (Peep.gui_w/2)
     */
    static gui_x := A_ScreenWidth / 2 - (Peep.gui_w/2)
    /** @prop {Number} gui_y  
     * This is the y value of the upper left corner.  
     * Default is: A_ScreenHeight / 2 - (Peep.gui_h/2)
     */
    static gui_y := A_ScreenHeight / 2 - (Peep.gui_h/2)
    
    /**
     * @description Resets all the properties to default values.
     */
    static reset_to_default() {
        this.dark_mode := 1
        this.indent_str := '    '
        this.duplicate_ref_value := '<DUPLICATE_REF>'
        this.unset_value := '<UNSET>'
        this.var_ref_value := '<VAR_REF>'
        this.array_values_inline := 0
        this.include_prim_type := 0
        this.include_string_quotes := 0
        this.include_end_commas := 1
        this.include_array_index := 0
        this.include_built_in := 1
        this.key_value_inline := 1
        this.indent_closing_tag := 0
        this.gui_pauses_code := 1
        this.disable_gui_escape := 0
        this.display_with_gui := 1
        this.default_gui_btn := 'resume'
        this.gui_x := A_ScreenWidth / 2 - (Peep.gui_w/2)
        this.gui_y := A_ScreenHeight / 2 - (Peep.gui_h/2)
        this.gui_h := 1000
        this.gui_w := 600
    }
    
    /**
     * @description Retrieves the generated text.  
     * @type {String}
     * @example
     * #Include Peep.v2.ahk
     * arr := [1,2,3]
     * pobj := Peep(arr)
     * MsgBox(pobj.text)
     */
    text := ''
    
    /**
     * @description Retrieves the generated text.
     * @return {String}
     * @example
     * #Include Peep.v2.ahk
     * arr := [1,2,3]
     * pobj := Peep(arr)
     * MsgBox(pobj())
     */
    __Call() => this.text
    
    ; ====================================
    ; Internal stuff
    ; ====================================
    static __New() {
        props := Map()
        props.CaseSense := 0
        props.Set(
            'Array',             ['Length', 'Capacity', 'Default'],
            'Buffer',            ['Ptr', 'Size'],
            'ClipboardAll',      ['Ptr', 'Size'],
            'Error',             ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'MemoryError',       ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'OSError',           ['Message', 'Number', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'TargetError',       ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'TimeoutError',      ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'TypeError',         ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'UnsetError',        ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'MemberError',       ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'PropertyError',     ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'MethodError',       ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'UnsetItemError',    ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'ValueError',        ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'IndexError',        ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'ZeroDivisionError', ['Message', 'What', 'Extra', 'File', 'Line', 'Stack'],
            'File',              ['Pos', 'Length', 'AtEOF', 'Encoding', 'Handle'],
            'Func',              ['Name', 'IsBuiltIn', 'IsVariadic', 'MinParams', 'MaxParams'],
            'BoundFunc',         ['Name', 'IsBuiltIn', 'IsVariadic', 'MinParams', 'MaxParams'],
            'Closure',           ['Name', 'IsBuiltIn', 'IsVariadic', 'MinParams', 'MaxParams'],
            'Enumerator',        ['Name', 'IsBuiltIn', 'IsVariadic', 'MinParams', 'MaxParams'],
            'Gui',               ['BackColor', 'FocusedCtrl', 'Hwnd', 'MarginX', 'MarginY', 'MenuBar', 'Name', 'Title'],
            'Gui.Control' ,      ['ClassNN', 'Enabled', 'Focused', 'Gui', 'Hwnd', 'Name', 'Text', 'Type', 'Value', 'Visible'],
            'InputHook',         ['EndKey', 'EndMods', 'EndReason', 'InProgress', 'Input', 'Match', 'OnEnd', 'OnChar', 'OnKeyDown', 'OnKeyUp', 'BackspaceIsUndo', 'CaseSensitive', 'FindAnywhere', 'MinSendLevel', 'NotifyNonText', 'Timeout', 'VisibleNonText', 'VisibleText'],
            'Map',               ['Count', 'Capacity', 'CaseSense', 'Default'],
            'Menu',              ['ClickCount', 'Default', 'Handle'],
            'MenuBar',           ['ClickCount', 'Default', 'Handle'],
            'RegExMatchInfo',    ['Pos', 'Len', 'Count', 'Mark']
        )
        this.props := props
    }

    static btn_data := [
        Map('call','resume'         ,'id','btn_resume'         ,'txt' ,'Continue'         ),
        Map('call','unpause'        ,'id','btn_unpause'        ,'txt' ,'Unpause Code'     ),
        Map('call','reload_script'  ,'id','btn_reload_script'  ,'txt' ,'Reload Script'    ),
        Map('call','save_to_clip'   ,'id','btn_save_to_clip'   ,'txt' ,'Copy to Clipboard'),
        Map('call','exit'           ,'id','btn_exit'           ,'txt' ,'Exit Script'      )
    ]
    
    static is_com_type(item) {
        switch Type(item), 0 {
            case 'ComObjArray' : return 1
            case 'ComObject'   : return 1
            case 'ComValue'    : return 1
            case 'ComValueRef' : return 1
            default: return 0
        }
    }
    
    static is_enumerable(item) => item.HasMethod('__Enum') ? 1 : 0
    reference_arr := Map()
    
    __New(items*) {
        if (items.length < 1) {
            MsgBox('No items were provided to Peep()')
            return ''
        }
        ; Used to prevent circular references
        this.reference_arr := Map()
        ; Loop through each item provided and generate text
        txt := ''
        for value in items {
            if (items.length > 1)
                txt .= ';;;;;;;;;;;;;;; Item ' A_Index ' Start `;;;;;;;;;;;;;;;`n'
            if IsSet(value)
                txt .= this.extract(value, '')
            else txt .=  Peep.unset_value1
            txt .= "`n`n"
        }
        txt := Trim(txt, '`n') '`n'
        ; Display text
        if (Peep.display_with_gui > 0)
            this.gui_display(txt)
        else if (Peep.display_with_gui < 0)
            MsgBox(txt)
        
        ; Save text for later access
        this.text := txt
    }
    
    extract(item, ind) {
        ; Unset value checker
        if !IsSet(item)
            return Peep.unset_value
        
        item_type := Type(item)
        data := ''
        
        switch {
            ; Primitive values
            case (item is Primitive):
                if Peep.include_prim_type
                    data .= '<' StrUpper(item_type) '> '
                if (item_type = 'String')
                    if (Peep.include_string_quotes > 0)
                        data .= '"' item '"'
                    else if (Peep.include_string_quotes < 0)
                        data .= "'" item "'"
                    else data .= item
                else data .= item
                return data
            ; Var Refs
            case (item is VarRef):
                return Peep.var_ref_value
            ; COM values
            case Peep.is_com_type(item_type):
                return 'COM: ' item_type
            ; Prototype skipping
            case (item_type = 'Prototype'):
                return '<PROTOTYPE>'
            ; Duplicate detection
            case ((item is Object) && this.is_duplicate(item)):
                return Peep.duplicate_ref_value '<Type: ' item_type '>'
            ; The "I f*@ked up" clause
            case !IsObject(item):
                return MsgBox('GroggyOtter didn`'t account for this.'
                    '`nVisit the Peep() GitHub page and let him know '
                    'know he missed something up. The item type is:`n' item_type)
        }
        
        ind2 := ind Peep.indent_str
        ind3 := ind2 Peep.indent_str
        
        ; Handle built-in props and own props
        if Peep.include_built_in
            built_in := this.add_built_in(item, item_type, ind2)
        else built_in := ''
        own_props := this.add_own_props(item, item_type, ind2)
        
        ; Data extraction
        switch {
            ; Assemble array data
            case (item is Array):
                not_inline := (Peep.include_built_in || !Peep.array_values_inline || own_props != '' || !this.all_elements_are_prim(item))
                header := item_type '['
                for index, value in item {
                    if not_inline {
                        if Peep.include_array_index
                            if Peep.key_value_inline
                                data .= '`n' ind2 index ': '
                            else data .= '`n' ind2 index ': `n' ind3
                        else if Peep.key_value_inline
                            data .= '`n' ind2
                        else data .= '`n' ind2
                    }
                    if IsSet(value)
                        if Peep.key_value_inline
                            data .= StrReplace(this.Extract(value, ind), '`n', '`n' ind2)
                        else data .= StrReplace(this.Extract(value, ind), '`n', '`n' ind3)
                    else data .= Peep.unset_value
                    if Peep.include_end_commas
                        data .= ', '
                }
                this.trim_end_comma(data)
                if not_inline
                    end_cap := '`n' ind
                        . (Peep.key_value_inline ? '' : ind)
                        . (Peep.indent_closing_tag ? ind2 : '')
                        . ']'
                else end_cap := ']'
            
            ; Get GUI including controls
            case (item is Gui):
                header := item_type '(' (item.Name = '' ? 'HWND:' item.hwnd : 'NAME: ' item.Name) '){'
                for hwnd, control in item {
                    if Peep.key_value_inline
                        data .= '`n' ind2 'Gui.' control.Type '{'
                        , Peep.include_built_in
                            ? data .= this.add_built_in(control, 'Gui.Control', ind3, 1)
                            : ''
                        , o := this.add_own_props(control, 'Gui.' control.Type, ind3)
                    else
                        data .= '`n' ind2 'Gui.' control.Type '{'
                        ,data .= this.add_built_in(control, 'Gui.Control', ind3, 1)
                        ,o := this.add_own_props(control, 'Gui.' control.Type, ind3)
                    
                    if (o != '')
                        data .= '`n' ind3 o
                    
                    data .= '`n' ind2
                        . (Peep.key_value_inline ? '' : ind)
                        . (Peep.indent_closing_tag ? ind2 : '')
                        . '}'
                    if Peep.include_end_commas
                        data .= ', '
                }
                this.trim_end_comma(data)
                end_cap := '`n'
                    . (Peep.key_value_inline ? '' : ind)
                    . (Peep.indent_closing_tag ? ind2 : '')
                    . '}'
                if Peep.include_end_commas
                    data .= ', '
            
            ; Individual gui controls
            case (item is Gui.Control):
                header := item_type '{'
                
                data .= Peep.include_built_in ? this.add_built_in(item, 'Gui.Control', ind2) : ''
                o := this.add_own_props(item, item_type, ind2)
                if (o != '')
                    data .= '`n' ind2 o
                
                data .= '`n' ind2
                    . (Peep.key_value_inline ? '' : ind)
                    . (Peep.indent_closing_tag ? ind2 : '')
                    . '}'
                if Peep.include_end_commas
                    data .= ', '

                end_cap := '`n'
                    . (Peep.key_value_inline ? '' : ind)
                    . (Peep.indent_closing_tag ? ind2 : '')
                    . '}'
                if Peep.include_end_commas
                    data .= ', '
                this.trim_end_comma(data)

            ; Get items from enumerable objects
            case Peep.is_enumerable(item):
                header := item_type (item is map ? '(' : '{')
                for key, value in item {
                    data .= '`n' ind2 key ': '
                    if !Peep.key_value_inline
                        data .= '`n' ind3
                    if IsSet(value)
                        if Peep.key_value_inline
                            data .= StrReplace(this.Extract(value, ind), '`n', '`n' ind2)
                        else data .= StrReplace(this.Extract(value, ind), '`n', '`n' ind3)
                    else data .= Peep.unset_value
                    if Peep.include_end_commas
                        data .= ', '
                }
                this.trim_end_comma(data)
                end_cap := '`n'
                    . (Peep.key_value_inline ? '' : ind)
                    . (Peep.indent_closing_tag ? ind2 : '')
                    . (item is map ? ')' : '}')
            ; The mighty catch-all
            default:
                header := item_type '{'
                end_cap := '`n' ind
                    . (Peep.key_value_inline ? '' : ind)
                    . (Peep.indent_closing_tag ? ind2 : '')
                    . '}'
        }
        
        data := this.trim_end_comma(data)
        
        ; Remove blank lines that might appear at the top/bottom of the data
        ; Build result
        if (built_in)
            data .= (data = '') ? built_in : '`n' ind2 built_in
        if (own_props)
            data .= (data = '') ? own_props : '`n' ind2 own_props
        txt .= header . data . end_cap
        
        return Trim(txt, '`n`r')
    }
    
    trim_end_comma(str) => RTrim(str, ', ')
    
    add_built_in(item, typ, ind, is_gui_con:=0) {
        if !Peep.props.Has(typ)
            return ''
        
        ind2 := ind Peep.indent_str
        header := '`n' ind '`;; BUILT-IN PROPERTIES ('
            . (typ = 'Gui.Control' ? 'Gui.' item.Type : typ)
            . ') `;;'
        str := ''
        if is_gui_con
            typ := 'Gui.Control'
        for k, prop in Peep.props[typ] {
            if !item.HasProp(prop)
                continue
            str .= '`n' ind prop ': '
            if Peep.key_value_inline
                str .= StrReplace(this.Extract(item.%prop%, ind), '`n', '`n' ind)
            else str .= '`n' ind2
                , str .= StrReplace(this.Extract(item.%prop%, ind), '`n', '`n' ind2)
            if Peep.include_end_commas
                str .= ', '
        }
        if (str = '')
            return str
        return this.trim_end_comma(header str)
    }
    
    add_own_props(item, typ, ind) {
        header := '`n' ind '`;; OWN PROPERTIES (' typ ') `;;'
        str := ''
        ind2 := ind Peep.indent_str
        if !item.HasMethod('OwnProps')
            return ''
        for key, value in item.OwnProps() {
            str .= '`n' ind
                . (key is Primitive ? key : '[Key Item Object] ' Type(item)) ': '
            if !Peep.key_value_inline
                str .= '`n' ind2
            if Peep.key_value_inline
                str .= StrReplace(this.extract(value, ind), '`n', '`n' ind)
            else str .= StrReplace(this.extract(value, ind), '`n', '`n' ind2)
            if Peep.include_end_commas
                str .= ', '
        }
        if (str = '')
            return ''
        return this.trim_end_comma(header str)
    }
    
    all_elements_are_prim(item) {
        for value in item
            if (IsSet(value) && !(value is Primitive))
                return 0
        return 1
    }
    
    is_duplicate(value) {
        if this.reference_arr.Has(value)
            return 1
        this.reference_arr[value] := 1
        return 0
    }
    
    reload_script(*) => Reload()
    
    ; ===== GUI Stuff =====
    make_gui() {
        gw          := Peep.gui_w
        gh          := Peep.gui_h
        m           := 5
        bh          := 40
        bw          := (gw - m * (Peep.btn_data.Length + 1)) / Peep.btn_data.Length
        edw         := gw - m * 2
        edh         := gh - m * 3 - bh
        bg_color    := Peep.dark_mode ? '101010' : 'F0F0F0'
        font_color  := Peep.dark_mode ? 'D8D8D8' : '101010'
        happy       := 420
        
        ; Gui
        goo := Gui('+Resize -DPIScale +MinSize400x200', 'Peep()', this)
        goo.btn_h := bh
        goo.MarginX := goo.MarginY := m
        goo.BackColor := '0x' bg_color
        goo.SetFont('s10')
        callback := ObjBindMethod(this, 'resume')
        goo.OnEvent('Close', callback)
        goo.OnEvent('Size', 'gui_resize')
        
        ; Edit box
        opt := ' ReadOnly -Wrap +0x300000 -WantReturn -WantTab'
        gce := goo.AddEdit('xm ym w' gw-m*2 ' h' edh opt ' +Background' bg_color ' vedt_main')
        gce.SetFont('s10 bold c' font_color,'Consolas')
        
        ; Close/resume/clipboard buttons
        for k, btn in Peep.btn_data {
            x := (A_Index = 1 ? ' xm ' : ' x+m ')
            y := (A_Index = 1 ? ' y+m ' : ' yp ')
            con := goo.AddButton(x y 'w' bw ' h' bh ' Center Border 0x200 v' btn['id'], btn['txt'])
            con.Call := ObjBindMethod(this, btn['call'])
            con.position_number := A_Index - 1
            con.SetFont('s10 c' font_color)
            con.OnEvent('Click', btn['call'])
        }
        
        ; Save gui to object
        this.gui := goo
        
        ; Mouse movement event listener
        WM_MOUSEMOVE := 0x0200
        callback := ObjBindMethod(this, 'WM_MOUSEMOVE')
        OnMessage(WM_MOUSEMOVE, callback)
        
        ; Window Movement Listener
        WM_MOVE := 0x0003
        callback := ObjBindMethod(this, 'WM_MOVE')
        OnMessage(WM_MOVE, callback)
        
        ; Enter/NumpadEnter will activate focused button
        HotIfWinActive('ahk_id ' this.gui.hwnd)
        callback := ObjBindMethod(this, 'enter_pressed')
        Hotkey('*Enter', callback)
        Hotkey('*NumpadEnter', callback)
        
        ; Escape closes gui
        If !(Peep.disable_gui_escape)
            callback := ObjBindMethod(this, 'gui_escape')
            ,Hotkey('*Escape', callback)
        
        HotIf()
    }
    
    gui_escape(*) {
        If WinActive('A') = this.gui.hwnd
            this.resume(this.gui)
    }
    
    gui_resize(goo, *) {
        goo.GetClientPos(,, &gui_w, &gui_h)
        pad := goo.MarginX
        bh := goo.btn_h
        by := gui_h - pad - bh
        bw := (gui_w - pad * (Peep.btn_data.Length + 1)) / Peep.btn_data.Length
        for control in goo
            switch control.Type {
                case 'Button':
                    bn := control.position_number
                    bx := pad + (bw + pad) * bn
                    control.Move(bx, by, bw, bh)
                case 'Edit':
                    eh := gui_h - bh - pad * 3 
                    ew := gui_w - pad * 2
                    control.Move(pad, pad, ew, eh)
            }
        this.update_gui_pos()
    }
    
    gui_display(txt) {
        this.make_gui()
        this.gui['edt_main'].value := txt
        this.gui.show('x' Peep.gui_x ' y' Peep.gui_y ' w' Peep.gui_w ' h' Peep.gui_h)
        control := this.get_default_gui_btn()
        this.gui[control].Focus()
        if Peep.gui_pauses_code
            Pause()
    }
    
    get_default_gui_btn() {
        name := Peep.default_gui_btn
        return InStr(name, 'res')  ? 'btn_resume'
            :  InStr(name, 'cont') ? 'btn_resume'
            :  InStr(name, 'pau')  ? 'btn_unpause'
            :  InStr(name, 'rel')  ? 'btn_reload_script'
            :  InStr(name, 'clip') ? 'btn_save_to_clip'
            :  InStr(name, 'ex')   ? 'btn_exit'
            :                        'btn_resume'
    }
    
    WM_MOVE(wparam, lparam, msg, hwnd) {
        try this.update_gui_pos()
    }
    
    WM_MOUSEMOVE(wparam, lparam, msg, hwnd) {
        static WM_NCLBUTTONDOWN := 0xA1
        MouseGetPos(,,, &mc)
        try if (wparam = 1 && WinActive(this.gui))
            PostMessage(WM_NCLBUTTONDOWN, 2,,, 'ahk_id ' hwnd)
    }
    
    enter_pressed(*) {
        con := this.gui.FocusedCtrl
        if (con is Gui.Button)
            con(con)
        else this.Gui[this.get_default_gui_btn()]()
    }
    
    resume(con, *) {
        this.unpause()
        this.destroy(con)
    }
    
    destroy(con, *) {
        WM_MOUSEMOVE := 0x0200
        callback := ObjBindMethod(this, 'WM_MOUSEMOVE')
        OnMessage(WM_MOUSEMOVE, callback, 0)
        try {
            this.update_gui_pos()
            if (con is Gui)
                con.Destroy()
            else con.Gui.Destroy()
        }
    }
    
    update_gui_pos() {
        this.gui.GetPos(&x, &y)
        this.gui.GetClientPos(,, &w, &h)
        Peep.gui_x := x
        Peep.gui_y := y
        Peep.gui_w := w
        Peep.gui_h := h
    }
    
    unpause(*) {
        if (A_IsPaused)
            pause(0)
    }
    
    save_to_clip(*) {
        A_Clipboard := this.gui['edt_main'].value
        TrayTip('Text copied to clipboard', 'Peep(AHK)', 0x10)
    }
    
    exit(*) => ExitApp()
}
