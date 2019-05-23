@echo off
setlocal enabledelayedexpansion
	
	:SETUP
	set _origDir=%CD%
	set swapInsLog=%_origDir%\swapInstaller.log
	set swapUnInsLog=%_origDir%\swapUnInstaller.log
	set remCount=0
	set _varpath="%path%"
	set /p actVer=<activ.v
	
	
	:CLEANUP
	copy /y NUL %swapInsLog% >NUL
	copy /y NUL %swapUnInsLog% >NUL
	
	:SWAP
	echo ---- Need input for Swapping ----
	echo ---- Available versions are ----
	echo Version=Path
	for /F %%A in (key.value) do (
		echo %%A 
	)
	echo ---- Active version is %actVer% ----
	set /p varver="---- Enter version to swap to: "
	for /F %%A in (key.value) do (
		set tempVer=%%~A
		echo.!tempVer! | findstr /C:"!varver!">nul && ( 
			echo Version !varver! is found 
			set newPath=!tempVer!
			goto :FOUND
		)
	)
	
	:EDIT
	echo ---- Version not found. Opening the Editor ----
	goto :SWAP
	
	:FOUND	
	if x%actVer%==x%varver% (
		echo ---- Version is already active. Terminating.... ----
		goto :DONE
	)

	:CHECKINSTALL
	if %remCount%==1 (
		echo ---- Could not remove the installation. User must check the logs to see the error. Exiting process. ----
		goto :DONE )
	
	echo ---- Checking for an installation. ----
	if x%_varpath:E1local=%==x%_varpath% (
		echo ---- Did not locate E1local in your system path. ----
		goto :INSTALL	)

	echo ---- E1Local installation located. Process will proceed as intended. ----
	
	:DEINSTALL
	for %%A in ("%path:;=";"%") do (
		set temp=%%~A
		echo.!temp! | findstr /C:"E1Local">nul && ( set binPath=!temp! ) 
	)
    set deinstallPath=%binPath:bin=deinstall%
	REM echo %deinstallPath%
	echo ---- Switching to E1Local as Working Directory. ----
	echo DEINSTALLPATH %deinstallPath%
	pushd %deinstallPath%	
	set rsp=\response\deinstall_E1Local.rsp
	set rspPath=%deinstallPath%%rsp%
	set rspPath=!rspPath: =!
	set args=-silent -paramfile %rspPath% 
	set bat=deinstall_E1Local.bat
	echo CMD: %bat% %args%
	call %bat% %args% > swapUnInslog
	popd
	set remCount=1
	echo ---- Control returned. ----
	CD /D %_origDir%
	goto :CHECKINSTALL

	:INSTALL
	echo ---- Launching installer. ----
	set newPath=!newPath:%varver%:=!
	echo INSTALLPATH %newPath%
	pushd %newPath%
	call OEE12Setup.exe -b -iC:\Oracle\AutoSwap\%varver% > swapInsLog
	popd
    @echo %varver%> activ.v
	
	:DONE
	exit
	
