rem we need this batch script to correctly load the VS05 environment

set VSPATH=C:\Program Files\Microsoft Visual Studio 8
rem set VCPATH=%VSPATH%\VC
rem set PATH=%VCPATH%\vcpackages;%VCPATH%\bin;%PATH%

call "%VSPATH%\Common7\Tools\vsvars32.bat"

vcbuild %1 "Release|Win32" /useenv

