myfile=WScript.Arguments(0)
myfile2=myfile

' msgbox myfile
Function GetCode (Sourcefile)
    Dim slz
    set slz = CreateObject("Adodb.Stream")
    slz.Type = 1
    slz.Mode = 3
    slz.Open
    slz.Position = 0
    slz.Loadfromfile Sourcefile
    Bin=slz.read(2)


    if AscB(MidB(Bin,1,1))=105 and AscB(MidB(Bin,2,1))=100 Then
        ' msgbox AscB(MidB(Bin,1,1))
    	' msgbox AscB(MidB(Bin,2,1))
        codes="WPSHEAD"
	else
		codes="UTF-8"
    end if
    slz.Close
    set slz = Nothing
	GetCode = codes
End Function


oldChartset = GetCode(myfile)
' msgbox oldChartset
if oldChartset="WPSHEAD" then
	

	set stm2=createobject("ADODB.Stream")
	stm2.Charset ="GB2312"
	stm2.Open
	stm2.LoadFromFile myfile
	readfile = stm2.ReadText



	Set Stm1 =CreateObject("ADODB.Stream")
	Stm1.Type = 2
	Stm1.Open
	Stm1.Charset ="UTF-8"
	Stm1.Position = Stm1.Size
	Stm1.WriteText readfile
	Stm1.SaveToFile myfile2,2
	stm2.Close
	Stm1.Close
	set Stm1 = nothing
	set Stm2 = nothing
else
	
end if