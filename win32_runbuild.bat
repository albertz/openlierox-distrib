rem we need this batch script to correctly load the VS05 environment

set VSPATH=C:\Program Files\Microsoft Visual Studio 8


set VCPATH=%VSPATH%\VC
set PATH=%VCPATH%\vcpackages;%VCPATH%\bin;%PATH%

rem call "%VSPATH%\Common7\Tools\vsvars32.bat"

vcbuild %1 "Release|Win32" /useenv


pause

