#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

filesChecked := 0
folderName := "checker"
directory = C:\%folderName%

;;format -     C:\checker\folder1\BB
;;Nothing need to change after conversion, folder1 first conversion folder
checkFilesInfolders(){
    global fildesChecked, directory, folderName
    posDirectory = %directory%\folder1
    posDirectory2 = %directory%\folder2
    Loop, Files, %posDirectory%\*.*, D
    {
        vsDirectory = %posDirectory%\%A_LoopFileName%
        vsDirectory2 = %posDirectory2%\%A_LoopFileName%
        Loop, Files, %vsDirectory%\*.txt
        {
            FileRead, fileText1, %vsDirectory%\%A_LoopFileName%
            if(ErrorLevel = 1)
                MsgBox error1
            FileRead, fileText2, %vsDirectory2%\%A_LoopFileName%
            if(ErrorLevel = 1)
                MsgBox error1

            if(fileText1 != fileText2)
                MsgBox not same `r%A_LoopFileName%
            else
                filesChecked++
        }
        Loop, Files, %vsDirectory%\*.*, D
        {
            vsFilesDirectory = %vsDirectory%\%A_LoopFileName%
            vsFilesDirectory2 = %vsDirectory2%\%A_LoopFileName%
            Loop, Files, %vsFilesDirectory%\*.txt
            {
                FileRead, fileText1, %vsFilesDirectory%\%A_LoopFileName%
                if(ErrorLevel = 1)
                    MsgBox error1
                FileRead, fileText2, %vsFilesDirectory2%\%A_LoopFileName%
                if(ErrorLevel = 1)
                    MsgBox error1

                if(fileText1 != fileText2)
                    MsgBox not same `r%A_LoopFileName%
                else
                    filesChecked++
            }
        }
    }

    MsgBox, all %filesChecked% are the same
}

;;format -     C:\checker\folder\CO_2.0bb_BTN_6.0bb.txt
;;Need to put all txt files of conversion 1 to folder1
checkFiles(){
    global filesChecked
    Loop, Files, C:\checker\folder1\*.txt
    {
        FileRead, fileText1, C:\checker\folder1\%A_LoopFileName%
        if(ErrorLevel = 1)
            MsgBox error1
        FileRead, fileText2, C:\checker\folder2\%A_LoopFileName%
        if(ErrorLevel = 1)
            MsgBox error1

        if(fileText1 != fileText2)
            MsgBox not same `r%A_LoopFileName%
        else
            filesChecked++
    }

    MsgBox, all %filesChecked% are the same
}

\::
    checkFilesInfolders()
return

ESC::
	ExitApp
return


