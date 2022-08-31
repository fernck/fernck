<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'/////////////////////////////////////////////////////////
'/////////////////////////////////////////////////////////
'/////////////////////////////////////////////////////////
'/// Pagina:          DatosRMC-ajax.asp
'/// Fecha creacion:  18/05/2021
'/// Editor:          Fernando Rodriguez
'/// Correo editor:   fexrodriguez@lkqcorp.com
'/// Descripcion:     Procesas para el mostrar el reporte de la pantalla principal en un DIV
'/// 
'/// --- BITACORA DE EDICION -----------------------------
'/// 18/05/2021    Inicio de programacion.
'/// 15/06/2021    Modificacion - Fernando Rodriguez se agrego validacion en prueba de compresion en RMC en la cual se evaluaran los resultados de los 10 cilindros en base a eso mostrar un resultado.
'/// 
'/////////////////////////////////////////////////////////
'/////////////////////////////////////////////////////////
'/////////////////////////////////////////////////////////
%>
<%
'On Error Resume Next 

' ************ Eliminaci�n de cache *****************
Response.Expires = 0
Response.ExpiresAbsolute = Now() - 1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","private"
Response.AddHeader "cache-control","no-cache"
Response.AddHeader "cache-control","no-store"
Response.CacheControl = "no-cache"
Response.Buffer = False

'// Validar si es un usuario con registro previo de acceso //
If (Session("UserFP"&Session.SessionID) = "") And Trim(Request.QueryString("Session")) = "" And Trim(Request.QueryString("Categoria")) = "" Then
  Response.Redirect("/fp_lkq_motors/login.asp")  
End If
%>
<!--#include virtual="/fp_lkq_motors/Connections/conn.asp" -->
<!--#include virtual="/fp_lkq_motors/assets/includes/RFC1321.asp" -->
<!--#include virtual="/fp_lkq_motors/assets/includes/functions.asp" -->
<!--#include virtual="/fp_lkq_motors/assets/includes/aspJSON1.19.asp" -->
<SCRIPT RUNAT=SERVER LANGUAGE=VBSCRIPT>
function DoDateTime(str, nNamedFormat, nLCID)
  dim strRet
  dim nOldLCID

  strRet = str
  If (nLCID > -1) Then
    oldLCID = Session.LCID
  End If

  On Error Resume Next

  If (nLCID > -1) Then
    Session.LCID = nLCID
  End If

  If ((nLCID < 0) Or (Session.LCID = nLCID)) Then
    strRet = FormatDateTime(str, nNamedFormat)
  End If

  If (nLCID > -1) Then
    Session.LCID = oldLCID
  End If

  DoDateTime = strRet
End Function
</SCRIPT>
<% 

strPrograma	= Trim(Request.Form("programa"))
strModelo   = Trim(Request.Form("modelo"))
dtmFechaIni       = Trim(Request.Form("DateIni"))
dtmFechaFin       = Trim(Request.Form("DateFin"))

If strPrograma = "0" Then strPrograma = "" End IF
If strModelo = "0" Then strModelo    = "" End IF

strSQL = ""


If strPrograma <> "" Then
    strSQL = "WHERE R.Program IN ('"&strPrograma&"')"
End If

If strPrograma <> "" Then
    If strModelo <> ""  Then
        strSQL = "AND R.Modelo IN ('"&strModelo&"')"
    End If
Else
    If strModelo <> ""  Then
        strSQL = "WHERE R.Modelo IN ('"&strModelo&"')"
    End If
End If

IF dtmFechaIni <> "-1" AND strPrograma <> ""  OR strModelo <> "" Then
    strSQL = strSQL &"AND CONVERT(VARCHAR,CONVERT(DATETIME,R.DATE,101),112) BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME,'"&dtmFechaIni&"',103),112) AND CONVERT(VARCHAR,CONVERT(DATETIME,'"&dtmFechaFin&"',103),112) "
