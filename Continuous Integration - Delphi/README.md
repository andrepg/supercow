# README

## Overview

This is a script developed to run Delphi compiler alongside with Jenkins. At first time that I wrote this script, we use **Delphi 7** and Jenkins in a VPS environment. So, the execution is granted into this version, but should work with other versions (since dcc32.exe it's deployed with newer versions).

It read some variables filled by `Run_CI_For_Delphi.bat` batch file and execute all logic inside `CoreScript.bat`. We provide a sample `dcc32.cfg` file too, that'll be copied into every path containing a Delphi package to be compiled.

### The Run_CI_For_Delphi.bat file

This is the entry point to our script. Inside it was some basic variables to run the compiler and proceed with compilation inside Jenkins. If any of these variables aren't filled, the script will exit with a `error code 2`. The content of this file is self explainable, but here are some intro:

- **os_DELPHI_ROOT** :: This is the root installation path of Delphi (we'll search all binaries needed inside it)
- **os_DCC_FILE** :: This is where our dcc32.cfg file it's located (you can point to the dcc32.cfg sample provided with this repository)
- **os_BPL_OUT** :: The BPL output path. Where compiled packages will be provided to download/update your packages
- **os_DCP_OUT** :: The DCP output path. The DCP it's the Delphi compiled package that compiler reads to link and provide additional information to BPL file. (more information at [Embarcadero Docs][embarcadero_dcp_docs])
- **os_DCU_OUT** :: The DCU output path. DCU files are compiled unit binaries that compiler uses to read and produce BPL packages. (more information at [Embarcadero Docs][embarcadero_dcu_docs])
- **os_PACKAGES** :: Root path to Delphi packages that will be compiled. This directive will be concatenated with each package pointed into _packages.txt_ file.

### The CoreScript.bat file

Our main logic and compilation of all packages are included in this file. All validation of empty variables and treatment to output path (like deleting and creating it) are inside this script. You don't need to call this file directly. It's called from inside `Run_CI_For_Delphi.bat` file.

The script has an exit error 2 when one of the main variables was not setted and an error 1 when other generic error occurs. There's a Help message still to be implemented. But not for now.

## The Packages.txt file

The packages.txt file contains relative path to all files that'll be compiled by dcc32.exe file.

You need to put packages in order of compilation. If some package are required by another, it must be in a previous line. Otherwise, it returns a compiler error from Delphi, since the DCP and DCU files won't be generated before compilation of mentioned package.

The default content provided with this repo contains the Fortes Report and some packages of the [ACBr Project][acbr_homepage] brazilian suite.

## The dcc32.exe compiler and his directives

The `dcc32.exe` file it's the Delphi command line compiler for 32 bits executables. It'll be called for every package inside _package.txt_ file. This file it's inside your Delphi installation. And your Delphi installation path it's pointed by `os_DELPHI_ROOT` directive inside **Run_CI_For_Delphi.bat** script.

This files also are called with some basic switches that points to default files (inside Delphi installation), according to the following:

- **LN** :: Package DCP output directory (defined by os_DCP_OUT variable)
- **LE** :: Package BPL output directory (defined by os_BPL_OUT variable)
- **A** :: Unit aliases (to use some units with aliases from compiler point of view)
- **N** :: Unit DCU output directory (defined by os_DCU_OUT - this variable will be used as search path too)
- **I** :: Variable to include folders to search DCP and DCU files (and others too, like .inc & etc)
- **U** :: Variable to include folders to search source code to compile (like units included in packages)
- **LU** :: If you want to include some DCP packages as dependency, use this variable pointing to name of package
- **R** :: Resource path to compiler search resource configuration

## The dcc32.cfg file and his directives

The `dcc32.cfg` file it's a complement to the switches provided to `dcc32.exe` compiler. It'll be copied to every directory that contains a package to be compiled and renamed according to package name, to provide custom settings to compiler. You must read the sample file provided with this repository. (more info about directives [here][delphi_compiler_directives])

These are some directives (place a [+ / -] signal in front of each switch to enable/disable):

- A8 :: Aligned record fields
- B- :: Full boolean Evaluation
- C+ :: Evaluate assertions at runtime
- D+ :: Debug information
- G+ :: Use imported data references
- H+ :: Use long strings by default
- I+ :: I/O checking
- J- :: Writeable structured consts
- L+ :: Local debug symbols
- M- :: Runtime type info
- O+ :: Optimization
- P+ :: Open string params
- Q- :: Integer overflow checking
- R- :: Range checking
- T- :: Typed @ operator
- U- :: Pentium(tm)-safe divide
- V+ :: Strict var-strings
- W- :: Generate stack frames
- X+ :: Extended syntax
- Y+ :: Symbol reference info
- Z1 :: Minimum size of enum types

> Important!
> The `-I` (from Include unit) compiler directives has a characters limit inside command prompt.
> You must split into various lines if some of them was not recognized.

[embarcadero_dcp_docs]: http://docwiki.embarcadero.com/RADStudio/Rio/en/Delphi_Compiled_Package_File_(*.dcp)
[embarcadero_dcu_docs]: http://docwiki.embarcadero.com/RADStudio/Rio/en/Delphi_Compiled_Unit_File_(*.dcu)
[delphi_compiler_directives]: http://www.delphibasics.co.uk/ByType.asp?Type=Compiler%20Directive
[acbr_homepage]: https://www.projetoacbr.com.br/
