Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class Configuracion_CrearRol
    Inherits System.Web.UI.Page
    Protected Sub btn_Restart_Click(sender As Object, e As System.EventArgs) Handles btn_Restart.Click
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("ApplicationServices").ConnectionString
        Dim connection As New SqlConnection(connectionString)
        Try
            connection.Open()
            Dim CMD As New SqlCommand("aspnet_Roles_CreateRole")
            CMD.Connection = connection
            CMD.CommandType = CommandType.StoredProcedure
            CMD.Parameters.Add("@ApplicationName", SqlDbType.NChar).Value = Web.Configuration.WebConfigurationManager.AppSettings("ApplicationName") 'nombre de la palicacion
            CMD.Parameters.Add("@RoleName", SqlDbType.VarChar).Value = txt_descripcion_rol.Text
            'Dim outputParam As SqlParameter = CMD.Parameters.Add("@return_value", SqlDbType.Int, 500)
            'outputParam.Direction = ParameterDirection.Output
            CMD.ExecuteNonQuery()
            If Session("Idioma") = "IN" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Rol Generated Succesful');", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Rol Generado Correctamente');", True)
            End If
            'Dim Result As Int16 = CMD.Parameters("@return_value").Value
        Catch ex As Exception
            Dim message As String = New JavaScriptSerializer().Serialize(ex.Message.ToString())
            If Session("Idioma") = "IN" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Failed to generate rol: " & message & "');", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Bitacora", "alerta('Error al generar rol: " & message & "');", True)
            End If
        Finally
            connection.Close()
        End Try
    End Sub
    Private Sub Configuracion_CrearRol_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("SesUsuario") = "" Then
            Response.Redirect(ResolveClientUrl("~/CerrarSesion.aspx"), False)
        End If
    End Sub
End Class