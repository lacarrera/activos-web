Imports System
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic
Partial Class _Default
    Inherits System.Web.UI.Page
    Private Sub _Default_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
        Dim today As Date = Date.Today
        Dim dayDiff As Integer = today.DayOfWeek - DayOfWeek.Monday
        Dim firstDayWeek As Date = today.AddDays(-dayDiff)
        Dim lastDayWeek As Date = firstDayWeek.AddDays(6)
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "semanaActual", "$('#rangoFecha').val('" & firstDayWeek & " - " & lastDayWeek & "');", True)
    End Sub

    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Sub cambiarPresentacion(ByVal presentacionPantalla As String)
        Dim aCookie As New HttpCookie("presentacionPantalla")
        aCookie.Value = presentacionPantalla
        aCookie.Expires = DateTime.Now.AddDays(60)
        HttpContext.Current.Response.Cookies.Add(aCookie)
    End Sub

End Class
