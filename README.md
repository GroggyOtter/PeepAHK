# Peep(AHK)

### Peep() is an AHK class that allows you to view almost anything in AHK.

```
obj := {key_arr:["alpha", "bravo", "charlie"], key_map: Map("true",1, "false",0, "Jell","O", "Big","Lebowski"), key_2x2_matrix:[[1,2],[1,2]], key_literal_obj:{c_to_f:"temp * 9 / 5 + 32", f_to_c:"temp - 32 * 5 / 9"}}
Peep(obj)
```

![Image of an peep() result for the previously defined object.](https://i.imgur.com/QhSokAJ.png)

## Usage:

```
Peep(obj)

obj can be any object, array, map, or primitive.
```

***
## Properties

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

1 = Use the custom GUI to dispaly formatted text  
-1 = Use Window's default message box  
0 = No dispaly is shown but the peep object is still returned  

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