ElseIF dtmFechaIni <> "-1" AND strPrograma = ""  AND strModelo = "" Then 
    strSQL = strSQL &"WHERE CONVERT(VARCHAR,CONVERT(DATETIME,R.DATE,101),112) BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME,'"&dtmFechaIni&"',103),112) AND CONVERT(VARCHAR,CONVERT(DATETIME,'"&dtmFechaFin&"',103),112) "
Else   
End IF



cmd.CommandTimeout = 3600
cmd.CommandText = "SELECT *,(SELECT MIN(Resultado) FROM( "&_
                                    "SELECT C,Resultado "&_
                                    "FROM ( "&_
                                    "SELECT CYL1COMP,CYL2COMP,CYL3COMP,CYL4COMP,CASE  WHEN CYL5RESULTS <> '-----' THEN CYL5COMP ELSE '0' END AS CYL5COMP ,CASE  WHEN CYL6RESULTS <> '-----' THEN CYL6COMP ELSE '0' END AS CYL6COMP ,CASE  WHEN CYL7RESULTS <> '-----' THEN CYL7COMP ELSE '0' END AS CYL7COMP ,CASE  WHEN CYL8RESULTS <> '-----' THEN CYL8COMP ELSE '0' END AS CYL8COMP ,CASE  WHEN CYL9RESULTS <> '-----' THEN CYL9COMP ELSE '0' END AS CYL9COMP , CASE  WHEN CYL10RESULTS <> '-----' THEN CYL10COMP ELSE '0' END AS CYL10COMP FROM (SELECT * FROM Quality_RMC R WHERE R.RegistroID IN (X.RegistroID) "&_
                                        "UNION ALL "&_
                                    "SELECT * FROM Quality_RMC R  WHERE R.RegistroID IN (X.RegistroID))X "&_
                                    ") C "&_
                                    "UNPIVOT(Resultado FOR [C] IN (CYL1COMP,CYL2COMP,CYL3COMP,CYL4COMP,CYL5COMP,CYL6COMP,CYL7COMP,CYL8COMP,CYL9COMP,CYL10COMP))AS P "&_
                                    ")Y WHERE Resultado > 0)Minimo,(SELECT MAX(Resultado) FROM( "&_
                                    "SELECT C,Resultado "&_
                                    "FROM ( "&_
                                    "SELECT CYL1COMP,CYL2COMP,CYL3COMP,CYL4COMP,CASE  WHEN CYL5RESULTS <> '-----' THEN CYL5COMP ELSE '0' END AS CYL5COMP ,CASE  WHEN CYL6RESULTS <> '-----' THEN CYL6COMP ELSE '0' END AS CYL6COMP ,CASE  WHEN CYL7RESULTS <> '-----' THEN CYL7COMP ELSE '0' END AS CYL7COMP ,CASE  WHEN CYL8RESULTS <> '-----' THEN CYL8COMP ELSE '0' END AS CYL8COMP ,CASE  WHEN CYL9RESULTS <> '-----' THEN CYL9COMP ELSE '0' END AS CYL9COMP , CASE  WHEN CYL10RESULTS <> '-----' THEN CYL10COMP ELSE '0' END AS CYL10COMP FROM (SELECT * FROM Quality_RMC R WHERE R.RegistroID IN (X.RegistroID) "&_
                                        "UNION ALL "&_
                                    "SELECT * FROM Quality_RMC R  WHERE R.RegistroID IN (X.RegistroID))X "&_
                                    ") C "&_
                                    "UNPIVOT(Resultado FOR [C] IN (CYL1COMP,CYL2COMP,CYL3COMP,CYL4COMP,CYL5COMP,CYL6COMP,CYL7COMP,CYL8COMP,CYL9COMP,CYL10COMP))AS P "&_
                                    ")Y WHERE Resultado > 0)Maximo FROM (SELECT DISTINCT R.*,M.Modelo FROM Quality_RMC R INNER JOIN Production_Motors_Multiplant  M ON R.NoSerie = M.Serie INNER JOIN Quality_RMC QR ON QR.RegistroID = R.RegistroID AND R.RegistroID = (SELECT TOP 1 RegistroID FROM Quality_RMC WHERE NoSerie =  QR.NoSerie ORDER BY RegistroID DESC)"&strSQL&" "&_
                    "UNION ALL "&_
                    "SELECT DISTINCT R.*,M.Modelo FROM Quality_RMC R INNER JOIN Production_Motors_Multiplant_History  M ON R.NoSerie = M.Serie  INNER JOIN Quality_RMC QR ON QR.RegistroID = R.RegistroID AND R.RegistroID = (SELECT TOP 1 RegistroID FROM Quality_RMC WHERE NoSerie =  QR.NoSerie ORDER BY RegistroID DESC)"&strSQL&")X ORDER BY Date ASC"
