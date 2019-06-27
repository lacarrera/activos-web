Partial Class Configuracion_ActivarUsuario
    Inherits System.Web.UI.Page
    Protected Sub btn_activate_Click(sender As Object, e As System.EventArgs) Handles btn_activate.Click
        Dim chbTemp As CheckBox
        Dim cadena As String = ""
        Dim sql As String = ""
        Dim nvoEstatus As String = ""
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
        Try
            For Each fila As GridViewRow In GridView1.Rows
                chbTemp = CType(fila.Cells(0).FindControl("CheckBox_Autorizar"), CheckBox)
                If chbTemp.Checked Then
                    cadena = cadena & ",'" & fila.Cells(2).Text & "'"
                End If
            Next
            If cadena.Length > 0 Then
                cadena = cadena.Substring(1)
            Else
                Exit Sub
            End If
            Funciones.AbrirBaseAps(Funciones.CnxAppS)
            sql = "UPDATE Autenticacion.dbo.aspnet_Membership SET IsApproved = 1 WHERE UserId IN ( SELECT UserId FROM Autenticacion.dbo.aspnet_Users WHERE UserName IN (" & cadena & ") AND ApplicationId = '" & Funciones.ApplicationId & "')"
            cmd.CommandText = sql
            If cmd.ExecuteNonQuery() > 0 Then
                SDSActivarUsuarios.DataBind()
                GridView1.DataBind()
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActivarUsuarios", "alerta('Usuario Activado ');", True)
            End If
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActivarUsuarios", "alertaError('Error: " & ex.Message & "');", True)
        Finally
            Funciones.CerraBaseAps(Funciones.CnxAppS)
        End Try
    End Sub

    Protected Sub btn_inactivate_Click(sender As Object, e As System.EventArgs) Handles btn_inactivate.Click
        Dim chbTemp As CheckBox
        Dim cadena As String = ""
        Dim sql As String = ""
        Dim nvoEstatus As String = ""
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
        Try
            For Each fila As GridViewRow In GridView1.Rows
                chbTemp = CType(fila.Cells(0).FindControl("CheckBox_Autorizar"), CheckBox)
                If chbTemp.Checked Then
                    cadena = cadena & ",'" & fila.Cells(2).Text & "'"
                End If
            Next
            If cadena.Length > 0 Then
                cadena = cadena.Substring(1)
            Else
                Exit Sub
            End If
            Funciones.AbrirBase(Funciones.CnxAppS)
            sql = "UPDATE Autenticacion.dbo.aspnet_Membership SET IsApproved = 0 WHERE UserId IN ( SELECT UserId FROM Autenticacion.dbo.aspnet_Users WHERE UserName IN (" & cadena & ") AND ApplicationId = '" & Funciones.ApplicationId & "')"
            cmd.CommandText = sql
            If cmd.ExecuteNonQuery() > 0 Then
                SDSActivarUsuarios.DataBind()
                GridView1.DataBind()
                sql = "UPDATE Autenticacion.dbo.aspnet_Users SET FechaUltimaBaja = GetDate() WHERE UserName IN (" & cadena & ") AND ApplicationId = '" & Funciones.ApplicationId & "'"
                cmd.CommandText = sql
                cmd.ExecuteNonQuery()
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActivarUsuarios", "alerta('Usario Desactivado');", True)
            End If
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActivarUsuarios", "alertaError('Error: " & ex.Message & "');", True)
        Finally
            Funciones.CerraBase(Funciones.CnxAppS)
        End Try
    End Sub
    Private Sub Configuracion_ActivarUsuario_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
    End Sub
End Class
