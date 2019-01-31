'PROTO: WmiVbsAgent
'RULES:
' [X] Only VBS
' [X] connect to server through http(s)
' [X] get wmi classes to send
' [X] parse and collect wmi info
' [X] send wmi info through http post
' [X] adjust minimal interval
' [X] return Exitcode to task scheduler

'################################################'
Dim objWMIClasses, objWMIService, hotlap, hotlapTimer
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set objWMIClasses = CreateObject("Scripting.Dictionary")

'On Error resume next
Start

Function Start
  'On error resume next
  log "Iniciando HVM v1.3"
  hotlap = -1
  WMIUrl = GetWMIUrl
  log "ReportURL=" & WMIUrl
  Do
    log "Aguardando: " & cStr(hotlapTimer/60000) & " Minutos" & chr(10)
    Wscript.Sleep hotlapTimer
    objWMIClasses.RemoveAll
    WMIRequestList = loadRequestList(WMIUrl)
    log "Propriedades requeridas: " & UBound(WMIRequestList)
    WMIForm = collectWMInfo(WMIRequestList)
    log "Enviando dados:" & chr(10) & Replace(WMIForm,"&",Chr(10))
    WMIPostResponse = HTTPPost(WMIUrl,WMIForm)
    WMIResponseStatus = applyResponseStatus(WMIPostResponse)
    log "Dados enviados, retorno: " & WMIResponseStatus
    log "Coletas restantes: " & hotlap
  Loop Until hotlap =< 0
  exitReason 0, "Finalizado"
End Function

Function applyResponseStatus(WMIResponse)
  on Error resume next
  for each WR in Split(WMIResponse,";")
    if InStr(WR,"hotlap=")<>0 and hotlap<0 then
      if Split(WR,"=")(1) =< 4 and Split(WR,"=")(1) > 0 then
        hotlap = Split(WR,"=")(1)
        hotlapTimer = 60000 * (60 / hotlap)
      end if
    elseif InStr(WR,"status=")<>0 then
      RStatus = Split(WR,"=")(1)
    end if
  next
  hotlap = hotlap - 1 
  applyResponseStatus = RStatus
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
  On Error Resume Next
  set oHTTP = CreateObject("Microsoft.XMLHTTP")
  oHTTP.open "POST", sUrl,false
  oHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
  oHTTP.setRequestHeader "Content-Length", Len(sRequest)
  oHTTP.send sRequest
  if oHTTP.status <> 200 then exitReason 204, "Erro ao acessar [" & sUrl & "] HTTP_" & oHTTP.status
  HTTPPost = oHTTP.responseText
End Function

function loadRequestList(serverUrl)
  dim rList, rSep
  rList = ""
  rSep = ""
  serverRequestList = Split(Replace(HTTPGet(serverUrl),chr(10),";"),";")
  serverRequestListNum = UBound(serverRequestList)
  for each listItem in serverRequestList
  if (not (IsBlank(listItem)) and (InStr(listItem,"$")<>0) and (InStr(listItem,"$")=InStrRev(listItem,"$"))) then
		rList = rList & rSep & replace(listItem," ","")
		rSep = ";"
	end if
  next
  requestList = Split(rList,rSep)
  if UBound(requestList) < 1 then 
	  exitReason 399, "Lista de requerimentos vazia"
  end if
  loadRequestList = requestList
end function

Function getWMIClass (wClass)
  WMIClass = LCase(wClass)
  if not (objWMIClasses.Exists(WMIClass)) Then
    set objWMIClasses(WMIClass) = objWMIService.ExecQuery( "SELECT * FROM " & WMIClass)
  end if
  set getWMIClass = objWMIClasses(WMIClass)
End Function

Function getWMIProp (wPropReq)
  On Error Resume Next
  dim WMIPropList, rSep, wVal
  rSep = ""
  wReq = LCase(wPropReq)
  wReqClass = Split(wReq,"$")(0)
  wProp = Split(wReq,"$")(1)
  For each wItem in getWMIClass(wReqClass)
    wVal = Eval("wItem."&wProp)
    if wVal <> "" then
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

Function GetWMIUrl
 if WScript.Arguments.Count < 1 then
   exitReason 160, "[ERRO] NECESSARIO ESPECIFICAR A URL DE DESTINO"
 end if
  GetWMIUrl = WScript.Arguments(0)
end function

Function collectWMInfo (wRequestList)
  cProps = ""
  for each WMIProp in wRequestList
   cProps = cProps & WMIProp & "=" & getWMIProp(WMIProp) & "&"
  next
  collectWMInfo = cProps
End Function

Function exitReason (eCode,eMessage)
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