cmd.Prepared = true
Set rsDatos = cmd.Execute



If Not rsDatos.Eof Then

%>
<br />
<div class="row">
    <div class="col-md-12">
        <div class="portlet light bordered">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i>
                    <span class="caption-subject bold uppercase"> Results</span>
                </div>
                <div class="tools"></div>
            </div>
            <div class="portlet-body">
             <table class="table table-striped table-bordered table-hover" width="100%" id="table_data">
                <thead>
                  <tr>
                    <th> </th>
                    <th style="white-space: nowrap;">SN</th>
                    <th>Date</th>
                    <th>Hour</th>
                    <th>Program</th>
                    <th style="white-space: nowrap;">Model</th>
                    <!--<th>Final Result Oil</th>
                    <th>Final Result Compression</th>
                    <th>Final Result Variance PSI</th>
                    <th>Final Result Torque</th>
                    <th>Final Result VVT</th>
                    <th>Final Result Cyl Deact</th>-->
                    <th style="white-space: nowrap;">Final Result</th>
                    <th>Torque</th>
                    <th>Pressure</th>
                    <th style="white-space: nowrap;">Cyl 1</th>
                    <th style="white-space: nowrap;">Cyl 2</th>
                    <th style="white-space: nowrap;">Cyl 3</th>
                    <th style="white-space: nowrap;">Cyl 4</th>
                    <th style="white-space: nowrap;">Cyl 5</th>
                    <th style="white-space: nowrap;">Cyl 6</th>
                    <th style="white-space: nowrap;">Cyl 7</th>
                    <th style="white-space: nowrap;">Cyl 8</th>
                    <th style="white-space: nowrap;">Cyl 9</th>
                    <th style="white-space: nowrap;">Cyl 10</th>
                    <th>Min</th>
                    <th>Max</th>
                    <th style="white-space: nowrap;">Min All</th>
                    <th style="white-space: nowrap;">Max All</th>
                    <th style="white-space: nowrap;">Variance PSI</th>
                    <th style="white-space: nowrap;">Cyl Deact</th>
                    <th>VVT</th>
                    <th>Leak</th>
                    <th>Line</th>
                    
                  </tr>
                </thead>
                <tbody>
                  <% 
                  intContador = 1
                  intJson = 0
                  Set oJSON = New aspJSON

                With oJSON.data  
                  While Not rsDatos.Eof 
                  
                  



                        
                            
                            .Add intJson, oJSON.Collection()                  'Create unnamed object
                            With .item(intJson)
                                .Add "id", intContador
                                .Add "sn", UCase(Trim(rsDatos("NoSerie")))

                            End With

                        

                    

                   
                  intDatos = 0
                  intDatosTotal = 0
                  intDatosCyl = 0
                  intDatosTotalCyl = 0

                '   cmd.CommandText = "SELECT MIN(Resultado) Minimo,MAX(Resultado) Maximo FROM( "&_
                '                     "SELECT C,Resultado "&_
                '                     "FROM ( "&_
                '                     "SELECT CYL1COMP,CYL2COMP,CYL3COMP,CYL4COMP,CASE  WHEN CYL5RESULTS <> '-----' THEN CYL5COMP ELSE '0' END AS CYL5COMP ,CASE  WHEN CYL6RESULTS <> '-----' THEN CYL6COMP ELSE '0' END AS CYL6COMP ,CASE  WHEN CYL7RESULTS <> '-----' THEN CYL7COMP ELSE '0' END AS CYL7COMP ,CASE  WHEN CYL8RESULTS <> '-----' THEN CYL8COMP ELSE '0' END AS CYL8COMP ,CASE  WHEN CYL9RESULTS <> '-----' THEN CYL9COMP ELSE '0' END AS CYL9COMP , CASE  WHEN CYL10RESULTS <> '-----' THEN CYL10COMP ELSE '0' END AS CYL10COMP FROM (SELECT * FROM Quality_RMC R WHERE R.RegistroID IN ("&Trim(rsDatos("RegistroID"))&") "&_
                '                         "UNION ALL "&_
                '                     "SELECT * FROM Quality_RMC R  WHERE R.RegistroID IN ("&Trim(rsDatos("RegistroID"))&"))X "&_
                '                     ") C "&_
                '                     "UNPIVOT(Resultado FOR [C] IN (CYL1COMP,CYL2COMP,CYL3COMP,CYL4COMP,CYL5COMP,CYL6COMP,CYL7COMP,CYL8COMP,CYL9COMP,CYL10COMP))AS P "&_
                '                     ")Y WHERE Resultado > 0"
                '     cmd.Prepared = true
                '     Set rsResultado = cmd.Execute
                  %>
                  <tr>
                    <td width="10" style=""><%=intContador%></td>
                    <td style=""><strong onclick='InfoQualityRMC("<%=UCase(Trim(rsDatos("NoSerie")))%>",0,1)'><%=UCase(Trim(rsDatos("NoSerie")))%></strong></td>
                    <td style=""><%=Trim(rsDatos("Date"))%></td>
                    <td style=""><%=Trim(rsDatos("Time"))%></td>
                    <td nowrap style=""><%=Trim(rsDatos("Program"))%></td>
                    <td style="text-align: center;"><%=UCase(Trim(rsDatos("Modelo")))%></td>
                    <%IF (Trim(rsDatos("RUNINOILPSI")) >= Trim(rsDatos("MINOILPSI")))  Or (Trim(rsDatos("RUNINOILPSI")) <= Trim(rsDatos("MAXOILPSI"))) THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-success" style="font-size:20px;"> Passed </span></td>-->
                        <%
                        intDatos = intDatos + 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSEIF (Trim(rsDatos("RUNINOILPSI")) < Trim(rsDatos("MINOILPSI")))  Or (Trim(rsDatos("RUNINOILPSI")) > Trim(rsDatos("MAXOILPSI"))) THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-danger" style="font-size:20px;"> Failed </span></td>-->
                        <%
                        intDatos = intDatos - 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSE%>
                         <!--<td nowrap style="text-align: center;">-</td>-->
                        <%
                        intDatos = intDatos
                        intDatosTotal = intDatosTotal
                        %>
                    <%END IF%>
                    <%
                    IF Trim(rsDatos("CYL1RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL1RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL2RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL2RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL3RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL3RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL4RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL4RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL5RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL5RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL6RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL6RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL7RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL7RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL8RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL8RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL9RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL9RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%
                    IF Trim(rsDatos("CYL10RESULTS")) = "PASSED" THEN
                        intDatosCyl = intDatosCyl + 1
                        intDatosTotalCyl = intDatosTotalCyl + 1
                    ELSE
                        IF Trim(rsDatos("CYL10RESULTS")) = "FAILED" THEN
                            intDatosCyl = intDatosCyl - 1
                            intDatosTotalCyl = intDatosTotalCyl + 1
                        END IF
                    END IF
                    %>
                    <%IF intDatosTotalCyl = intDatosCyl THEN%>
                        <%
                        intDatos = intDatos + 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSE %>
                        <%
                        intDatos = intDatos - 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%END IF%>
                    <%IF Trim(rsDatos("VariancePSI")) >= 0 AND  Trim(rsDatos("VariancePSI")) <=25 THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-success" style="font-size:20px;"> Passed </span></td>-->
                        <%
                        intDatos = intDatos + 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSEIF Trim(rsDatos("VariancePSI")) < 0 AND  Trim(rsDatos("VariancePSI")) >25 THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-danger" style="font-size:20px;"> Failed </span></td>-->
                        <%
                        intDatos = intDatos - 1
                        intDatosTotal = intDatosTotal + 1
                        %> 
                    <%ELSE%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-default" style="font-size:20px;"> - </span></td>--> 
                        <%
                        intDatos = intDatos
                        intDatosTotal = intDatosTotal
                        %>      
                    <%END IF%>
                    <%IF Trim(rsDatos("TORQUERESULTS")) = "PASSED" THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-success" style="font-size:20px;"> Passed </span></td>-->
                        <%
                        intDatos = intDatos + 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSEIF Trim(rsDatos("TORQUERESULTS")) = "FAILED" THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-danger" style="font-size:20px;"> Failed </span></td>-->
                        <%
                        intDatos = intDatos - 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSE%>
                         <!--<td nowrap style="text-align: center;">-</td>-->
                        <%
                        intDatos = intDatos
                        intDatosTotal = intDatosTotal
                        %>
                    <%END IF%>
                    <%IF Trim(rsDatos("VVTRESULTS")) = "PASSED" THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-success" style="font-size:20px;"> Passed </span></td>-->
                        <%
                        intDatos = intDatos + 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSEIF Trim(rsDatos("VVTRESULTS")) = "FAILED" THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-danger" style="font-size:20px;"> Failed </span></td>-->
                        <%
                        intDatos = intDatos - 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSE%>
                         <!--<td nowrap style="text-align: center;">-</td>-->
                        <%
                        intDatos = intDatos
                        intDatosTotal = intDatosTotal
                        %>
                    <%END IF%>
                    <%IF Trim(rsDatos("CYLDEACTRESULTS")) = "PASSED" THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-success" style="font-size:20px;"> Passed </span></td>-->
                        <%
                        intDatos = intDatos + 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSEIF Trim(rsDatos("CYLDEACTRESULTS")) = "FAILED" THEN%>
                         <!--<td nowrap style="text-align: center;"><span class="label label-danger" style="font-size:20px;"> Failed </span></td>-->
                        <%
                        intDatos = intDatos - 1
                        intDatosTotal = intDatosTotal + 1
                        %>
                    <%ELSE%>
                         <!--<td nowrap style="text-align: center;">-</td>-->
                        <%
                        intDatos = intDatos
                        intDatosTotal = intDatosTotal
                        %>
                    <%END IF%> 
                    <%IF intDatosTotal = intDatos THEN%>
                         <td nowrap style="text-align: center;"><span class="label label-success" style="font-size:20px;"> Passed </span></td>
                    <%ELSEIF intDatosTotal <>  intDatos and intDatos > 0 or  intDatos < intDatosTotal THEN%>
                         <td nowrap style="text-align: center;"><span class="label label-danger" style="font-size:20px;"> Failed </span></td>
                    <%ELSE%>
                    <br>
                        <%=intDatosTotal%><br>
                        <%=intDatos%>
                         <td nowrap style="text-align: center;">-</td>
                    <%END IF%>
                    <td style="text-align: center;" style=""><%=Trim(rsDatos("MAXTRQMEAS"))%></td>
                    <td style="text-align: center;"><%=Trim(rsDatos("RUNINOILPSI"))%></td>
                    <td style="text-align: center;"><%=Trim(rsDatos("CYL1COMP"))%></td>
                    <td style="text-align: center;"><%=Trim(rsDatos("CYL2COMP"))%></td>
                    <td style="text-align: center;"><%=Trim(rsDatos("CYL3COMP"))%></td>
                    <td style="text-align: center;"><%=Trim(rsDatos("CYL4COMP"))%></td>
                    <td style="text-align: center;"><%IF Trim(rsDatos("CYL5RESULTS")) <> "-----" THEN%><%=Trim(rsDatos("CYL5COMP"))%><%ELSE%>0<%END IF%></td>
                    <td style="text-align: center;"><%IF Trim(rsDatos("CYL6RESULTS")) <> "-----" THEN%><%=Trim(rsDatos("CYL6COMP"))%><%ELSE%>0<%END IF%></td>
                    <td style="text-align: center;"><%IF Trim(rsDatos("CYL7RESULTS")) <> "-----" THEN%><%=Trim(rsDatos("CYL7COMP"))%><%ELSE%>0<%END IF%></td>
                    <td nowrap style="text-align: center;"><%IF Trim(rsDatos("CYL8RESULTS")) <> "-----" THEN%><%=Trim(rsDatos("CYL8COMP"))%><%ELSE%>0<%END IF%></td>
                    <td nowrap style="text-align: center;"><%IF Trim(rsDatos("CYL9RESULTS")) <> "-----" THEN%><%=Trim(rsDatos("CYL9COMP"))%><%ELSE%>0<%END IF%></td>
                    <td nowrap style="text-align: center;"><%IF Trim(rsDatos("CYL10RESULTS")) <> "-----" THEN%><%=Trim(rsDatos("CYL10COMP"))%><%ELSE%>0<%END IF%></td>
                    <td nowrap style="text-align: center;"><%=Trim(rsDatos("COMPMINPSI"))%></td>
                    <td nowrap style="text-align: center;"><%=Trim(rsDatos("COMPMAXPSI"))%></td>
                    <td nowrap style="text-align: center;"><%=Trim(rsDatos("Minimo"))%></td>
                    <td nowrap style="text-align: center;"><%=Trim(rsDatos("Maximo"))%></td>
                    <td nowrap style="text-align: center;"><%=Trim(rsDatos("VariancePSI"))%></td>
                    <td nowrap style="text-align: center;"><%IF Trim(rsDatos("CYLDEACTRESULTS")) = "PASSED" Then%><span class="label label-success"><%=Trim(rsDatos("CYLDEACTRESULTS"))%></span><%ELSEIF Trim(rsDatos("CYLDEACTRESULTS")) = "FAILED" Then%><span class="label label-danger"><%=Trim(rsDatos("CYLDEACTRESULTS"))%></span><%Else%><%=Trim(rsDatos("CYLDEACTRESULTS"))%><%End IF%></td>
                    <td nowrap style="text-align: center;"><%IF Trim(rsDatos("VVTRESULTS")) = "PASSED" Then%><span class="label label-success"><%=Trim(rsDatos("VVTRESULTS"))%></span><%ELSEIF Trim(rsDatos("VVTRESULTS")) = "FAILED" Then%><span class="label label-danger"><%=Trim(rsDatos("VVTRESULTS"))%></span><%Else%><%=Trim(rsDatos("VVTRESULTS"))%><%End IF%></td>
                    <td nowrap style="text-align: center;"><%IF Trim(rsDatos("LEAKRESULTS")) = "PASSED" Then%><span class="label label-success"><%=Trim(rsDatos("LEAKRESULTS"))%></span><%ELSEIF Trim(rsDatos("LEAKRESULTS")) = "FAILED" Then%><span class="label label-danger"><%=Trim(rsDatos("LEAKRESULTS"))%></span><%Else%><%=Trim(rsDatos("LEAKRESULTS"))%><%End IF%></td>
                    <td nowrap style="text-align: center;"><%=Trim(rsDatos("Linea"))%></td>                 
                  </tr>
                  <%
                    'rsResultado.Close()
                    'Set rsResultado = Nothing
                    intContador = intContador + 1
                    intJson = intJson + 1
                  rsDatos.MoveNext()
                  'Response.Flush()
                  Wend
                  End With

                   Response.Write oJSON.JSONoutput()                   'Return json string
                  rsDatos.Close()
                  Set rsDatos = Nothing
                  %>
                </tbody>
              </table>
            </div>
        </div>
    </div>
</div>
<%
Else
    Response.Write("<br><div class='col-md-3 portlet box red-sunglo' style='text-align:center'><H4><i class='fa fa-check icon-info font-white'>&nbsp No records for this search </i></H4></div>")
End If
%>