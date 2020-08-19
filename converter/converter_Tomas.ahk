#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; About
; ------------------------------------------------------
; Txt file converter from format1 to format2, when:

; format1 example - [0.06]3d3h, 3s3h, 3c3h, 3s3d, 3c3d, 3c3s[/0.06], [0.07]Kh9h, Kd9d, Ks9s, Kc9c[/0.07], [0.18]AdJh[/0.18], TdTh, TsTh, TcTh, TsTd, TcTd, TcTs

; format2 example - AA:0.0,A2s:0.0,A2o:0.0,A3s:0.0,A3o:0.0,A4s:0.0,A4o:0.0,A5s:0.0,A5o:0.0,A6s:0.0,A6o:0.0,A7s:0.0,A7o:0.0,A8s:0.0,A8o:0.0,A9s:0.0,A9o:0.0,ATs:0.0,ATo:0.0,AJs:0.0,AJo:0.18,AQs:0.0,AQo:0.0,AKs:0.0,AKo:0.0,22:0.0,32s:0.0,32o:0.0,42s:0.0,42o:0.0,52s:0.0,52o:0.0,62s:0.0,62o:0.0,72s:0.0,72o:0.0,82s:0.0,82o:0.0,92s:0.0,92o:0.0,T2s:0.0,T2o:0.0,J2s:0.0,J2o:0.0,Q2s:0.0,Q2o:0.0,K2s:0.0,K2o:0.0,33:0.06,43s:0.0,43o:0.0,53s:0.0,53o:0.0,63s:0.0,63o:0.0,73s:0.0,73o:0.0,83s:0.0,83o:0.0,93s:0.0,93o:0.0,T3s:0.0,T3o:0.0,J3s:0.0,J3o:0.0,Q3s:0.0,Q3o:0.0,K3s:0.0,K3o:0.0,44:0.0,54s:0.0,54o:0.0,64s:0.0,64o:0.0,74s:0.0,74o:0.0,84s:0.0,84o:0.0,94s:0.0,94o:0.0,T4s:0.0,T4o:0.0,J4s:0.0,J4o:0.0,Q4s:0.0,Q4o:0.0,K4s:0.0,K4o:0.0,55:0.0,65s:0.0,65o:0.0,75s:0.0,75o:0.0,85s:0.0,85o:0.0,95s:0.0,95o:0.0,T5s:0.0,T5o:0.0,J5s:0.0,J5o:0.0,Q5s:0.0,Q5o:0.0,K5s:0.0,K5o:0.0,66:0.0,76s:0.0,76o:0.0,86s:0.0,86o:0.0,96s:0.0,96o:0.0,T6s:0.0,T6o:0.0,J6s:0.0,J6o:0.0,Q6s:0.0,Q6o:0.0,K6s:0.0,K6o:0.0,77:0.0,87s:0.0,87o:0.0,97s:0.0,97o:0.0,T7s:0.0,T7o:0.0,J7s:0.0,J7o:0.0,Q7s:0.0,Q7o:0.0,K7s:0.0,K7o:0.0,88:0.0,98s:0.0,98o:0.0,T8s:0.0,T8o:0.0,J8s:0.0,J8o:0.0,Q8s:0.0,Q8o:0.0,K8s:0.0,K8o:0.0,99:0.0,T9s:0.0,T9o:0.0,J9s:0.0,J9o:0.0,Q9s:0.0,Q9o:0.0,K9s:0.07,K9o:0.0,TT:1.0,JTs:0.0,JTo:0.0,QTs:0.0,QTo:0.0,KTs:0.0,KTo:0.0,JJ:0.0,QJs:0.0,QJo:0.0,KJs:0.0,KJo:0.0,QQ:0.0,KQs:0.0,KQo:0.0,KK:0.0


; How to use
; ------------------------------------------------------
; Put folder for conversion into folder filesToConvert in the same directory as the script. Example of the folder: 100bb, it has SB BTN CO BB folders

