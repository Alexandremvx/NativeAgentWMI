'PROTO: WmiVbsAgent
'RULES:
' [X] Only VBS
' [X] connect to server through http(s)
' [X] get wmi classes to send
' [X] parse and collect wmi info
' [x] send wmi info through http post
' [ ] adjust minimal interval
' [ ] return Exitcode to task scheduler

'################################################'
Dim objWMIClasses, objWMIService
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set objWMIClasses = CreateObject("Scripting.Dictionary")
'On Error resume next
Start
Function Start
 'On error resume next
 log "Iniciando WmiVbsAgent v0.9"
 WMIUrl = GetWMIUrl
 log "ReportAddress=" & WMIUrl
 WMIRequestList = loadRequestList(WMIUrl)
 log "Propriedades requeridas: " & UBound(WMIRequestList)
 WMIForm = collectWMInfo(WMIRequestList)
 'log HTTPPost(WMIUrl,WMIForm)
 
 log HTTPPost(WMIUrl,"Win32_BIOS.SerialNumber=123456")

End Function

Function Log (msg)
  If UsingCScript Then
    sDate = "[" & Year(Now()) & "-" & Right("00" & Month(Now()),2) & "-" & Right("00" & Day(Now()),2) & " " & Right("00" & Hour(Now()),2) & ":" & Right("00" & Minute(Now()),2) & ":" & Right("00" & Second(Now()),2) & "] "
    WScript.StdOut.Write sDate & msg
    Wscript.StdOut.WriteBlankLines(1)
  End If
End Function

