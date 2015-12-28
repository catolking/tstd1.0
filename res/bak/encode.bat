@echo off

set path=%1"\res\"
dir %path%data\*.csv /A-D /B /S > encodeTmp.log
for /f %%i in (encodeTmp.log) do (  
    Call  %path%bak\changeCode.vbs %%i  
    echo %%i  
)  
del encodeTmp.log

exit