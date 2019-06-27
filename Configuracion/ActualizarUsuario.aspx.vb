Imports System.Web.Configuration
Imports System.Web.Script.Serialization
Partial Class Configuracion_ActualizarUsuario
    Inherits System.Web.UI.Page
    Private Sub Configuracion_ActualizarUsuario_LoadComplete(sender As Object, e As EventArgs) Handles Me.LoadComplete
        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
    End Sub
    Protected Sub btn_Insertar_Click(sender As Object, e As System.EventArgs) Handles btn_Insertar.Click
        hf_pestana.Value = "sociedades"
        Session("Detalles") = Nothing
        Session("Detalles") = "sociedades"
        Dim sql As String = ""
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
        Try
            If ddl_UsuariosActivos.SelectedValue = "" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: Seleccione un Usuario');", True)
                Return
            End If
            If ddl_Sociedad.SelectedValue = "" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: Seleccione una Sociedad');", True)
                Return
            End If
            Funciones.AbrirBase(Funciones.CnxAppS)
            sql = "SELECT Count(Sociedad) FROM Autenticacion.dbo.aspnet_Sociedades WHERE ApplicationId = '" & Funciones.ApplicationId & "' AND UserId = '" & ddl_UsuariosActivos.SelectedValue & "' AND Sociedad = '" & ddl_Sociedad.SelectedValue & "'"
            cmd.CommandText = sql
            If Not cmd.ExecuteScalar > 0 Then
                sql = "INSERT INTO Autenticacion.dbo.aspnet_Sociedades VALUES('" & Funciones.ApplicationId & "','" & ddl_UsuariosActivos.SelectedValue & "','" & ddl_Sociedad.SelectedValue & "')"
                cmd.CommandText = sql
                If cmd.ExecuteNonQuery() > 0 Then
                    ' llenar_sociedades_usuarios()

                    If Session("LANG") = "IN" Then
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Aggregate Society');", True)
                    Else
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Sociedad Agregada ');", True)
                    End If
                End If
            Else
                If Session("LANG") = "en" Then
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: The user is already assigned in that society');", True)
                Else
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: El Usuario ya tiene asignada esa Sociedad');", True)
                End If
            End If
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: " & ex.Message.Replace("'", "") & "');", True)
        Finally
            Funciones.CerraBase(Funciones.CnxAppS)
        End Try
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Carga PP&E a SAP", "$(document).ready(function () { $('[id*=tab2]').click(); });", True)
    End Sub
    Protected Sub btn_Quitar_Click(sender As Object, e As System.EventArgs) Handles btn_Quitar.Click
        hf_pestana.Value = "sociedades"
        Session("Detalles") = Nothing
        Session("Detalles") = "sociedades"
        Dim chbTemp As CheckBox
        Dim cadena As String = ""
        Dim sql As String = ""
        Dim nvoEstatus As String = ""
        Dim idusuario As String
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
        Try
            Funciones.AbrirBase(Funciones.CnxAppS)
            For Each fila As GridViewRow In GridView2.Rows
                chbTemp = CType(fila.Cells(0).FindControl("CheckBox_Autorizar"), CheckBox)
                If chbTemp.Checked Then
                    sql = "SELECT UserId FROM Autenticacion.dbo.aspnet_Users WHERE ApplicationId = '" & Funciones.ApplicationId & "' AND UserName ='" & fila.Cells(1).Text & "'"
                    cmd.CommandText = sql
                    idusuario = cmd.ExecuteScalar.ToString
                    sql = "DELETE FROM Autenticacion.dbo.aspnet_Sociedades WHERE ApplicationId = '" & Funciones.ApplicationId & "' AND UserId = '" & idusuario & "' AND Sociedad = '" & fila.Cells(3).Text & "'"
                    cmd.CommandText = sql
                    If cmd.ExecuteNonQuery() > 0 Then
                        SDSAgregarQuitarSociedad.DataBind()
                        GridView2.DataBind()
                        If Session("LANG") = "en" Then
                            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Society Deleted');", True)
                        Else
                            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Sociedad Removida');", True)
                        End If
                    End If
                End If
            Next
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alertaError('Error: " & ex.Message.Replace("'", "") & "');", True)
        Finally
            Funciones.CerraBase(Funciones.CnxAppS)
        End Try

    End Sub
    Protected Sub btn_AsignarRol_Click(sender As Object, e As System.EventArgs) Handles btn_AsignarRol.Click
        Dim sql As String = ""
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
        Try
            Funciones.AbrirBase(Funciones.CnxAppS)
            sql = "SELECT COUNT(*) FROM Autenticacion.dbo.aspnet_UsersInRoles WHERE UserId = '" & ddl_UsuariosActivosTab3.SelectedValue & "' AND RoleId = '" & ddl_Roles.SelectedValue & "'"
            cmd.CommandText = sql
            If Not cmd.ExecuteScalar > 0 Then
                sql = "INSERT INTO Autenticacion.dbo.aspnet_UsersInRoles VALUES('" & ddl_UsuariosActivosTab3.SelectedValue & "','" & ddl_Roles.SelectedValue & "')"
                cmd.CommandText = sql
                If cmd.ExecuteNonQuery > 0 Then
                    SDSAsignacionRoles.DataBind()
                    GridView3.DataBind()
                    SDSCambiarSociedad.DataBind()
                    GridView1.DataBind()
                    If Session("LANG") = "IN" Then
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Rol added to User ');", True)
                    Else
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Rol Agregado al Usuario');", True)
                    End If
                End If
            Else
                If Session("LANG") = "IN" Then
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: The user got already assigned that Rol');", True)
                Else
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: El Usuario ya tiene asignado ese Rol');", True)
                End If
            End If
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta('Error: " & ex.Message.Replace("'", "") & "');", True)
        Finally
            Funciones.CerraBase(Funciones.CnxAppS)
        End Try
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Carga PP&E a SAP", "$(document).ready(function () { $('[id*=tab3]').click(); });", True)
    End Sub
    Protected Sub btn_QuitarRol_Click(sender As Object, e As System.EventArgs) Handles btn_QuitarRol.Click
        Dim chbTemp As CheckBox
        Dim cadena As String = ""
        Dim sql As String = ""
        Dim userId, RoleId As String
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
        Try
            Funciones.AbrirBase(Funciones.CnxAppS)
            For Each fila As GridViewRow In GridView3.Rows
                chbTemp = CType(fila.Cells(0).FindControl("CheckBox_AutorizarTab3"), CheckBox)
                If chbTemp.Checked Then
                    cmd.CommandText = "SELECT UserId FROM Autenticacion.dbo.aspnet_Users WHERE ApplicationId = '" & Funciones.ApplicationId & "' AND UserName = '" & fila.Cells(1).Text & "'"
                    userId = cmd.ExecuteScalar.ToString
                    cmd.CommandText = "SELECT RoleId FROM Autenticacion.dbo.aspnet_Roles WHERE ApplicationId = '" & Funciones.ApplicationId & "' AND RoleName = '" & fila.Cells(4).Text & "'"
                    RoleId = cmd.ExecuteScalar.ToString
                    sql = "DELETE FROM Autenticacion.dbo.aspnet_UsersInRoles WHERE UserId = '" & userId & "' AND RoleId = '" & RoleId & "'"
                    cmd.CommandText = sql
                    If cmd.ExecuteNonQuery > 0 Then
                        SDSAsignacionRoles.DataBind()
                        GridView3.DataBind()
                        SDSCambiarSociedad.DataBind()
                        GridView1.DataBind()
                        If Session("LANG") = "IN" Then
                            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta ('Rol deleted from User');", True)
                        Else
                            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alerta ('Rol Removido del Usuario');", True)
                        End If
                    End If
                End If
            Next
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "alertaError('Error: " & ex.Message.Replace("'", "") & "');", True)
        Finally
            Funciones.CerraBase(Funciones.CnxAppS)
        End Try
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "ActualizarUsuarios", "$(document).ready(function () { $('[id*=tab3]').click(); });", True)
    End Sub
    Protected Sub btn_FiltrarTab3_Click(sender As Object, e As System.EventArgs) Handles btn_FiltrarTab3.Click
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Carga PP&E a SAP", "$(document).ready(function () { $('[id*=tab2]').click(); });", True)
    End Sub
    Protected Sub btn_Filtrar_Click(sender As Object, e As System.EventArgs) Handles btn_Filtrar.Click
        hf_pestana.Value = "sociedades"
        Session("Detalles") = Nothing
        Session("Detalles") = "sociedades"
    End Sub
    Private Sub Configuracion_ActualizarUsuario_Load(sender As Object, e As EventArgs) Handles Me.Load
        'selected_tab.Value = Request.Form(selected_tab.UniqueID)
        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
        If Not IsPostBack Then
            tabSeleccionado.Value = "general"
        End If
    End Sub
    'Private Sub llenar_sociedades_usuarios()
    '    Dim valor As String = Nothing
    '    If ddl_UsuariosActivos.SelectedValue = "" Then
    '        valor = "%'"
    '    Else
    '        valor = ddl_UsuariosActivos.SelectedValue & "%'"
    '    End If
    '    Dim valor2 As String = Nothing
    '    If ddl_Sociedad.SelectedValue = "" Then
    '        valor2 = "%'"
    '    Else
    '        valor2 = ddl_Sociedad.SelectedValue & "%'"
    '    End If
    '    Dim SqlDataSource1 As New SqlDataSource()
    '    SqlDataSource1.ID = "SqlDataSource1"
    '    Me.Page.Controls.Add(SqlDataSource1)
    '    SqlDataSource1.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings("Activos").ConnectionString
    '    SqlDataSource1.SelectCommand = "Select " &
    '                                      " a.UserId," &
    '                                      " c.Sociedad," &
    '                                      " a.UserName, " &
    '                                      " a.NombreCompleto, " &
    '                                      " d.Descripcion As NombreSociedad," &
    '                                      " a.PuestoTrabajo," &
    '                                      " b.Email" &
    '                                      " From Autenticacion.dbo.aspnet_Users AS a LEFT Join" &
    '                                      " Autenticacion.dbo.aspnet_Membership AS b ON a.ApplicationId = b.ApplicationId And a.UserId = b.UserId LEFT Join" &
    '                                      " Autenticacion.dbo.aspnet_Sociedades AS c ON a.ApplicationId = c.ApplicationId And a.UserId = c.UserId LEFT Join" &
    '                                      " mm_Sociedades As d On c.Sociedad = d.Sociedad " &
    '                                      " Where a.ApplicationId ='" & WebConfigurationManager.AppSettings("ApplicationId") & "' And a.Userid Like '%" & valor & " and  c.Sociedad LIKE '%" & valor2 & "  "
    '    GridView2.DataSource = SqlDataSource1
    '    GridView2.DataBind()
    'End Sub
    'Private Sub GridView2_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView2.RowDataBound
    'If (e.Row.Cells.Count > 1) Then
    '    e.Row.Cells(1).Visible = False
    'End If
    'End Sub
    'Private Sub GridView2_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles GridView2.PageIndexChanging
    '    Try
    '        GridView2.PageIndex = e.NewPageIndex
    '        ' llenar_sociedades_usuarios()
    '    Catch ex As Exception
    '        Dim message As String = New JavaScriptSerializer().Serialize(ex.Message.ToString())
    '        ClientScript.RegisterStartupScript(Me.GetType(), "Bitacora", "alerta('Error grid Page: " & message & "');", True)
    '    Finally
    '    End Try
    'End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound
        lblTotalRegistros.Text = GridView1.Rows.Count
    End Sub
End Class