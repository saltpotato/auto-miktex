# Use lualatex for compilation
$pdflatex = 'lualatex --interaction=scrollmode %O %S';

# Specify default file extension
$pdf_mode = 1;

# Clean up additional files after compilation (optional)
$clean_ext = 'aux bbl blg log fls out fdb_latexmk';

# Automatic dependency handling
@generated_exts = (@generated_exts, 'pdf');

# Disables automatic PDF viewing by latexmk
$pdf_previewer = 'start true';