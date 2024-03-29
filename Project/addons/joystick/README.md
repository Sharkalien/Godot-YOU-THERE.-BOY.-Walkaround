# Godot Virtual Joystick

<img src="https://github.com//MarcoFazioRandom/Virtual-Joystick-Godot/raw/main/previews/icon.png" width="300">

A simple virtual joystick for touchscreens, with useful options.

GitHub Page: https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

Godot Engine: https://godotengine.org

### PREVIEWS:

<img src="https://github.com//MarcoFazioRandom/Virtual-Joystick-Godot/raw/main/previews/preview1.png" width="500">

Easy to setup:  
<img src="https://github.com//MarcoFazioRandom/Virtual-Joystick-Godot/raw/main/previews/preview2.png" width="300">

Easy to use:  
<img src="https://github.com//MarcoFazioRandom/Virtual-Joystick-Godot/raw/main/previews/preview3.png" width="500">

### OPTIONS:  

- Joystick mode: 
	- Fixed: The joystick doesn't move. 
	- Dynamic: Every time the joystick area is pressed, the joystick position is set on the touched position. 

- Dead zone size: If the tip is inside this range the output is zero.

- Clamp zone size: The max distance the tip can reach.

- Visibility mode: 
	- Always: Always visible.
	- touchscreen only: Visible on touch screens only (will hide if the device has not a touchscreen).

- Use input actions: if true the joystick will trigger the input actions created in Project -> Project Settings -> Input Map

### HELP:  
- The Control parent of the joystick is the area in which the joystick can move in Dynamic mode.  
- For moving the joystick inside his area, select it, right click, turn on "Editable Children" and then change the position of the Base node.  
- With "Editable Children" turned on you can also edit the joystick textures and colors.  
- To be able to use the joystick with the mouse, you have to go to Project settings -> Input Devices -> Pointing, and turn on the option "emulate touch from mouse".
- If you want multitouch, make sure to disable the option "emulate mouse from touch".
- Create a CanvasLayer node and name it "UI", it'll contain all the UI elements, then add the Joystick scene as a child of the UI node and move it where you prefer.  
- An example scene is provided in the "Test" folder.  
