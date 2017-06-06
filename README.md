# larlib.jl
Literate programming approach for LAR in Julia

### Using Makefile

`make all` generates Julia scripts and pdf docs of LARLIB and its test units.  
`make lib_code` generates only the scripts and the tests.  
`make lib_pdf` generates the pdf docs and the scripts and tests.  
`make pkg` generates LARLIB and pushes the freshly generated version to [the official package repository of LARLIB](https://github.com/cvdlab/LARLIB.jl). It uses the ./VERSION text file to label the new version. (You need the official repo credentials to do this)
