# auto-miktex

This is a docker image that contains a initial setup of miktex.

So for instance one can write applications that use latex to generate pdf files, and use this image to compile the tex files. So no need to install (extensive) miktex on the host machine.

The script `texcompile.sh` compiles a tex file. 

- It uses `xelatex` to compile the file. No other options are available at the moment.
- There is also a configurable `$RESOURCES_PATH` variable that can be set to a directory where latex resources are located.
- If you compile a file, missing packages will be installed automatically by default from miktex itself. 

You can for instance point $PATH to the script and use it more conveniently or call it by its full path.

Then specify `$RESOURCES_PATH` environment variable in `texcompile.sh` script,
pointing it to the directory where your latex resources are located. 

Resource files can be included in the tex file for instance:

```latex
\photo[90pt]{../resources/foto.png}
```
foto.png is located in the resources directory root in this case.
Descendant directories are also supported.

To compile a tex file, use the script like this:

```bash
texcompile.sh <tex file>
```
There is --it option to just get into the container and run mpm commands for instance.

```bash
texcompile.sh <tex file> --it
```

Steps to build the image:

```bash
docker build -t auto-miktex .
```
(auto-miktex is a known name, which is used in the texcompile.sh script)


