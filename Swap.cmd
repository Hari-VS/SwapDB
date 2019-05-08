@echo off
setlocal enabledelayedexpansion
	
	
	:SWAP
	echo ---- Need input for Swapping ----
	echo ---- Available versions are ----
	echo Version=Path
	for /F %%A in (key.value) do (
		echo %%A 
	)
	set /p varver="---- Enter version to swap to: "
	for /F %%A in (key.value) do (
		set tempVer=%%~A
		echo.!tempVer! | findstr /C:"!varver!">nul && ( 
			echo !varver! is found 
			goto :FOUND
		)
	)
	
	:ADD
	echo ---- Version not found. Check available versions ----
	call Edit.cmd
	goto :SWAP
	
	:FOUND
	
	set /p actVer=<activ.v
	echo ---- Active version is %actVer% ----
	if x%actVer%==x%varver% (
		echo ---- Version is already active. Terminating.... ----
		goto :END
	)

	:CHECKINSTALL
	echo ---- Checking for an installation. ----
	set _varpath="%path%"
	set _origDir=%CD% 

	if x%_varpath:E1local=%==x%_varpath% (
		echo ---- Did not locate E1local in your system path. Deinstall will not be run. ----
		goto :SWAP	)

	echo ---- E1Local installation located. Process will proceed as intended. ----
	
	:DEINSTALL
	for %%A in ("%path:;=";"%") do (
		set temp=%%~A
		echo.!temp! | findstr /C:"E1Local">nul && ( set binPath=!temp! ) 
	)
    set deinstallPath=%binPath:bin=deinstall%
	REM echo %deinstallPath%
	echo ---- Switching to E1Local as Working Directory. ----
	pushd %deinstallPath%	
	set rsp=response\deinstall_E1Local.rsp
	set args=-silent
	set bat=deinstall_E1Local.bat
	echo CMD: %bat% %args%
	%bat% %args%
	popd
	echo ---- Control returned. ----
	CD /D %_origDir%

	:INSTALL
	echo ---- Launching installer. ----
	pushd %1
	start OEE12Setup.exe -b -iC:\Oracle\JDE
	popd
	set /p varver=>activ.v
	
	