folderName := "filesToConvert"
directory = %A_WorkingDir%\%folderName%
filesConverted := 0

card := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K"]
SetFormat, float, 0.3

NumpadDiv::
    createFolderIfDnExist(folderName)

	Loop, Files, %directory%\*.*, D
	{
        posDirectory = %directory%\%A_LoopFileName%
        Loop, Files, %posDirectory%\*.*, D
        {
            vsDirectory = %posDirectory%\%A_LoopFileName%
            Loop, Files, %vsDirectory%\*.txt
            {
                outputFileName = %vsDirectory%\%A_LoopFileName%
                inputFileName = %vsDirectory%\%A_LoopFileName%
                converFile()
                filesConverted++
            }
            Loop, Files, %vsDirectory%\*.*, D
            {
                vsFilesDirectory = %vsDirectory%\%A_LoopFileName%
                Loop, Files, %vsFilesDirectory%\*.txt
                {
                    outputFileName = %vsFilesDirectory%\%A_LoopFileName%
                    inputFileName = %vsFilesDirectory%\%A_LoopFileName%
                    converFile()
                    filesConverted++
                }
            }
        }
    }

    MsgBox %filesConverted% files have been converted

return

ESC::
	ExitApp
return

converFile(){
    global inputFileName
    global combosArrayO := allPossibleCombinations()
    global combosArrayS := allPossibleCombinations()
    global combosArrayP := allPossiblePocketPairs()
    global newFileText := ""

    FileRead, fileText, %inputFileName%
    hand := StrSplit(fileText, ","," ")

    procents := 0.0
    procentTextOpen := 0
    procentTextClosed := 0
    for i, element in hand{
        procentHand := isProcentHand(element)
        if (procentTextClosed && !procentHand || !procentTextOpen && !procentTextClosed)
            procents := 1.0
        if (procentHand){
            procentTextClosed := isProcentTextClosed(element)
            procentTextOpen := isProcentTextOpen(procentTextClosed)
            procents := seperateProcentsFromHand(hand[i], element, procentTextClosed)
            procents := fixProcents(procents)
        }
        putProcInArray(element, procents)
    }
    rewriteFile()
}
fixProcents(procents){
    if (procents >= 98.0)
        procents := 1.0
    else
        procents := procents/100
    return procents
}
rewriteFile(){
    global inputFileName, outputFileName, newFileText

    FileDelete, %inputFileName%
    createNewFileText()
    StringTrimRight, textToAppend, newFileText, 1
    FileAppend ,%textToAppend%, %outputFileName%
}
createNewFileText(){
    writeAllAces()
    writeAllCombosNoAces()
}
writeAllAces(){
    global combosArrayO, combosArrayS, combosArrayP, outputFileName, card, newFileText
    j := 1+1
    procText := combosArrayP[1]
    stCard := card[1]
    ndCard := card[1]
    textToAppend = %stCard%%ndCard%:%procText%,
    newFileText = %newFileText%%textToAppend%
    while(j <= 13){
        procTextS := combosArrayS[1, j]
        procTextO := combosArrayO[1, j]
        stCardS := card[1]
        ndCardS := card[j]
        stCardO := card[1]
        ndCardO := card[j]
        textToAppend = %stCardS%%ndCardS%s:%procTextS%,%stCardO%%ndCardO%o:%procTextO%,
        newFileText = %newFileText%%textToAppend%
    j++
    }
}
writeAllCombosNoAces(){
    global combosArrayO, combosArrayS, combosArrayP, outputFileName, card, newFileText
    i := 2
    while(i <= 13){
        j := i+1
        procText := combosArrayP[i]
        stCard := card[i]
        ndCard := card[i]
        textToAppend = %stCard%%ndCard%:%procText%,
        newFileText = %newFileText%%textToAppend%
        while(j <= 13){
            procTextS := combosArrayS[j, i]
            procTextO := combosArrayO[j, i]
            stCardS := card[j]
            ndCardS := card[i]
            stCardO := card[j]
            ndCardO := card[i]
            textToAppend = %stCardS%%ndCardS%s:%procTextS%,%stCardO%%ndCardO%o:%procTextO%,
            newFileText = %newFileText%%textToAppend%
        j++
        }
    i++
    }
}
appendAllAces(){
    global combosArrayO, combosArrayS, combosArrayP, outputFileName, card
    j := 1+1
    procText := combosArrayP[1]
    stCard := card[1]
    ndCard := card[1]
    textToAppend = %stCard%%ndCard%:%procText%,
    FileAppend ,%textToAppend%, %outputFileName%
    while(j <= 13){
        procTextS := combosArrayS[1, j]
        procTextO := combosArrayO[1, j]
        stCardS := card[1]
        ndCardS := card[j]
        stCardO := card[1]
        ndCardO := card[j]
        textToAppend = %stCardS%%ndCardS%s:%procTextS%,%stCardO%%ndCardO%o:%procTextO%,
        FileAppend ,%textToAppend%, %outputFileName%
    j++
    }
}
appendAllCombosNoAces(){
    global combosArrayO, combosArrayS, combosArrayP, outputFileName, card
    i := 2
    while(i <= 13){
        j := i+1
        procText := combosArrayP[i]
        stCard := card[i]
        ndCard := card[i]
        textToAppend = %stCard%%ndCard%:%procText%,
        FileAppend ,%textToAppend%, %outputFileName%
        while(j <= 13){
            procTextS := combosArrayS[j, i]
            procTextO := combosArrayO[j, i]
            stCardS := card[j]
            ndCardS := card[i]
            stCardO := card[j]
            ndCardO := card[i]
            textToAppend = %stCardS%%ndCardS%s:%procTextS%,%stCardO%%ndCardO%o:%procTextO%,
            FileAppend ,%textToAppend%, %outputFileName%
        j++
        }
    i++
    }
}

