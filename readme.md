# auto-miktex

This Docker image includes a pre-setup MiKTeX environment, allowing users to compile LaTeX files into PDFs without needing a full MiKTeX installation on the host machine. This is particularly useful for tasks like generating PDFs from LaTeX sources (e.g., resumes, reports).

## Features

- **Compiler**: The image uses `xelatex` for compilation. Currently, no other compilers like `LuaLaTeX` are tested.
- **Resource Directory**: You can use the `--resource-dir` argument to bind an additional directory to the container, which is useful for including shared resources between LaTeX files.
- **Automatic Package Installation**: When compiling a file, if any LaTeX packages are missing, they will be installed automatically from the MiKTeX repositories.

## Including Resource Files

You can include external resources in your LaTeX files as shown below:

```latex
\photo[90pt]{../resources/foto.png}
```

Here, `foto.png` should be located in the specified resources directory.

## Usage

To compile a LaTeX file into a PDF:

```bash
texcompile.sh <tex-file>
```

To interactively enter the container and run MiKTeX Package Manager (`mpm`) commands:

```bash
texcompile.sh <tex-file> --it
```

For convenience, you can add `texcompile.sh` to your PATH.

## Building the Docker Image

To build the Docker image, run:

```bash
docker build -t auto-miktex .
```

`auto-miktex` is the designated image name used within the `texcompile.sh` script.