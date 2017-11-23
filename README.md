# larlib-literate
Literate programming approach (with [nuweb](http://nuweb.sourceforge.net/)) for LAR in Julia. This is the development repo for the [LARLIB.jl package](https://github.com/cvdlab/LARLIB.jl). If you are looking only for the LARLIB.jl package, this is not the right place.

### How to contribute

Here a quick start for the people who contribute to a literate programming project for the first time:

1. Fork this repo

2. Put your Julia code inside a LaTEX file called `ch_<name>.tex` in the `src/pkg/tex/` folder. The barebone structure of this file must be: 
```
\chapter{<fancy name>}
\label{ch:<name>}

@O lib/jl/<name>.jl
@{
    <Julia code>
@}
```  
(refer to `src/pkg/tex/ch_planar_arrangement.tex` for a well
structured LaTEX+nuweb file)

3. Modify `src/pkg/tex/intro.tex` by appending to it a LaTEX chapter with the high-level description of the algorithm you implemented.

4. Add the line `\input{ch_<name>.tex}` right before `\input{ch_utilities.tex}` inside `src/pkg/tex/book.tex`.

5. Add the line `include("./<name>.jl")` anywhere inside the `@O lib/jl/LARLIB.jl` nuweb macro defined in `src/pkg/tex/ch_larlib.tex`.

6. Do a pull request. If it gets accepted, we will take care of the insertion of your contribution inside the [LARLIB.jl package repo](https://github.com/cvdlab/LARLIB.jl).


### Makefile Usage

`make all` generates Julia scripts and pdf docs of LARLIB and its test units.  
`make lib_code` generates only the scripts and the tests.  
`make lib_pdf` generates the pdf docs and the scripts and tests.

### Docker

You can use the previous build commands prepending `docker-` so that, e.g. `make all` becomes `make docker-all`, to use a docker image that contains everything to perform the building.