putProcInArray(hand, procents){
    global combosArrayO, combosArrayP, combosArrayS

    stSuit := SubStr(hand, 2 ,1)
    ndSuit := SubStr(hand, 4 ,1)

    stCard := cardNm(SubStr(hand, 1 ,1))
    ndCard := cardNm(SubStr(hand, 3 ,1))
    suited := isSuited(stSuit, ndSuit)

    if (stCard = ndCard)
        combosArrayP[stCard] := procents
    else if (suited)
        combosArrayS[stCard, ndCard] := procents
    else if (!suited)
        combosArrayO[stCard, ndCard] := procents
}
cardNm(card){
    switch card
    {
        case "A": return 1
        case "K": return 13
        case "Q": return 12
        case "J": return 11
        case "T": return 10
        default: return card
    }
}
isSuited(stSuit, ndSuit){
    if (stSuit = ndSuit)
        return 1
    else
        return 0
}
isProcentTextOpen(procentTextClosed){
    if (procentTextClosed)
        return 0
    else 
        return 1
}
isProcentTextClosed(name){
        fifthSymbol := SubStr(name, 5, 1)
    if (fifthSymbol = "[")
        return 1
    else 
        return 0
}
isProcentHand(name){
    IfInString, name, [
        return 1
}
seperateProcentsFromHand(text, ByRef element, procentTextClosed){
    if (procentTextClosed){
        wordArray := StrSplit(text, "[","]" "/")
        element := wordArray[1]
        return wordArray[2]
    }
    else{
        wordArray := StrSplit(text, "]","[")
        element := wordArray[2]
        return wordArray[1]
    }
}

allPossibleCombinations() {
    Arr := [] 
    ;;A
    Arr[1, 2] := 0.0
    Arr[1, 3] := 0.0
    Arr[1, 4] := 0.0
    Arr[1, 5] := 0.0
    Arr[1, 6] := 0.0
    Arr[1, 7] := 0.0
    Arr[1, 8] := 0.0
    Arr[1, 9] := 0.0
    Arr[1, 10] := 0.0
    Arr[1, 11] := 0.0
    Arr[1, 12] := 0.0
    Arr[1, 13] := 0.0
    ;;K
    Arr[13, 2] := 0.0
    Arr[13, 3] := 0.0
    Arr[13, 4] := 0.0
    Arr[13, 5] := 0.0
    Arr[13, 6] := 0.0
    Arr[13, 7] := 0.0
    Arr[13, 8] := 0.0
    Arr[13, 9] := 0.0
    Arr[13, 10] := 0.0
    Arr[13, 11] := 0.0
    Arr[13, 12] := 0.0
    ;;Q
    Arr[12, 2] := 0.0
    Arr[12, 3] := 0.0
    Arr[12, 4] := 0.0
    Arr[12, 5] := 0.0
    Arr[12, 6] := 0.0
    Arr[12, 7] := 0.0
    Arr[12, 8] := 0.0
    Arr[12, 9] := 0.0
    Arr[12, 10] := 0.0
    Arr[12, 11] := 0.0
    ;;J
    Arr[11, 2] := 0.0
    Arr[11, 3] := 0.0
    Arr[11, 4] := 0.0
    Arr[11, 5] := 0.0
    Arr[11, 6] := 0.0
    Arr[11, 7] := 0.0
    Arr[11, 8] := 0.0
    Arr[11, 9] := 0.0
    Arr[11, 10] := 0.0
    ;;T
    Arr[10, 2] := 0.0
    Arr[10, 3] := 0.0
    Arr[10, 4] := 0.0
    Arr[10, 5] := 0.0
    Arr[10, 6] := 0.0
    Arr[10, 7] := 0.0
    Arr[10, 8] := 0.0
    Arr[10, 9] := 0.0
    ;;9
    Arr[9, 2] := 0.0
    Arr[9, 3] := 0.0
    Arr[9, 4] := 0.0
    Arr[9, 5] := 0.0
    Arr[9, 6] := 0.0
    Arr[9, 7] := 0.0
    Arr[9, 8] := 0.0
    ;;8
    Arr[8, 2] := 0.0
    Arr[8, 3] := 0.0
    Arr[8, 4] := 0.0
    Arr[8, 5] := 0.0
    Arr[8, 6] := 0.0
    Arr[8, 7] := 0.0
    ;;7
    Arr[7, 2] := 0.0
    Arr[7, 3] := 0.0
    Arr[7, 4] := 0.0
    Arr[7, 5] := 0.0
    Arr[7, 6] := 0.0
    ;;6
    Arr[6, 2] := 0.0
    Arr[6, 3] := 0.0
    Arr[6, 4] := 0.0
    Arr[6, 5] := 0.0
    ;;5
    Arr[5, 2] := 0.0
    Arr[5, 3] := 0.0
    Arr[5, 4] := 0.0
    ;;4
    Arr[4, 2] := 0.0
    Arr[4, 3] := 0.0
    ;;3
    Arr[3, 2] := 0.0

    return Arr
}
allPossiblePocketPairs(){
    Arr1 := [] 
    ;;Pocket pair
    Arr1[1] := 0.0
    Arr1[13] := 0.0
    Arr1[12] := 0.0
    Arr1[11] := 0.0
    Arr1[10] := 0.0
    Arr1[9] := 0.0
    Arr1[8] := 0.0
    Arr1[7] := 0.0
    Arr1[6] := 0.0
    Arr1[5] := 0.0
    Arr1[4] := 0.0
    Arr1[3] := 0.0
    Arr1[2] := 0.0
    return Arr1
}

createFolderIfDnExist(folderName){
    dirName = %A_WorkingDir%\%folderName%
    if FileExist(dirName)
        return 1
    else{
        FileCreateDir, %dirName%
        if (ErrorLevel = 1)
           MsgBox Error1 function createFolderIfDnExist
        else    
           return 1
    }
}