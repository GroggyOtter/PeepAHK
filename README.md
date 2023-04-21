# Peep(AHK)

## Navigation:
1. [What is Peep()?](https://github.com/GroggyOtter/PeepAHK/tree/main#what-is-peep)
2. [Usage](https://github.com/GroggyOtter/PeepAHK/tree/main#usage)
3. [Peep.Properties](https://github.com/GroggyOtter/PeepAHK/tree/main#peepproperties)
4. [Changelog](https://github.com/GroggyOtter/PeepAHK/tree/main#changelog)
***
## What is Peep()?

Peep() is an AHK class that allows you to view almost anything in AHK.  

It recursively loops through any object, determining what each key:value pair is and creating a visual text map of the contents.  

The class comes with multiple properties you can change (covered below) to help fully customize the experience.

Benefits of this class:  

- Allows you to quickly see inside (almost) any variable/object
- Ensure objects are being constructed correctly  
- Verify values and primitive types
- Provides a custom GUI for displaying text and copying to clipboard
- Edit control allows you to pull smaller snippets from text
- Custom GUI is able to pause code flow (similar to MsgBox)
- Other fun stuff!

Let's say you have the following complex object:
```
my_obj := {key_arr:["alpha", "bravo", "charlie"], key_map: Map("true",1, "false",0, "Jell","O", "Big","Lebowski"), key_2x2_matrix:[[1,2],[1,2]], key_literal_obj:{c_to_f:"temp * 9 / 5 + 32", f_to_c:"temp - 32 * 5 / 9"}}
```

By using Peep(), we can get a full visual representation of the object and all of its contents.

```
Peep(my_obj)
```

![Preview of Peep() using msgbox()](https://i.imgur.com/YIoh8eU.png)  ![Preview of Peep() using custom gui](https://i.imgur.com/dqnCxYY.png)

Along with [`peep.ahk`](https://github.com/GroggyOtter/PeepAHK/blob/main/script/peep.ahk), there's also a [`peep.examples.ahk`](https://github.com/GroggyOtter/PeepAHK/blob/main/script/peep.examples.ahk) file that showcases all the object types as well as examples of most of the properties.  

![Example of Peep() from the example file](https://i.imgur.com/N4sAard.png)

## Usage:

```
Peep(someVarOrObj)          ; Peep can be used to do a view any variable or object

peepObj := Peep(someObj)    ; It always returns an object after being called
MsgBox(peepObj.value)       ; The formatted text can be found in the object's .value property
```

***
## Peep.Properties

### Peep.ind_type := [str]

Character set to represent each level of indentation.

* [`Peep.ind_type := "    "    ; 4 Spaces`](https://i.imgur.com/IF2ilRC.png)
* [`Peep.ind_type := "  "    ; 2 spaces`](https://i.imgur.com/B5eBiUr.png)
* [``Peep.ind_type := "`t"    ; Tab``](https://i.imgur.com/Gs6eaw4.png)
* [`Peep.ind_type := "|   "    ; Create a connecting pipe between elements`](https://i.imgur.com/7MENPqC.png)
* [`Peep.ind_type := "|---"    ; Create a grid effect`](https://i.imgur.com/dBkAfUO.png)


***
### Peep.include_prim_type := [bool]
If true, output includes primitive type next to primitive.

* [`Peep.include_prim_type := 0`](https://i.imgur.com/3AIZANV.png)
* [`Peep.include_prim_type := 1`](https://i.imgur.com/0u7nhfm.png)


***
### Peep.key_val_inline := [bool]
If true, keys and values reside on the same line.

* [`Peep.key_val_inline := 1`](https://i.imgur.com/QmqHorr.png)
* [`Peep.key_val_inline := 0`](https://i.imgur.com/GU1T8kH.png)


***
### Peep.add_string_quotes := [bool]
If true, strings include quotation marks around them.

* [`Peep.add_string_quotes := 1`](https://i.imgur.com/yn6M3v5.png)
* [`Peep.add_string_quotes := 0`](https://i.imgur.com/Jqmy5Uz.png)


***
### Peep.include_properties := [bool]
If true, AHK's built-in properties are included for each object type.  

* [`Peep.include_properties := 1`](https://i.imgur.com/Jqmy5Uz.png)
* [`Peep.include_properties := 0`](https://i.imgur.com/TxAAXD7.png)


***
### Peep.display_text := [num]
This setting controls how text is displayed to the user.  

1 = Use the custom GUI to display formatted text  
-1 = Use Window's default message box  
0 = No display is shown but the peep object is still returned  

* [`Peep.display_text := 1`](https://i.imgur.com/dqnCxYY.png)
* [`Peep.display_text := -1`](https://i.imgur.com/YIoh8eU.png)


***
### Peep.gui_pause_code := [bool]
When set to true, this makes your script's code pause when the custom GUI pops up.  
This emulates the same behavior as using MsgBox() and makes Peep() useful for troubleshooting.


***
### Peep.disable_gui_escape := [bool]
If true, this disables escape closing the custom gui.


***
### Peep.array_values_inline := [bool]
If true, puts all array elements on the same line.  
Warning. This is a niche setting and can mangle output if you have other objects inside of an array.

* [`Peep.array_values_inline := 1`](https://i.imgur.com/mVmqD2I.png)
* [`Peep.array_values_inline := 0`](https://i.imgur.com/TxAAXD7.png)


## Changelog
v1.0 - Initial commit
