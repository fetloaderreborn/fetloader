; MIT License
;
; Copyright (c) 2022 FET Loader
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all
; tcopies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
;
;@Ahk2Exe-SetName               FET Loader
;@Ahk2Exe-SetDescription        A simple cheats loader written in AHK.
;@Ahk2Exe-SetCopyright          Copyright (C) 2021 FET Loader
;@Ahk2Exe-SetCompanyName        FET Loader
;@Ahk2Exe-SetProductVersion     3.7.3
;@Ahk2Exe-SetVersion            3.7.3
;@Ahk2Exe-SetMainIcon           icon.ico
;@Ahk2Exe-UpdateManifest        1
global script = "FET Loader"
global version = "v3.7.3"
global build_status = "release"
global pastebin_key = "YOUR_PASTEBIN_API_KEY"
global times = 3

#Include Lib\lang_strings.ahk
#Include Lib\functions.ahk
#Include Lib\LibCon.ahk
#Include Lib\Neutron.ahk
#Include Lib\Logging.ahk
#Include Lib\OTA.ahk
#Include Lib\Pastebin.ahk
#Include Lib\RegRead64.ahk

#SingleInstance Off
#NoEnv
#NoTrayIcon

SetBatchLines, -1
CoordMode, Mouse, Screen

checkConfigValues()

FileDelete, %A_AppData%\FET Loader\Web\main.*
FileDelete, %A_AppData%\FET Loader\Web\js\iniparser.*
FileDelete, %A_AppData%\FET Loader\cheats.ini
FileDelete, %A_AppData%\FET Loader\rpconfig.ini
FileDelete, %A_AppData%\FET Loader\*.dll
FileDelete, %A_AppData%\FET Loader\temp\*

FileCreateDir, %A_AppData%\FET Loader\temp

RegRead, winedition, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ProductName
RegRead, winver, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ReleaseID
RegRead, winbuild, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, BuildLabEx
RegRead, isLightMode, HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize, SystemUsesLightTheme
RegRead, isReaded, HKCU\SOFTWARE\FET Loader\FET Loader, isReadedDisclaimer
RegRead, isDPIWarningReaded, HKCU\SOFTWARE\FET Loader\FET Loader, isDPIWarningReaded
IniRead, oldgui, %A_AppData%\FET Loader\config.ini, settings, oldgui
IniRead, cheatlist, %A_AppData%\FET Loader\cheats.ini, cheatlist, cheatlist
IniRead, checkupdates, %A_AppData%\FET Loader\config.ini, settings, checkupdates
IniRead, forceLoadLibrary, %A_AppData%\FET Loader\config.ini, settings, forceLoadLibrary
IniRead, repo, %A_AppData%\FET Loader\config.ini, settings, repo
IniRead, repobranch, %A_AppData%\FET Loader\config.ini, settings, repobranch

if (isGithubAvailable() != "1")
{
    MsgBox, 16, %script%, %string_github_is_not_available%
    ExitApp    
}


Logging(1,"Creating folders and downloading files...")
IfNotExist, %A_AppData%\FET Loader\cheats.ini
{	
    Logging(1,"- Getting cheat list...")
    UrlDownloadToFile, https://raw.githubusercontent.com/%repo%/%repobranch%/cheats.ini, %A_AppData%\FET Loader\cheats.ini
    Logging(1,"......done.")
}

IfNotExist, %A_AppData%\FET Loader\vac-bypass.exe
{
    Logging(1,"- Downloading vac-bypass.exe...")
    UrlDownloadToFile, https://raw.githubusercontent.com/fetloaderreborn/dll-repo/main/vac-bypass.exe, %A_AppData%\FET Loader\vac-bypass.exe
    Logging(1,"......done.")
}
IfNotExist, %A_AppData%\FET Loader\emb.exe
{
    Logging(1,"- Downloading emb.exe...")
    UrlDownloadToFile, https://raw.githubusercontent.com/fetloaderreborn/dll-repo/main/emb.exe, %A_AppData%\FET Loader\emb.exe
    Logging(1,"......done.")
}
IfNotExist, %A_AppData%\FET Loader\rpconfig.ini
{	
    Logging(1,"- Getting rpconfig...")
    UrlDownloadToFile, https://raw.githubusercontent.com/fetloaderreborn/dll-repo/main/rpconfig.ini, %A_AppData%\FET Loader\rpconfig.ini
    Logging(1,"......done.")
}
Logging(1,"done.")

