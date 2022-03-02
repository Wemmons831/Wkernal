@echo off


IF /I "%1"=="kernel_source_files " GOTO kernel_source_files 
IF /I "%1"=="kernel_object_files " GOTO kernel_object_files 
GOTO error

:kernel_source_files 
	CALL make.bat =
	CALL make.bat $(shell
	CALL make.bat find
	CALL make.bat src/impl/kernal/
	CALL make.bat -name
	CALL make.bat *.cpp)
	GOTO :EOF

:kernel_object_files 
	CALL make.bat =
	CALL make.bat build/kernal/mainc.o
	GOTO :EOF

:error
    IF "%1"=="" (
        ECHO make: *** No targets specified and no makefile found.  Stop.
    ) ELSE (
        ECHO make: *** No rule to make target '%1%'. Stop.
    )
    GOTO :EOF
