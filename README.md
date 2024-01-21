# MIT Notes

![Lint](https://github.com/dpwiese/mit-notes/actions/workflows/lint.yml/badge.svg?branch=main)

This repository contains a compendium of random notes I took while in graduate school at MIT.
They certainly contain typos, errors, and incorrect statements based on an incomplete understanding of the material at the time they were written.
Nevertheless they may be of value to myself and others.

## Generating Output

```sh
# Generate the document
make pdf

# Lint
make lint

# Clean temporary and output files
make clean
```

## Developing

Some useful commands:

```sh
# See global chktexrc: /usr/local/texlive/2021/texmf-dist/chktex/chktexrc
# chktex-file 1 - ignore in whole file
# chktex 1 - ignore on line

# Run following command from src to get a list of all unused references via .aux file
checkcites --unused mit-notes.aux

# tlmgr is the native TeX Live Manager
tlmgr option repository ftp://tug.org/historic/systems/texlive/2015/tlnet-final
tlmgr info tikz
sudo tlmgr update --self
sudo tlmgr update thmtools
```

In fluids check if the following equality true:

```tex
$\underline{\nabla}\cdot(\underline{v}\underline{v})=\underline{v}\cdot\underline{\nabla}\underline{v}$
```

Remove code as imported files and inline it?
Consider whether having code blocks in text that are more than 100 lines long.
If code is too long to inline in the `.tex` body, it's probably too long to have in the document anyway and should be removed and linked.

## References

* [Latex \psfragfig of figures in other folders](http://phdtools.blogspot.com/2011/07/latex-psfragfig-of-figures-in-other.html)
* [Writing a LaTeX macro that takes a variable number of arguments](https://davidyat.es/2016/07/27/writing-a-latex-macro-that-takes-a-variable-number-of-arguments/)
* [What is the difference between \def and \newcommand?](https://tex.stackexchange.com/questions/655/what-is-the-difference-between-def-and-newcommand)