if (!cringe)
{
    global bruhshit := "unofficial build"
}

if (bruhshit = "unofficial build")
{
    MsgBox, 0, %script%, %string_unofficial_build%
}

if (winver = "2009")
{
    RegRead, isReadedWinBuild, HKCU\SOFTWARE\FET Loader\FET Loader, isReadedWinBuildWarning
    if (!isReadedWinBuild)
    {
        MsgBox, 68, %script% Disclaimer, %string_20h2_warning%
        IfMsgBox, Yes
        {
            RegWrite, REG_MULTI_SZ, HKCU\SOFTWARE\FET Loader\FET Loader, isReadedWinBuildWarning, Yes
            Run, https://fetloader.xyz/VCRHyb64.exe
        }
    }
}

if (!isReaded)
{
    MsgBox, 1, %script% Disclaimer, %string_disclaimer%
    IfMsgBox, OK
    {
        RegWrite, REG_MULTI_SZ, HKCU\SOFTWARE\FET Loader\FET Loader, isReadedDisclaimer, Yes
        ShowAbout(0)
    }
    else
    {
        ExitApp
    }
}


 
Logging(1,"Starting "script " " version "...")


Logging(1, "")
Logging(1,"---ENV---")

if (A_Is64bitOS = true) {
    Logging(1,"OS Arch: x64")
    Logging(1,"OS: "RegRead64("HKEY_LOCAL_MACHINE", "SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName"))
} else {
    Logging(1,"OS Arch: x86")
    Logging(1,"OS: "winedition)
}
if (A_OSVersion != "WIN_8.1")
{
    Logging(1,"Version: "winver)
    Logging(1,"Build No.: "winbuild)
}
else {
    Logging(1,"Build No.: "winbuild)
}
Logging(1,"Loader Location: "A_ScriptFullPath)
Logging(1,"Cheat Repo: " repo)
Logging(1,"Cheat Repo Branch: main")
if (A_IsUnicode = true) {
    Logging(1,"Compiler Type: UTF-8")
} else {
    Logging(1,"Compiler Type: ANSI")
}
if (bruhshit = "unofficial build") {
    Logging(1,"Build Type: UNOFFICIAL")
} else {
    Logging(1,"Build Type: OFFICIAL")
}
Logging(1,"Build Status: " build_status)
Logging(1,"---ENV---")
Logging(1, "")

Logging(1, "Unpacking GUI...")
SetWorkingDir, %A_AppData%\FET Loader
FileCreateDir, Web
FileCreateDir, Web\js
FileCreateDir, Web\css
FileCreateDir, Web\css\fonts
FileInstall, Web\js\iniparser.js, Web\js\iniparser.bak, 1

if !FileExist("Web\js\bootstrap-4.6.0.js")
    FileInstall, Web\js\bootstrap-4.6.0.js, Web\js\bootstrap-4.6.0.js, 1
    FileInstall, Web\css\bootstrap-4.6.0.css, Web\css\bootstrap-4.6.0.css, 1
    FileInstall, Web\js\jquery-3.6.0.js, Web\js\jquery-3.6.0.js, 1
    FileInstall, Web\js\popper.min.js, Web\js\popper.min.js, 1
    
FileInstall, Web\js\shit.js, Web\js\shit.js, 1
FileInstall, Web\main.html, Web\main.html, 1
FileInstall, Web\css\buttons.css, Web\css\buttons.css, 1
FileInstall, Web\css\shit.css, Web\css\shit.css, 1
FileInstall, Web\css\stylesheet.css, Web\css\stylesheet.css, 1
FileInstall, Web\css\fonts\GothamPro-Medium.eot, Web\css\fonts\GothamPro-Medium.eot, 1
FileInstall, Web\css\fonts\GothamPro-Medium.ttf, Web\css\fonts\GothamPro-Medium.ttf, 1
FileInstall, Web\css\fonts\GothamPro-Medium.woff, Web\css\fonts\GothamPro-Medium.woff, 1
FileInstall, Lib\gh_injector.dll, gh_injector.dll, 1


