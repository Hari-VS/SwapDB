@echo off
setlocal enabledelayedexpansion
	
	:START
	echo ---- Choose your poison ----
	echo ---- 1.Add a new version ----
	echo ---- 2.Edit an existing version ----
	echo ---- 3.Delete an existing version ----
	echo ---- 4.View all versions ----
	echo ---- 5.Exit screen ----

	set /p opt="Enter your choice: "
	
	if %opt%==1 goto :POST
	if %opt%==2	goto :PUT
	if %opt%==3	goto :DELETE
	if %opt%==4	goto :GET
	
	goto :END
	
	:POST
	cls
	echo ---- Add your version ----	
	goto :START
	
	:PUT
	cls
	echo ---- Change your version ----	
	goto :START
	
	:DELETE
	cls
	echo ---- Delete your version ----	
	goto :START
	
	:GET
	cls
	echo ---- Available versions are ----
	echo Version=Path
	for /F %%A in (key.value) do (
		echo %%A 
	)
	goto :START
	
	:END
	