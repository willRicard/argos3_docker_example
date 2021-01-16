# Argos3 Docker Example
This is a minimal docker example to run Argos3 on any platform.
The following assumes that you are running on a Linux distribution.
Look at the end for Windows and Mac support.

## Build the Image
For the first build execute in the same folder as the Dockerfile: 
```
docker build . --tag argos-example --network host
```
Be sure to change the `UPDATE_CODE` value every time to invalidate your build
cache. 
If you modified the ARGoS simulator itself use the arg `UPDATE_ARGOS` instead.
Example:
```
docker build . --tag argos-example --network host --build-arg CODE_UPDATE=1
```
## Running a Container
The ARGoS simulation needs access to a graphical user interface to work. 
Many options are available to share the X server and have access to the GUI of the apps running in your
docker container.
You can look [here](http://wiki.ros.org/docker/Tutorials/GUI) for multiple options on Linux.
Otherwise, I also suggest using https://github.com/mviereck/x11docker with options `--hostdisplay --hostnet --user=RETAIN -- --privileged`. 
Look at the end of this file for Windows and Mac options.

## Launching the Simulation
You can start a bash shell into the container with the following command: 
```
docker exec -it $(docker container ls -q) /bin/bash
```
If you have multiple containers running at the same time, you can replace the `$(docker container ls -q)` with the container ID. The container ID can be found using `docker ps`. 

Then you can start the simulation yourself.
For example, go into the folder `/root/examples`
and execute :
```
argos3 -c experiments/diffusion_10.argos
```
## Visual Studio Code (not essential but recommended)
I recommend using [Visual Studio Code](https://code.visualstudio.com/) to edit
and debug your code.

### Development
Look here to develop inside your Docker container with VSCode:
https://code.visualstudio.com/docs/remote/containers

### Debugging
1. Launch Visual Studio Code in the folder `/path/to/your/code`.
2. Launch the simulation.
3. Create a `(gdb) Attach` configuration in Visual Studio Code debugging tool
   (you will need C++/CMake extensions). Example of `.vscode/launch.json` config
   file:
   ```
   {
       "version": "0.2.0",
       "configurations": 
       [{   "name": "(gdb) Attach",
            "type": "cppdbg", 
            "request": "attach", 
            "program" :  "/usr/local/bin/argos3", 
            "processId": "\${command:pickProcess}",
            "MIMode": "gdb", 
            "setupCommands": 
                [ { "description": "Enable pretty-printing for gdb", 
                    "text": "-enable-pretty-printing","ignoreFailures": true
                    } ]
        }]
    }
   ``` 
4. In the debugging drop list choose `(gdb) Attach`, press play and select the running `argos3` process.
5. You are ready to place your breakpoints and debug!

## Other Platforms

### Windows Support
Thanks to the magic of Docker, it is possible to run the simulation on Windows as follows:
- Install [Docker for Windows](https://docs.docker.com/get-docker/)
- Install [VcXsrv](https://sourceforge.net/projects/vcxsrv/) to instantiate a X server.
- Run the newly installed `XLaunch`, choose the default settings except:
    - Choose `One Large Window`
    - Check `Disable access control`
- Launch a `cmd` and check your machine ip address with `ipconfig` (e.g. `192.168.12.10`)
- Launch your container with the following command: `docker run -it -e DISPLAY=192.168.12.10:0.0 argos-example`.
- Now you can launch the simulation as normal! For example: `argos3 -c
  example.argos`.

### Mac Support
Never tried it myself, but it should work. Look here: https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb

## Networking
There are plenty of networking things you can do with Docker (exposing ports,
share host network, etc.). Look here for more info: https://docs.docker.com/network/
# Questions?
For further questions or comments, feel free to contact me at :
`pierre-yves.lajoie@polymtl.ca` or leave an issue on this repository.
