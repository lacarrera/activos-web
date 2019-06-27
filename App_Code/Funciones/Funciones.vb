Imports Microsoft.VisualBasic
Imports SAP.Middleware.Connector
Imports System.Data

Public Class Funciones
    Public Shared ApplicationId As String = System.Configuration.ConfigurationManager.AppSettings("ApplicationId").ToString

    Public Shared DestinoSAP As String = System.Configuration.ConfigurationManager.AppSettings("DestinoSAP").ToString
    Public Shared DestinoSAP1 As String = System.Configuration.ConfigurationManager.AppSettings("DestinoSAP1").ToString
    Public Shared Cnx As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Activos").ConnectionString)
    Public Shared cnxOP As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("OnePeople").ConnectionString)
    Public Shared CnxAppS As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("ApplicationServices").ConnectionString)

    Public Shared Sub AbrirBase(ByVal Cnx As Data.SqlClient.SqlConnection)
        If Cnx.State = Data.ConnectionState.Closed Then
            Cnx.Open()
        End If
    End Sub

    Public Shared Sub AbrirBaseAps(ByVal Cnx As Data.SqlClient.SqlConnection)
        If Cnx.State = Data.ConnectionState.Closed Then
            Cnx.Open()
        End If
    End Sub


    Public Shared Sub CerraBase(ByVal Cnx As Data.SqlClient.SqlConnection)
        If Cnx.State = Data.ConnectionState.Open Then
            Cnx.Close()
        End If
    End Sub

    Public Shared Sub CerraBaseAps(ByVal Cnx As Data.SqlClient.SqlConnection)
        If Cnx.State = Data.ConnectionState.Open Then
            Cnx.Close()
        End If
    End Sub

    Public Shared Function ConvertirTablaiRFC(ByVal myrfcTable As IRfcTable) As Data.DataTable

        Dim loTable As New Data.DataTable

        Dim liElement As Integer

        For liElement = 0 To myrfcTable.ElementCount - 1

            Dim metadata As RfcElementMetadata = myrfcTable.GetElementMetadata(liElement)

            loTable.Columns.Add(metadata.Name)

        Next

        For Each Row As IRfcStructure In myrfcTable

            Dim ldr As Data.DataRow = loTable.NewRow()

            For liElement = 0 To myrfcTable.ElementCount - 1

                Dim metadata As RfcElementMetadata = myrfcTable.GetElementMetadata(liElement)

                ldr(metadata.Name) = Row.GetString(metadata.Name)

            Next

            loTable.Rows.Add(ldr)

        Next

        Return loTable

    End Function

    Public Shared Function leer_solped(Control As String, solped As String) As Data.DataTable
        'Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
        'Dim funcion As IRfcFunction ' funcion de sap a descaragr
        'Dim datos As IRfcTable ' 
        'Dim ceros As String = "0000000000"
        'Dim linea As IRfcStructure
        'solped = Right(ceros & solped.Trim(), 10)

        '' FUNCION DE LECTURA DE DETALLE DE SOLPEDS
        '' funcion = dest.Repository.CreateFunction("BAPI_REQUISITION_GETDETAIL")
        'funcion = dest.Repository.CreateFunction("BAPI_PR_GETDETAIL")
        '' PARAMETROS PARA IMPORT
        'funcion.SetValue("NUMBER", solped)
        'funcion.SetValue("ACCOUNT_ASSIGNMENT", "X")
        'funcion.SetValue("ITEM_TEXT", "X")
        'funcion.SetValue("HEADER_TEXT", "X")
        'funcion.SetValue("SERVICES", "X")
        ''Invocar funcion
        'funcion.Invoke(dest)

        'Select Case Control
        '    Case "Resumen"
        '        datos = funcion.GetTable("PRITEM")
        '    Case "NotaCabecera"
        '        datos = funcion.GetTable("PRHEADERTEXT")
        '    Case "ClaseDocumento"

        '        linea = funcion.GetStructure("PRHEADER")

        'End Select


        'Return ConvertirTablaiRFC(datos)

    End Function


End Class
