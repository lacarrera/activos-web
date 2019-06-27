
Imports System.Web.Script.Serialization

Partial Class Configuracion_Register
    Inherits System.Web.UI.Page

    Public Sub RegisterUser_CreatedUser(sender As Object, e As EventArgs) Handles RegisterUser.CreatedUser
        Try


            ' Dim ddl_sociedad, ddl_rol As DropDownList
            Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.Cnx)
            Dim cmd1 As New Data.SqlClient.SqlCommand("", Funciones.CnxAppS)
            'Dim cuws As CreateUserWizardStep
            Dim userNameTextBox, nombreCompletoTextBox, puestoTrabajoTextBox As TextBox

            Dim CheckBoxList_Roles, CheckBoxList_Sociedades As CheckBoxList
            'Dim user As MembershipUser
            Dim UserId As String
            Dim qry As String
            userNameTextBox = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("UserName")
            nombreCompletoTextBox = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("NombreCompleto")
            puestoTrabajoTextBox = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("PuestoTrabajo")
            'ddl_sociedad = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("Sociedad")
            'ddl_rol = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("ddl_Rol")
            CheckBoxList_Sociedades = CType(RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("CheckBoxList_Sociedades"), CheckBoxList)
            CheckBoxList_Roles = CType(RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("CheckBoxList_Roles"), CheckBoxList)
            ' chk_movimientos = CType(RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("chk_movimientos"), CheckBoxList)
            ' chk_documentos = CType(RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("chk_documentos"), CheckBoxList)
            'User = Membership.GetUser(userNameTextBox.Text)
            'User.Comment = "Sociedad=" & ddl_sociedad.SelectedValue
            'Membership.UpdateUser(User)

            Funciones.AbrirBase(Funciones.CnxAppS)
            qry = "UPDATE aspnet_Users SET Sociedad = '', NombreCompleto = '" & nombreCompletoTextBox.Text.Trim & "', PuestoTrabajo = '" & puestoTrabajoTextBox.Text.Trim & "' WHERE UserName = '" & userNameTextBox.Text & "' AND ApplicationId = '" & Funciones.ApplicationId & "'"
            cmd1.CommandText = qry
            cmd1.ExecuteNonQuery()

            qry = "SELECT UserId FROM aspnet_Users WHERE UserName = '" & userNameTextBox.Text & "' AND ApplicationId = '" & Funciones.ApplicationId & "'"
            cmd1.CommandText = qry
            UserId = cmd1.ExecuteScalar.ToString

            For i As Integer = 0 To CheckBoxList_Roles.Items.Count - 1
                If CheckBoxList_Roles.Items(i).Selected Then
                    qry = "INSERT INTO aspnet_UsersInRoles (UserId, RoleId) VALUES('" & UserId & "', '" & CheckBoxList_Roles.Items(i).Value.ToString & "')"
                    cmd1.CommandText = qry
                    cmd1.ExecuteNonQuery()
                End If
            Next

            If CheckBoxList_Sociedades.Items(0).Selected Then
                For i As Integer = 1 To CheckBoxList_Sociedades.Items.Count - 1
                    qry = "INSERT INTO aspnet_Sociedades (ApplicationId,UserId,Sociedad) VALUES('" & Funciones.ApplicationId & "','" & UserId & "','" & CheckBoxList_Sociedades.Items(i).Value.ToString & "')"
                    cmd1.CommandText = qry
                    cmd1.ExecuteNonQuery()
                Next
            Else
                For i As Integer = 1 To CheckBoxList_Sociedades.Items.Count - 1
                    If CheckBoxList_Sociedades.Items(i).Selected Then
                        qry = "INSERT INTO aspnet_Sociedades (ApplicationId,UserId,Sociedad) VALUES('" & Funciones.ApplicationId & "','" & UserId & "','" & CheckBoxList_Sociedades.Items(i).Value.ToString & "')"
                        cmd1.CommandText = qry
                        cmd1.ExecuteNonQuery()
                    End If
                Next
            End If

            'For i As Integer = 0 To CheckBoxList_Sociedades.Items.Count - 1
            '    If CheckBoxList_Sociedades.Items(i).Selected Then
            '        qry = "INSERT INTO aspnet_Sociedades (ApplicationId,UserId,Sociedad) VALUES('" & Funciones.ApplicationId & "','" & UserId & "','" & CheckBoxList_Sociedades.Items(i).Value.ToString & "')"
            '        cmd1.CommandText = qry
            '        cmd1.ExecuteNonQuery()
            '    End If
            'Next


            Funciones.CerraBase(Funciones.CnxAppS)



            '-----------------------------------------------------------------------------------

            ''FormsAuthentication.SetAuthCookie(RegisterUser.UserName, False)

            'Dim continueUrl As String = RegisterUser.ContinueDestinationPageUrl
            'If String.IsNullOrEmpty(continueUrl) Then
            '    continueUrl = "~/Default.aspx"
            'End If

            'Response.Redirect(continueUrl)
        Catch ex As Exception
            Dim message As String = New JavaScriptSerializer().Serialize(ex.Message.ToString())
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "$('#mensaje').hide();", True)

            If Session("Idioma") = "IN" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Failed to Create New user " & message & "');", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Error al Crear Nuevo Usuario: " & message & "');", True)
            End If
        End Try
    End Sub

    Protected Sub CheckBoxList_Sociedades_DataBound(sender As Object, e As System.EventArgs)
        Dim CheckBoxList_Sociedades As CheckBoxList = CType(RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("CheckBoxList_Sociedades"), CheckBoxList)
        CheckBoxList_Sociedades.Items(0).Selected = True
    End Sub

    Private Sub Configuracion_Register_Load(sender As Object, e As EventArgs) Handles Me.Load
        If (IsPostBack = True) Then
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "$('#mensaje').show(); ", True)
        Else
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "$('#mensaje').hide(); ", True)

        End If

        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
    End Sub

    Private Sub RegisterUser_CreateUserError(sender As Object, e As CreateUserErrorEventArgs) Handles RegisterUser.CreateUserError
        ' ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "$('#mensaje').show(); ", True)

    End Sub
End Class

