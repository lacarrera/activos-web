
Imports System.Web.Script.Serialization

Partial Class Configuracion_CambiarContra
    Inherits System.Web.UI.Page
    Dim mu As MembershipUser
    'Dim usuario As Guid = New Guid(ddl_Usuarios.SelectedItem.ToString)
    Protected Sub btn_Restart_Click(sender As Object, e As System.EventArgs) Handles btn_Restart.Click
        Try
            mu = Membership.GetUser(ddl_Usuarios.SelectedItem.ToString, False)
            mu.ChangePassword(mu.ResetPassword(), "inicio10")
            'Tener en cuenta que esta solucion sólo funcionará si el RequiresQuestionAndAnswer de la propiedad se establece en false en el número de miembros de configuración del sistema.
            'Si RequiresQuestionAndAnswer es true, entonces el método ResetPassword debe pasarse a la respuesta de seguridad, de lo contrario, se generará una excepción.
            'Response.Write("<script language='javascript'>alert('Contraseña cambiada');</script>")
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Contraseña Cambiada');", True)

        Catch ex As Exception
            Dim message As String = New JavaScriptSerializer().Serialize(ex.Message.ToString())
            If Session("Idioma") = "IN" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Failed to Change Password: " & message & "');", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Error al cambair contraseña: " & message & "');", True)
            End If
        End Try
    End Sub

    Private Sub Configuracion_CambiarContra_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
    End Sub
End Class
