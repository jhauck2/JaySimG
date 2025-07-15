# Open Shot Golf Simulator
![img missing](https://github.com/jhauck2/OpenShotGolf/blob/main/Screenshots/Screenshot_20250715_152214.png)
## Introduction
Welcome to Open Shot Golf (formerly JaySimG)!  
  
Open Shot Golf is an open source golf simulator built using the Godot Engine. This golf sim was built to interface with the PiTrac Launch Monitor  
You can find their github page here: https://github.com/jamespilgrim/PiTrac  
### Current State
Launch Monitor Support:  
- At this point, the golf sim only supports connections to a PiTrac launch monitor.
  
Sim Features:  
- The golf sim features a range mode with data readouts, club selection, and range session recording. There are a few more range features being planned at the momemnt but feel free to open an issue with any suggestions or areas of improvement.  
  
### Future State
Launch Monitor Support:  
- There is no current plan to support any commercial launch monitors but we welcome any ideas or contributions in this area.
  
Sim Features:
- As for full golf course play, this is the next major milestone in this project's development. Details on implementation are sparse if not non-existent. Initial planning and architecting of this feature will be starting soon. Stay tuned!

## Build Instructions
### Install Godot
Download and install Godot for your operating system. See instructions at https://godotengine.org/download

### Clone Repository
- Clone repository into a local folder
- `git clone https://github.com/jhauck2/OpenShotGolf.git`

### Import Project
- Open Godot
- In the Project Manager window that opens, select "Import" in the upper left corner
- Navigate the OpenShotGolf folder and select the `project.godot` file

### Run
- Once the project has been imported, click the play button in the upper right corner or press F5 to run the project
- Press the 'h' key to simulate a built-in hit
- Press the 'r' key to reset the ball