Function UsingCScript
  UsingCScript = cbool(LCase(Mid(Wscript.FullName, InstrRev(Wscript.FullName,"\")+1)) = "cscript.exe")
End Function

Function HTTPGet(sUrl)
 On Error Resume Next
 set oHTTP = CreateObject("Microsoft.XMLHTTP")
 oHTTP.open "GET", sUrl,false
 oHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
 oHTTP.send
 if oHTTP.status <> 200 then exitReason 204, "Erro ao acessar [" & sUrl & "] HTTP_" & oHTTP.status
 HTTPGet = oHTTP.responseText
End Function

Function HTTPPost(sUrl, sRequest)
  set oHTTP = CreateObject("Microsoft.XMLHTTP")
  oHTTP.open "POST", sUrl,false
  oHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
  oHTTP.setRequestHeader "Content-Length", Len(sRequest)
  oHTTP.send sRequest
  HTTPPost = oHTTP.responseText
End Function

function loadRequestList(serverUrl)
  dim rList, rSep
  rList = ""
  rSep = ""
  serverRequestList = Split(Replace(HTTPGet(serverUrl),chr(10),";"),";")
  serverRequestListNum = UBound(serverRequestList)
  for each listItem in serverRequestList
	if not (IsBlank(listItem)) then
		rList = rList & rSep & listItem
		rSep = ";"
	end if
  next
  requestList = Split(rList,rSep)
  if UBound(requestList) < 1 then 
	  exitReason 399, "Lista de requerimentos vazia"
  end if
  loadRequestList = requestList
end function

function vSet (eName,eValue)
  write eName & " = " & eValue
  WMIForm = WMIForm & eName & "=" & eValue & "&"
end function

function gWmi (wmiClass)
  Set objWmi = objWMIService.ExecQuery( "SELECT * FROM " & wmiclass) 
  For each objItem in objWmi
    set gWmi = objItem
  next
end function

Function getWMIClass (wClass)
  WMIClass = LCase(wClass)
  if not (objWMIClasses.Exists(WMIClass)) Then
    set objWMIClasses(WMIClass) = objWMIService.ExecQuery( "SELECT * FROM " & WMIClass)
  end if
  set getWMIClass = objWMIClasses(WMIClass)
End Function

function getWMIProp (wPropReq)
  On Error Resume Next
  dim WMIPropList, rSep, wVal
  rSep = ""
  wReq = LCase(wPropReq)
  wReqClass = Split(wReq,".")(0)
  wProp = Split(wReq,".")(1)
  For each wItem in getWMIClass(wReqClass)
    wVal = Eval("wItem."&wProp)
    if not (IsBlank(wVal)) then
      if VarType(Eval("wItem."&wProp)) = (vbVariant + vbArray) then
        wVal = join(Eval("wItem."&wProp),",")
      Else
        wVal = Eval("wItem."&wProp)
      end if
      WMIPropList = WMIPropList & rSep & wVal
      rSep = ","
    end if
    wVal = ""
  Next
  getWMIProp = WMIPropList
end function

function getSystemId (mName)
  Set objWmi = objWMIService.ExecQuery( "SELECT SID FROM Win32_UserAccount WHERE SID LIKE '%-500' AND Domain = '" & mName & "'")
  For each objItem in objWmi
    getSystemId = objItem.sid
  next
end function

function GetWMIUrl
 if WScript.Arguments.Count < 1 then
   exitReason 160, "[ERRO] NECESSARIO ESPECIFICAR A URL DE DESTINO"
 end if
  GetWMIUrl = WScript.Arguments(0)
end function

function getIPAddresses
  Set nics = objWMIService.ExecQuery( "SELECT * FROM Win32_NetworkAdapterConfiguration")
  sep = ""
  ipadd = ""
  For Each nic in nics
    if nic.IPEnabled then
     ipadd = ipadd & sep & join(nic.IPAddress,",")
     sep = ","
    end if
  Next
  getIPAddresses = ipadd
end Function

Function collectWMInfo (wRequestList)
  cProps = ""
  for each WMIProp in wRequestList
   cProps = cProps & WMIProp & "=" & getWMIProp(WMIProp) & "&"
  next
  collectWMInfo = cProps
End Function

function WMIFormFill
  set bios = gWmi("win32_Bios")
  set timezone = gWmi("win32_Timezone")
  set localtime = gWmi("Win32_LocalTime")
  set computersystem = gWmi("Win32_ComputerSystem")
  set operatingsystem = gWmi("Win32_OperatingSystem")
  SID = getSystemId(computersystem.Name)
  IPAddresses = getIPAddresses
  
  if SID = "" then SID = computersystem.Domain
  
  vSet "hostname", computersystem.Name
  vSet "ipaddress", IPAddresses
  vSet "domain", computersystem.Domain
  vSet "timezone", timezone.Caption
  vSet "bias", timezone.bias
  vSet "dlbias", timezone.DaylightBias
  vSet "localtime", localtime.year & right("0" & localtime.month,2) & right("0" & localtime.day,2) & right("0" & localtime.hour,2) & right("0" & localtime.minute,2) & right("0" & localtime.second,2) & operatingsystem.CurrentTimeZone
  vSet "hvi", timezone.DaylightDay & "_" & timezone.DaylightDayOfWeek & "_" & timezone.DaylightMonth
  vSet "hvf", timezone.StandardDay & "_" & timezone.StandardDayOfWeek & "_" & timezone.StandardMonth
  vSet "hvini", strDay(timezone.DaylightDay) & strDayOfWeek(timezone.DaylightDayOfWeek) & strMonth(timezone.DaylightMonth)
  vSet "hvfim", strDay(timezone.StandardDay) & strDayOfWeek(timezone.StandardDayOfWeek) & strMonth(timezone.StandardMonth)
  vSet "so", operatingsystem.Caption
  vSet "sid", SID
  vSet "serialnumber", bios.SerialNumber
end function

function exitReason (eCode,eMessage)
  log eMessage
  wscript.quit(eCode)
end function

Function IsBlank(Value)
 'Refer https://ss64.com/vb/syntax-null.html
 'returns True if Empty or NULL or Zero
 If IsEmpty(Value) or IsNull(Value) Then
  IsBlank = True
 ElseIf VarType(Value) = vbString Then
  If Value = "" Then
   IsBlank = True
  End If
 ElseIf IsObject(Value) Then
  If Value Is Nothing Then
   IsBlank = True
  End If
 ElseIf IsNumeric(Value) Then
  If Value = 0 Then
   IsBlank = True
  End If
 Else
  IsBlank = False
 End If
End Function

Function debugObject(objClass)
 'Generate from: https://www.vbsedit.com/scripts/misc/wmi/scr_1332.asp
 'List All the Properties and Methods for a object
 Dim Returns, i, j
 Returns = Returns & chr(10) & " Class Qualifiers"
 Returns = Returns & chr(10) & "------------------------------"
 i = 1

 For Each objClassQualifier In objClass.Qualifiers_
     If VarType(objClassQualifier.Value) = (vbVariant + vbArray) Then
         strQualifier = i & ". " & objClassQualifier.Name & " = " & Join(objClassQualifier.Value, ",")
     Else
         strQualifier = i & ". " & objClassQualifier.Name & " = " & objClassQualifier.Value
     End If
     Returns = Returns & chr(10) & strQualifier
     strQualifier = ""
     i = i + 1
 Next

 Returns = Returns & chr(10) & " Class Properties and Property Qualifiers"
 Returns = Returns & chr(10) & "------------------------------------------------------"
 i = 1 : j = 1
 
 For Each objClassProperty In objClass.Properties_
     Returns = Returns & chr(10) & i & ". " & objClassProperty.Name
     For Each objPropertyQualifier In objClassProperty.Qualifiers_
         If VarType(objPropertyQualifier.Value) = (vbVariant + vbArray) Then
             strQualifier = i & "." & j & ". " &  objPropertyQualifier.Name & " = " & Join(objPropertyQualifier.Value, ",")
         Else
             strQualifier = i & "." & j & ". " & objPropertyQualifier.Name & " = " & objPropertyQualifier.Value
         End If
         Returns = Returns & chr(10) & strQualifier
         strQualifier = ""
         j = j + 1
     Next
     Returns = Returns & Chr(10)
 chr(10) &     i = i + 1 : j = 1
 Next
 
 Returns = Returns & chr(10) & " Class Methods and Method Qualifiers"
 Returns = Returns & chr(10) & "-------------------------------------------------"
 i = 1 : j = 1
 
 For Each objClassMethod In objClass.Methods_
     Returns = Returns & chr(10) & i & ". " & objClassMethod.Name
     For Each objMethodQualifier In objClassMethod.Qualifiers_
         If VarType(objMethodQualifier.Value) = (vbVariant + vbArray) Then
             strQualifier = i & "." & j & ". " & _
                 objMethodQualifier.Name & " = " & _
             Join(objMethodQualifier.Value, ",")
         Else
             strQualifier = i & "." & j & ". " & _
                 objMethodQualifier.Name & " = " & _
                     objMethodQualifier.Value
         End If
     Returns = Returns & chr(10) & strQualifier
     strQualifier = ""
     j = j + 1
     Next
 
     Returns = Returns & chr(10)
     i = i + 1 : j = 1
 Next
 
 debugObject = Returns
End Function
