if (build_status != "release")
{
	SmartStartConsole()
	Logging(1,"opened debug console")
}

Logging(status,text)
{
	IfNotExist, %A_AppData%\FET Loader\logs
	{
		FileCreateDir, %A_AppData%\FET Loader\logs
	}
	if (status = 1)
	{
		out = [LOG]%A_DD%.%A_MM%.%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec% - %text%`n
		puts(out)
		FileAppend, %out%, %A_AppData%\FET Loader\logs\%A_DD%-%A_MM%-%A_YYYY%.log
	}
	if (status = 2)
	{
		out = [ERR]%A_DD%.%A_MM%.%A_YYYY% - %A_Hour%:%A_Min%:%A_Sec% - %text%`n
		puts(out)
		FileAppend, %out%, %A_AppData%\FET Loader\logs\%A_DD%-%A_MM%-%A_YYYY%.log
	}
}


OnError("LogError")

LogError(exception)
{
	Logging(2, "Error on line " exception.Line ": " exception.Message)
	MsgBox, 16, %Script%, %string_error%
    ExitApp
}