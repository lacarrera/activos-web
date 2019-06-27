Partial Class CerrarSesion
    Inherits System.Web.UI.Page
    Private Sub CerrarSesion_Load(sender As Object, e As EventArgs) Handles Me.Load
        Session.Contents.RemoveAll()
        Session.Abandon()
        If Session("SesUsuario") = "" Then
            Me.Response.Redirect("Account/Login.aspx")
        End If
        Response.Cookies.Add(New HttpCookie("ASP.NET_SessionId", ""))
        '  Session("NombreSociedad") = ""
        Session("SesUsuario") = ""
        FormsAuthentication.SignOut()
        '  ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Error to delete Report: " & Me.Request.QueryString("ReturnUrl") & "');", True)
        If Me.Request.QueryString("ReturnUrl") IsNot Nothing Then
            Me.Response.Redirect(Request.QueryString("ReturnUrl").ToString())
        Else
            Me.Response.Redirect("Account/Login.aspx")
        End If
        'Response.Redirect("Account/Login.aspx", True)
    End Sub
End Class
