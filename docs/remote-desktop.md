# Connection Setup with *neil-ux*
Remote Desktop access is necessary for Paraview ~~and Minecraft~~. 

## To Get Started, run:
`$ neil-ux`

And follow the configuration instructions to add web desktop to you

## To access the desktop at any time
Open a terminal window on your computer and run:
`$ ssh neil-desktop`


![#ff0000](Keep this terminal open while using Web Desktop and only use Ctrl-C to close out the session, to prevent resource waste.)

Open your browser and navigate to http://127.0.0.1:8086/vnc.html?autoconnect=true. Chooser will open. See the next page for more details on using *Chooser*.

## Web Desktop Viewer Configuration
<img src="https://github.com/ucsdsupercomputing/scc22-scripts/tree/main/docs/images/vnc-setting-tab.png" align="left" width="100px"/>
<img src="https://github.com/ucsdsupercomputing/scc22-scripts/tree/main/docs/images/vnc-setting.png" align="left" width="300px"/>
For best experience, click the menu button on the left side of the display and select the Settings icon. Here, make sure *Scaling Mode* is set to *Remote Resizing*.

**Note**: The remote display may go to sleep. If you see a black screen, move the mouse around and click.

**Note**: If your SSH session is terminated, intentionally or by loss of internet access, you will lose all unsaved work. **Save often**.

**Direct VNC** is on 127.0.0.1:8087. This requires a client like *VNC Viewer*. 
On Mac, do **NOT** use the built-in app *Screen Sharing*.
**Web Desktop** is more performant and recommended.

# Selecting Environment with Chooser.
When you launch into remote access, you will be greeted with Chooser. Here, select the desktop environment of your choice. 
![Chooser](https://github.com/ucsdsupercomputing/scc22-scripts/tree/main/docs/images/chooser.png)

## Usage Notes
### LXQt
If asked to select a window manager, select openbox or ob. The application menu can be found by selecting the icon in the bottom left. Paraview is in the Other section. Exit LXQt gracefully by going to Applications > Leave > Logout.

### XFCE 4
The application menu can be found by selecting Applications in the bottom left. Paraview is in the Other section. Exit XFCE 4  gracefully by going to Applications > Log Out (You will not return to Chooser).

### Motif & Openbox
	Hold Right Click to see the application menu. Paraview might not be there so you might need to launch it in a shell with paraview.

**Logging out** of these environments should take you back to Chooser (except XFCE4). Here, you can launch into another environment. **Log Out** before pressing **Ctrl-C** in your computer’s neil-desktop session window to gracefully terminate.

