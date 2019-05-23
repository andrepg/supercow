# README

## Introduction

For this first time, the script will be able to read some environment variables and compile delphi packages (.dpk) with predefined output folder for generated files. 
Compiler's behavior are controlled by dcc32.cfg file customized for each build job. Inside this file will be stored compiler directives and flags also. 

## Environment Configuration

All configuration, at first time, are read from environment variables according to following schema:
    
      WORKSPACE - Poiting to source code's root path
      os_DELPHI_ROOT - Pointing to Delphi7 root installation path
      os_DCC_FILE - Pointing to DCC32 configuration file
      os_BPL_OUT - Pointing to BPL compiled files root path
      os_DCP_OUT - Pointing to DCP compiled files root path
      os_DCU_OUT - Pointing to DCU compiled files root path
    
## Packages.txt File

This is the file with relative path to every package that must be compiled. If the package are listed here, will be readed by the script and compiled.
We use relative path because of a concatenation with *WORKSPACE* variable, that points to root path of source code. 

## Command Line Compiler (dcc32.exe)    

The command line of compiler consist of the following arguments (all of them included in DCC32 configuration):

      LN --> Package DCP output directory (defined by os_DCP_OUT variable)
      LE --> Package BPL output directory (defined by os_BPL_OUT variable)
      A --> Unit aliases (to use some units with aliases from compiler point of view)
      N --> Unit DCU output directory (defined by os_DCU_OUT - this variable will be used as search path too)
      I --> Variable to include folders to search DCP and DCU files (and others too, like .inc & etc)
      U --> Variable to include folders to search source code to compile (like units included in packages)
      LU --> If you want to include some DCP packages as dependency, use this variable pointing to name of package
      R --> Resource path to compiler search resource configuration
   
## Compiler directives (to put in dcc32.cfg)    

#### Important:

- The compiler directive "-I" (from Include) must be used with careful. Because of a operating system limitation, his value need to be shrinked into multiple statements. 
Otherwise, the compiler will not recognize them and fail to compile.
    

There are some compiler directives too, used when developers need (place -$<switch> plus a [+ / -] signal to enable/disable)
   
   * Compiler switches: -$<state> (defaults are shown below)
        
        * A8  Aligned record fields
        
        * B-  Full boolean Evaluation
        
        * C+  Evaluate assertions at runtime
        
        * D+  Debug information
        
        * G+  Use imported data references
        
        * H+  Use long strings by default
        
        * I+  I/O checking
        
        * J-  Writeable structured consts
        
        * L+  Local debug symbols
        
        * M-  Runtime type info
        
        * O+  Optimization
        
        * P+  Open string params
        
        * Q-  Integer overflow checking
        
        * R-  Range checking
        
        * T-  Typed @ operator
        
        * U-  Pentium(tm)-safe divide
        
        * V+  Strict var-strings
        
        * W-  Generate stack frames
        
        * X+  Extended syntax
        
        * Y+  Symbol reference info
        
        * Z1  Minimum size of enum types    
