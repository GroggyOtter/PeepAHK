# Peep(AHKv2)

1. [What Is Peep()?](#what-is-peep)
2. [How To Use](#how-to-use)
3. [Peep Properties](#peepproperties)
    * [`dark_mode`](#peepdark_mode-integer)
    * [`indent_str`](#peepind_type-string)
    * [`unset_value`](#peepunset_value-string)
    * [`var_ref_value`](#peepvar_ref_value-string)
    * [`duplicate_ref_value`](#peepduplicate_ref_value-string)
    * [`include_prim_type`](#peepinclude_prim_type-integer)
    * [`include_string_quotes`](#peepinclude_string_quotes-integer)
    * [`include_end_commas`](#peepinclude_end_commas-integer)
    * [`include_array_index`](#peepinclude_array_index-integer)
    * [`include_built_in`](#peepinclude_built_in-integer)
    * [`array_values_inline`](#peeparray_values_inline-integer)
    * [`key_value_inline`](#peepkey_val_inline-integer)
    * [`indent_closing_tag`](#peepindent_closing_tag-integer)
    * [`gui_pauses_code`](#peepgui_pauses_code-integer)
    * [`disable_gui_escape`](#peepdisable_gui_escape-integer)
    * [`display_with_gui`](#peepdisplay_with_gui-integer)
    * [`default_gui_btn`](#peepdefault_gui_btn-string)
    * [`gui_w`](#peepgui_w-integer)
    * [`gui_h`](#peepgui_h-integer)
    * [`gui_x`](#peepgui_x-integer)
    * [`gui_y`](#peepgui_y-integer)

4. [Changelog](#changelog)
    * [v1.2](#v12)
    * [v1.1](#v11)
    * [v1.0](#v10)
***
## What Is Peep()?

Peep() is a tool for AHK v2.  
It allows you to pass in one or more items and get a visual representation of what that item contains.  
This includes being able to get information from nested objects without having to write complex for-loops for extracting object information or to view the primitive information you're looking for.  

While Peep is a class, it's a callable class and works exactly like a function:

    Peep(item1 [, item2, ..., itemN])

Peep has multiple properties (covered below) that you can change to alter how it behaves or how information is displayed.  
Who doesn't like a little bit of customization?

Benefits of this tool:  

- Allows you to quickly see inside (almost) any AHK v2 item
- Ensure objects are being constructed and arranged correctly  
- Verify values/primitive types
- Information is displayed in a custom custom GUI
- GUI provides multiple features including code pausing, quick script closing and reloading, and a button to copy gui text to clipboard
- The main control is an edit box instead of a text box so you can pull smaller snippets from the displayed text
- A Peep object is always returned. This object can be called to return the text that was generated from that specific instance of Peep().

Peep's custom GUI:  

![Preview of Peep() GUI](https://github.com/GroggyOtter/PeepAHK/assets/29220773/c28ebdd0-6375-4aef-a1f3-e199569c0d9a)

Or using the default MsgBox():  

![Preview of Peep() with MsgBox()](https://github.com/GroggyOtter/PeepAHK/assets/29220773/de90095c-179a-47e5-846f-baebe0bf1c2a)

Along with [`Peep`](https://github.com/GroggyOtter/PeepAHK/blob/main/script/peep.ahk), there's also the [`Peep Instructions And Demo.ahk`](https://github.com/GroggyOtter/PeepAHK/blob/main/script/peep.examples.ahk) file.  
This file can be ran to visually demonstrate what the different Peep properties do. Like changing the color of the GUI or how text is displayed.  

First screen of the Demo file:  
![Preview of starting screen for demo](https://github.com/GroggyOtter/PeepAHK/assets/29220773/693c7c36-d440-404f-8008-7a0283dabca3)

## How To Use:

Download the script.  
Use [`#Include`](https://www.autohotkey.com/docs/v2/lib/_Include.htm) to add Peep to your script.  
You can remove this later as this is more of a troubleshooting tool than something you'd want to keep bundled with your code.  

```
#Include Peep.v2.ahk
```

Now you can use Peep freely in your code.  
To view an item, use:  
```
Peep(item_name)
```

Multiple items can be viewed at once:  
```
Peep(item1, item2, item3, item4)
```

You can label each item doing something like this:  
```
Peep('Before:', item1, 'After:', item2)
```

There are lots of different properties (options) you can set.

See: [Peep Properties](#peepproperties)

A Peep object is always returned when Peep() is called.  
This object contains the text from that specific Peep instance.  

Retrieve it by calling the peep object: `MsgBox(peep_obj())`  
Or use the `Text` property: `MsgBox(peep_obj.Text)`

***
## Peep.Properties

***
### `Peep.dark_mode` {Integer}
If true, a dark theme is applied to the GUI.  
Otherwise, a light theme is used.  
Default value: `1`
* [`Peep.dark_mode := 1` Dark](https://github.com/GroggyOtter/PeepAHK/assets/29220773/19a34403-f853-4399-9e5e-7e21cdef5664)
* [`Peep.dark_mode := 0` Light](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6e2e1d16-4dcd-43fa-8a97-b465e56bb875)

***
### `Peep.ind_type` {String}
Character set to represent each level of indentation.  
Normally spaces or tabs are used.  
Default value: `'    '`
* [`Peep.ind_type := "    "` 4 Spaces](https://github.com/GroggyOtter/PeepAHK/assets/29220773/55d19b3b-15d7-4248-80c4-42edc6d2ce8f)
* [`Peep.ind_type := "|   "` Create a connecting pipe between elements](https://github.com/GroggyOtter/PeepAHK/assets/29220773/012255a7-9527-4058-b4a4-994193515a59)
* [`Peep.ind_type := "|---"` Create a grid effect](https://github.com/GroggyOtter/PeepAHK/assets/29220773/dc43d9d9-4a4d-4a0f-9e39-6b4f5870ab21)

***
### `Peep.unset_value` {String}
The indentifier used for values that are unset.  
Default value: `<UNSET>`

***
### `Peep.var_ref_value` {String}
The indentifier used for when a variable reference values.  
Default value: `<VAR_REF>`

***
### `Peep.duplicate_ref_value` {String}
The indentifier used for any object that has already been referenced.  
Default value: `<DUPLICATE_REF>`

***
### `Peep.include_prim_type` {Integer}
If true, primitive value types are inclueded next to their values.  
Default value: `0`
* [`Peep.include_prim_type := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/19a34403-f853-4399-9e5e-7e21cdef5664)
* [`Peep.include_prim_type := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/3400c48b-ac37-4dd3-85e4-441b98c64af4)

***
### `Peep.include_string_quotes` {Integer}
If set to a positive number, strings will have double quotes around them.  
If set to a negative number, strings will have single quotes around them.  
If set to zero, strings do not have any additional quotes put around them.  
Default value: `0`
* [`Peep.include_string_quotes := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6db69cfe-3e77-45bb-ac18-74d7536e8cff)
* [`Peep.include_string_quotes := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/40ffebdb-68e8-4dc5-ad2c-0230d711210c)
* [`Peep.include_string_quotes := -1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/83463402-3416-4ef7-9a89-7bd3ad5a7633)

***
### `Peep.include_end_commas` {Integer}
If true, a comma separates multiple items.  
The last item of an item set does not have a comma after it.  
Default value: `1`
* [`Peep.include_end_commas := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/5ed53c04-417a-478b-8ec7-fdcdc6bfba0b)
* [`Peep.include_end_commas := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6db69cfe-3e77-45bb-ac18-74d7536e8cff)

***
### `Peep.include_array_index` {Integer}
If true, array items will include their index number before each item, starting at 1.  
Default value: `0`
* [`Peep.include_array_index := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6db69cfe-3e77-45bb-ac18-74d7536e8cff)
* [`Peep.include_array_index := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/e264060a-db10-44fe-9a5c-427b3aebd463)

***
### `Peep.include_built_in` {Integer}
If true, all native AHK objects will include their AHK assigned properties.  
Default value: `1`
* [`Peep.include_built_in := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/56313549-3dc0-4e3d-9a6e-6fd7c110b188)
* [`Peep.include_built_in := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6db69cfe-3e77-45bb-ac18-74d7536e8cff)

***
### `Peep.array_values_inline` {Integer}
If true, arrays that don't contain nested objects are shown on one line.  
`Peep.include_built_in` must also be set to false.
Default value: `0`
* [`Peep.array_values_inline := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/ed9f7578-bbc6-4615-acdb-e1a7d4cd1ae0)
* [`Peep.array_values_inline := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/03a45efb-9756-4fe6-ad85-2a52b71552dc)

***
### `Peep.key_val_inline` {Integer}
If true, keys and values reside on the same line.  
* [`Peep.key_val_inline := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/9fc813c1-cf47-4acb-92bd-0121d33e1a6d)
* [`Peep.key_val_inline := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/224375cd-b8ab-4a6d-93f6-4ace379e7444)

***
### `Peep.indent_closing_tag` {Integer}
If true, closing object tags are indented one additional level to align them with object keys/values.  
If false, closing object tags are aligned with the line containing the opening tag.  
Default value: `0`  
* [`Peep.indent_closing_tag := 0`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6db69cfe-3e77-45bb-ac18-74d7536e8cff)
* [`Peep.indent_closing_tag := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/ff533b58-0c12-426b-a765-df1229367302)

***
### `Peep.gui_pauses_code` {Integer}
If true, code execution will pause when the Peep() GUI is shown.  
This acts similarly to how [MsgBox()](https://www.autohotkey.com/docs/v2/lib/MsgBox.htm) works.  
Default value: `1`

***
### `Peep.disable_gui_escape` {Integer}
If true, pressing escape has no effect when the GUI is the active window.  
If false, pressing escape when the GUI is active will close the gui and unpause the script if it's paused.  
Default value: `0`

***
### `Peep.display_with_gui` {Integer}
If set to a positive number, Peep's custom GUI is used to display information.  
If set to a negative number, the standard MsgBox() is used.  
If set to zero, nothing is displayed. A Peep object is still returned for text retrieval.  
Default value: `1`
* [`Peep.display_with_gui := 1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/6db69cfe-3e77-45bb-ac18-74d7536e8cff)
* [`Peep.display_with_gui := -1`](https://github.com/GroggyOtter/PeepAHK/assets/29220773/db746277-4d19-450e-b071-c2af8ac8324c)

***
### `Peep.default_gui_btn` {String}
Sets the default button to focus on GUI display.  
This is also the button that will be activated when the Edit box has focus and enter is pressed.  
- `continue` or `resume` = Closes the GUI and unpauses if script is paused state.  
- `reload` = Reloads the current running script. Useful when testing quick changes to a script.  
- `exit` = Closes the current running script.  
- `clipboard` = Save the displayed text to the clipboard.  
- `unpause` = Unpauses the script if it's currently in a paused state. The GUI will remain visible.

Default value: `resume`

***
### `Peep.gui_w` {Integer}
The default starting width for the GUI.  
Default value: `600`

***
### `Peep.gui_h` {Integer}
The default starting height for the GUI.  
Default value: `1000`

***
### `Peep.gui_x` {Integer}
The default starting X coordinate.  
Default value: A_ScreenWidth / 2 - (Peep.gui_w/2)
(Center of screen)

***
### `Peep.gui_y` {Integer}
The default starting Y coordinate.  
Default value: A_ScreenHeight / 2 - (Peep.gui_h/2)
(Center of screen)

## Changelog
***

### v1.2
* Complete rewrite of core logic.
* Updates to GUI
  * Reload button added.
  * Gui is now resizeable.
  * Gui position and size is remembered between calls.
    * This resets between reloads.
  * Gui starting position and width can be set using the newly added properties:
    * Peep.gui_w
    * Peep.gui_h
    * Peep.gui_x
    * Peep.gui_y
* Added a dark mode property: `dark_mode`
  * Sets light/dark theme of the Peep GUI.
* Bug fixes
  * Unset variables are now handled correctly.
  * Alignment issues have been corrected.
* Circular reference protection has been added
  * If item1 references item2 and item2 references item1, it won't crash the script.
* `Peep.examples.ahk` was rewritten and renamed `Peep Instructions And Demo.ahk`
  * This script can be ran to demonstrate the different property options.
  * This also provides code with Peep() being used.
* Added property to toggle end commas.
  * Works well when `key_value_inline` is set to false.  
* Added properties to set the strings used for `unset` values, `VarRef` values, and duplicate object references.
* Added JSDoc tags.
  * This provides self-documenting calltips when using this script in VS Code with THQBY's v2 addon.
* Built-in property lists have been expanded and improved.

***
### v1.1
* Added an [`Exit Script`](https://i.imgur.com/M0ZSsLo.png) button to close whatever script called peep()  
* Added ability to pass multiple variables/objects into peep().  
  `Peep(var1, obj1, obj2, arr1)`
* Added an `exit_on_close` property.  
  When set to true, the script that called Peep() will close when the GUI is closed.  

***
### v1.0
* Initial commit