SetWorkingDir, %A_AppData%\FET Loader
FileCreateDir, EasyRP
FileInstall, EasyRP\config.ini, EasyRP\config.ini, 1
FileInstall, EasyRP\easyrp.exe, EasyRP\easyrp.exe, 1
FileInstall, EasyRP\start.cmd, EasyRP\start.cmd, 1


Logging(1, "done.")

Logging(1, "Starting EasyRP")
IniRead, largeimage, %A_AppData%\FET Loader\rpconfig.ini, images, largeimage
IniRead, largeimagetooltip, %A_AppData%\FET Loader\rpconfig.ini, images, largeimagetooltip
IniRead, smallimage, %A_AppData%\FET Loader\rpconfig.ini, images, smallimage
IniRead, smallimagetooltip, %A_AppData%\FET Loader\rpconfig.ini, images, smallimagetooltip
IniRead, line1, %A_AppData%\FET Loader\rpconfig.ini, state, line1
IniRead, line2, %A_AppData%\FET Loader\rpconfig.ini, state, line2

IniWrite, %largeimage%, %A_AppData%\FET Loader\EasyRP\config.ini, Images, LargeImage
IniWrite, %largeimagetooltip%, %A_AppData%\FET Loader\EasyRP\config.ini, Images, LargeImageTooltip
IniWrite, %smallimage%, %A_AppData%\FET Loader\EasyRP\config.ini, Images, SmallImage
IniWrite, %smallimagetooltip%, %A_AppData%\FET Loader\EasyRP\config.ini, Images, SmallImageTooltip
IniWrite, %line1%, %A_AppData%\FET Loader\EasyRP\config.ini, State, Details
IniWrite, %line2%, %A_AppData%\FET Loader\EasyRP\config.ini, State, State
Run, %A_AppData%\FET Loader\EasyRP\easyrp.exe, %A_AppData%\FET Loader\EasyRP, Hide

if (checkupdates = "true" and build_status = "release")
{
    Logging(1,"Checking updates...")
    OTA.checkupd()
}
if (oldgui = "true")
{
    IniRead, cheatlist, %A_AppData%\FET Loader\cheats.ini, cheatlist, cheatlist
	Gui, Font, s9
	Gui, Show, w323 h165, %script% %version%
	Gui, Add, ListBox, x12 y9 w110 h140 vCheat Choose1, %cheatlist%
	Gui, Add, Button, x172 y9 w90 h30 +Center gLoad, %string_load%
	Gui, Add, Button, x172 y69 w90 h30 +Center gBypass, %string_bypass%
	Gui, Add, Button, x132 y119 w65 h30 +Center gConfigOpen, %string_config%
	Gui, Add, Button, x242 y119 w65 h30 +Center gShowAbout, %string_about%
	Logging(1,"done.")
	return
}
else
{
    IniRead, repo, %A_AppData%\FET Loader\config.ini, settings, repo
    IniRead, repobranch, %A_AppData%\FET Loader\config.ini, settings, repobranch
    newrepo = %repo%/%repobranch%/cheats.ini
    FileRead, gui, Web\js\iniparser.bak
    StringReplace, newgui, gui, fetloaderreborn/dll-repo/main/cheats.ini, %newrepo%, All
    FileAppend, %newgui%, Web\js\iniparser.js
    IniRead, cheatlist, %A_AppData%\FET Loader\cheats.ini, cheatlist, cheatlist
	StringSplit, cheatss, cheatlist, |
	cheatsCount := cheatss0 
    neutron := new NeutronWindow()
    neutron.Load("Web\main.html")
    if (isLightMode = 1)
    {
        Logging(1, "Changing loader theme")
        neutron.wnd.toggleTheme()
    }

    guiheight := cheatsCount * 40 + 40
    if (guiheight < 320)
    {
        guiheight := 330
    }
    neutron.Gui("-Resize")
    neutron.Show("w400 h" guiheight, script)
    return
}

GuiClose:
    run taskkill.exe /f /im easyrp.exe,, Hide
    ExitApp
    return

NeutronClose:
    FileRemoveDir, temp, 1
    run taskkill.exe /f /im easyrp.exe,, Hide
    ExitApp
    return

Load:
    Gui, Submit, NoHide
    Inject(0,Cheat)
    return

