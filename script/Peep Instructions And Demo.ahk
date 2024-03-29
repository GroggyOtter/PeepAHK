#Include Peep.v2.ahk

demo()
ExitApp()

demo() {
    arr_ex := [
        'alpha',
        'bravo',
        'charlie',
        unset
    ],
    
    obj_ex := {
        bool_true  : 1,
        bool_false : 0,
        c_to_f     :'temp * 9 / 5 + 32',
        f_to_c     :'temp * 5 / 9 - 32',
        Jell       : 'O',
        Big        : 'Lebowski',
        A_ComSpec  : A_ComSpec
    }
    
    goo := Gui(), goo.AddButton('vBtn1'), goo.AddCheckbox('vCB1')
    
    main := Map(
        'integer'       , 1234,
        'float'         , 3.14,
        'string'        , 'Hello, world!',
        'arr_example'   , arr_ex,
        'obj_example'   , obj_ex,
        'error_example' , Error('Err msg', A_ThisFunc, 'Extra info here'),
        '2x2_matrix'    , [['A','B']
                        ,  ['C','D']],
        'gui_example'   , goo
    )
    main.own_prop := 'Own Prop Value'
    main.Default := 'Optional built-in default value.'
    
    ; Setting properties to intial values
    Peep.indent_str := '    '
    Peep.display_with_gui := 1
    Peep.key_value_inline := 1
    Peep.gui_pauses_code := 1
    Peep.include_prim_type := 0
    Peep.include_built_in := 0
    Peep.include_string_quotes := 0
    
    ; How to use
    MsgBox('Peep() usage:'
        . '`n`nPeep() is a callable class and is used just like a function.'
        . '`nMostly, this is for troubleshooting code, though I`'m sure there are '
        . 'other scenarios where it could be useful.'  
        . '`n`nAny number of items can be passed to Peep().'
        . '`nPeep() will extract and display any items given to it, down to their primitive values.'
        . '`nThis allows you to check the contents of any items as well as avoiding '
        . 'the need to write complex for-loops to see inside nested objects.'
        . '`n`nCheck an item:'
        . '`nPeep(my_obj)'
        . '`nCheck multiple items:'
        . '`nPeep(my_obj, my_arr, num1, num2, txt1, txt2)'
        . '`n`nPeep() will always return the text it generates.'
        . '`n`ntxt := Peep(my_obj)'
        . '`nMsgBox(txt)'
    )
    
    ; Properties
    MsgBox('Peep() has many different properties for customizing the experience.'
        . '`nThis tutorial goes over all of them, explaining what each '
        . 'does and showing examples for most.'
        . '`nHere is a list of all properties:'
        . '`n`nIdentifying values:'
        . '`n- indent_str'
        . '`n- unset_value'
        . '`n- var_ref_value'
        . '`n- duplicate_ref_value'
        . '`n`nInclude items:'
        . '`n- include_prim_type'
        . '`n- include_string_quotes'
        . '`n- include_end_commas'
        . '`n- include_array_index'
        . '`n- include_built_in'
        . '`n`nData alignment:'
        . '`n- array_values_inline'
        . '`n- key_value_inline'
        . '`n- indent_closing_tag'
        . '`n`nGUI stuff:'
        . '`n- gui_pauses_code'
        . '`n- disable_gui_escape'
        . '`n- display_with_gui'
        . '`n- default_gui_btn'
    )
    
    ; indent_str
    MsgBox('Peep() Property: indent_str'
        .  '`n`nindent_str defines the character set used for each indentation level.'
        .  '`nThis can be any amount of spaces, tabs, or any other characters.'
        .  '`n"    " = 4 spaces'
        .  '`n"``t``t" = 2 tabs'
        .  '`n`nBy default, this is set to 4 spaces.'
        .  '`n`nPress OK to see an example using 2 spaces.'
    )
    Peep.indent_str := '  '
    Peep(main)
    MsgBox("Using 1 tab."
        "`nPeep.indent_str := '``t'")
    Peep.indent_str := '`t'
    Peep(main)
    MsgBox("Using different string patterns can produce interesting results."
        . "`n`nAdding a pipe and a few spaces creates connecting lines between each element."
        . "`n`nPeep.indent_str := `"|   `""
        . "`n`nOr use a pipe and dashes to create a grid effect."
        . "`n`nPeep.indent_str := `"|---`""
        . "`n`nPress OK to see an example using pipe + spaces."
    )
    Peep.indent_str := '|   '
    Peep(main)
    Peep.indent_str := '    '
    
    ; unset_value, var_ref_value, and duplicate_ref_value
    MsgBox("Peep() Property: unset_value, var_ref_value, duplicate_ref_value"
        . "`n`nSet these properties to the string you want displayed when "
        . "an unset item or a duplicate object is encountered."
        . "`n`nunset_value = Text to indicate a value was unset."
        . "`nBy default, this is set to: <UNSET>"
        . "`n`nvar_ref_value = Text to use when a VarRef is encountered."
        . "`nBy default, this is set to: <VAR_REF>"
        . "`n`nduplicate_ref_value = Text to indicate a duplicate object was encountered."
        . "`nBy default, this is set to: <DUPLICATE_REF>"
        . "`n`nPress OK to use [UNSET YO!] for unset values."
        . "`nPeep.unset_value := '<YOU MESSED UP>'"
    )
    Peep.unset_value := '<YOU MESSED UP>'
    Peep(main)
    Peep.unset_value := '<UNSET>'
    
    ; include_prim_type
    MsgBox("Peep() Property: include_prim_type"
        . "`n`nSetting this to true will include the primitive's type in brackets left of the value."
        . "`nSuch as: [String] Hello, world!"
        . "`n`nSetting it to false will disable the tags and show only show the value."
        . "`nThis is the default setting."
        . "`n`nPress OK to see primitive types shown."
        . "`nPeep.include_prim_type := 1"
    )
    Peep.include_prim_type := 1
    Peep(main)
    Peep.include_prim_type := 0
    
    ; include_string_quotes
    MsgBox("Peep() Property: include_string_quotes"
        . "`n`nSetting this to 0 will display strings normally and without quotes around them." 
        . "`nThis is the default setting."
        . "`nQuotation marks that are natively part of the string are still shown."
        . "`n`nSetting this to a positive number will `"add double quotation marks`" to all strings."
        . "`n`nSetting this to a negative number will 'add single quotation marks' to all strings."
        . "`n`nPress OK to see double quoted strings."
        . "`nPeep.include_string_quotes := 1"
    )
    Peep.include_string_quotes := 1
    Peep(main)
    MsgBox("And now with single quotes."
        . "`nPeep.include_string_quotes := -1"
    )
    Peep.include_string_quotes := -1
    Peep(main)
    Peep.include_string_quotes := 0
    
    ; include_end_commas
    MsgBox("Peep() Property: include_end_commas"
        . "`n`nSetting this to true includes a comma after each item in a group of of items."
        . "`nThe last item will not have a comma after it."
        . "`nEach group (own props/built-in/items) are handled individually, "
        . "meaning they will each of their last items will have no comma after them."
        . "`n`nSetting this to false will omit all end commas."
        . "`nThis setting works especially well when key_value_inline is turned off."
        . "`n`nPress OK to see commas disabled."
        . "`nPeep.include_end_commas := 0"
    )
    Peep.key_value_inline := 0
    Peep.include_end_commas := 0
    Peep(main)
    Peep.key_value_inline := 1
    Peep.include_end_commas := 1
    
    ; include_array_index
    MsgBox("Peep() Property: include_array_index"
        . "`n`nSetting this to true will include the array index number when displaying each element."
        . "`n`nPress OK to see commas disabled."
        . "`nPeep.include_end_commas := 0"
    )
    Peep.include_array_index := 1
    Peep(main)
    Peep.include_array_index := 0
    
    ; include_built_in
    MsgBox("Peep() Property: include_built_in"
        . "`n`nSetting this to true will include all built-in properties that are provided natively by AHK."
        . "`nExamples of these would be:"
        . "`n    Array.Length"
        . "`n    Buffer.Ptr"
        . "`n    Error.Message"
        . "`n    RegExMatchInfo.Count"
        . "`nBy default, this property is set to true."
        . "`n`nUntil now, these have been shown."
        . "`nPress OK to see these properties omitted."
        . "`nPeep.include_built_in := 0"
    )
    Peep.include_built_in := 1
    Peep(main)
    Peep.include_built_in := 0
    
    ; array_values_inline
    MsgBox("Peep() Property: array_values_inline"
        . "`nSetting this to true will cause arrays to be displayed in a single line."
        . "`nThe array must not have any object values, and built-in properties can't be enabled."
        . "`n`nBy default, this is set to false."
        . "`n`nPress OK to see arrays shown inline."
        . "`nPeep.array_values_inline := 1"
    )
    Peep.array_values_inline := 1
    Peep(main)
    Peep.array_values_inline := 0
    
    ; key_value_inline
    MsgBox("Peep() Property: key_value_inline"
        . "`n`nSetting this to true will put keys and values on the same line."
        . "`n`nSetting this to false will put the value on the line below the key and "
        . "indents the value one more level."
        . "`n`nPress OK to see keys and values on separate lines."
        . "`nPeep.key_value_inline := 0"
    )
    Peep.key_value_inline := 0
    Peep.include_array_index := 1
    Peep(main)
    Peep.key_value_inline := 1
    Peep.include_array_index := 0
    
    ; indent_closing_tag
    MsgBox("Peep() Property: indent_closing_tag"
        . "`nSetting this to true will indent the closing bracket one more level, "
        . "aligning it with the keys/values."
        . "`n`nSetting this to false will align the closing bracket with the object it belongs to."
        . "`nThis is the default value."
        . "`n`nPress OK to see this setting enabled."
        . "`nPeep.indent_closing_tag := 1"
    )
    Peep.indent_closing_tag := 1
    Peep(main)
    Peep.indent_closing_tag := 0
    
    ; gui_pauses_code
    MsgBox("Peep() Property: gui_pauses_code"
        . "`n`nSetting this to true will cause the code to pause while the GUI is up."
        . "`nThis is the same similar effect to how MsgBox() works and "
        . "can be a big help when troubleshooting code."
        . "`nBy default, this is turned on."
        . "`n`nLet's disable it. The next message box will pop up immediately over "
        . "the GUI."
    )
    Peep.gui_pauses_code := 0
    peep_obj := Peep(main)
    Peep.gui_pauses_code := 1
    MsgBox('This message box popped up but the gui is still showing, as it didn`'t pause the code.'
        '`n`nClose the previous gui and then continue onto the next message box.'
    )
    
    ; display_with_gui
    MsgBox("Peep() Property: display_with_gui"
        . "`n`nSetting this to a positive number will cause the built-in GUI to be used."
        . "`nThis is the default setting with a value of 1."
        . "`n`nSetting this property to a negative number will use the standard AHK Message Box."
        . "`n`nSetting it to 0 will disable all popup types, but Peep() will still return the text."
        . "`n`nPress OK to see the MsgBox() used."
        . "`nPeep.display_with_gui := -1"
    )
    Peep.display_with_gui := -1
    Peep(main)
    Peep.display_with_gui := 1
    
    ; default_gui_btn
    MsgBox("Peep() Property: default_gui_btn"
        . "`n`nThis property sets the default button that's highlighted when the GUI comes up."
        . "`nThis also becomes the default button activated when enter is pressed in the main edit field."
        . "`n`nThis value can be one of the following:"
        . "`n`n- close = Closes the GUI and resumes code if it's paused."
        . "`n`n- resume = Resumes the paused code but keeps the GUI open."
        . "`n    This can be useful when comparing multiple items, before/after checks, and more."
        . "`n`n- clipboard = Copy the text from the edit field to the clipboard."
        . "`n`n- reload = Reload the current script."
        . "`n    Useful after making quick changes to the script."
        . "`n`n- exit = Exit's the current running script."
    )
    
    obj := {
        prop_str: 'Auto`nHot`nKey',
        prop_int: 100,
        prop_float: 3.14
    }
    arr := [
        'a`nb`nc',
        unset,
        'b',
        'c',
    ]
    goo := Gui()
        goo.Name := 'My_GUI'
        con := goo.AddButton(, 'exit btn')
        con.own_prop := 'multiple`nline`nvalue'
        goo.AddText(, 'txt ')
    mp := Map(
        'a', 'Alpha',
        'b', 'Bravo',
        'c', 'Charlie',
        'd', 'multi`nline`nvalue'
    )
    RegExMatch('abc 123 xyz', '(\w+).*?(\d+).*?(\w+)', &match)
    
    master_obj := Map(
        'object_example'        , obj,
        'array_example'         , arr,
        'buffer_example'        , Buffer(16, 0),
        'clipboard_example'     , ClipboardAll(),
        'class_example'         , cls,
        'error_example'         , Error('Error msg', A_ThisFunc, 'Extra error Info'), 
        'os_error_example'      , OSError(0, A_ThisFunc, 'Extra OS error'), 
        'file_example'          , FileOpen(A_ScriptFullPath, 'r'),
        'func_example'          , test_all_types,
        'boundfunc_example'     , test_all_types.Bind('test'),
        'closure_example'       , closure_example,
        'enum_example'          , obj.OwnProps() ,
        'gui_example'           , goo,
        'inputhook_example'     , InputHook(),
        'map_example'           , mp,
        'menu_example'          , Menu(),
        'menubar_example'       , MenuBar(),
        'regexmatchinfo_example', match
    )
    MsgBox("Here's a complex object containing most of the native AHK v2 types.")
    Peep(master_obj)
    ; Complex test
    
    MsgBox("This demonstration was made possible by contributions to your PBS station."
        . "`nFrom viewers like you!!")
    MsgBox("No, wait. That's PBS. I don't get anything from them."
        . "`nThat's my bad.`n`nI mean Big Bird gets a slice but he doesn't really teach anyone AHK."
        . "`nWasted opportunity and yet he still gets a weekly pay check.")
    MsgBox("Do I need to point out he's a bird??"
        . "`nWhere's the otter's check?`nJust b/c I'm groggy doesn't mean I'm not putting in "
        . "the hours like the giant canary."
        . "`nDamn bird is always taking the spotlight.")
    MsgBox("In a weird way I really feel for Wile E Coyote right now."
        . "`nWhy does the roadrunner always gotta win?"
        . "`nWhy can't Wile E win once in a while?")
    MsgBox("Sorry for that tangent."
        . "`n`nAnyway, I hope you enjoyed the Peep() demonstration.")
    Sleep(5000)
    MsgBox("Why are you still here...?`nThis isn't the end of a Marvel movie. There's no teaser for the next thing."
        . "`nIt's just a demonstration script.")
    Sleep(5000)
    MsgBox("Stop expecting more!`n`nGo on, now.`nGo code something.`n"
        . "`n`nGo use Peep() to troubelshoot something on the subreddit so I don't have to.")
    Sleep(5000)
    MsgBox('Bye!!')
    ExitApp()
    
    closure_example() {
    }
}

class cls {
    static staic_prop := 'some data'
}
