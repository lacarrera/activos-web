Imports System.Web.Configuration
Imports System.Web.Script.Serialization

Partial Public Class Account_Login
    Inherits Page
    Dim dominio As Boolean
    Private Sub Login1_LoggedIn(sender As Object, e As EventArgs) Handles Login1.LoggedIn
        'Select Case Session("Rol")
        '    Case "Administrador"
        '        Response.Redirect("../Catalogos/CatalogoEquipo.aspx", True)
        '    Case "Captura"
        '        Response.Redirect("../Captura/MenuCaptura.aspx", True)
        '    Case Else
        'End Select
    End Sub

    Protected Sub Login1_Authenticate(sender As Object, e As AuthenticateEventArgs) Handles Login1.Authenticate
        Dim cnxOnePeople As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("OnePeople").ConnectionString)
        Dim cnx As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("ApplicationServices").ConnectionString)
        Dim cmd3 As New Data.SqlClient.SqlCommand(" ", Funciones.CnxAppS)
        Dim cmd4 As New Data.SqlClient.SqlCommand(" ", Funciones.cnxOP)
        Dim reader As System.Data.SqlClient.SqlDataReader


        Session("SesUsuario") = Login1.UserName


        '******************** obtener foto de perfil*****************************************


        Try
            Funciones.AbrirBase(Funciones.CnxAppS)

            cmd3.CommandText = "select top 1 nombre+' '+Paterno+ ' ' + materno as nombre, b.idtrab from SONARH.SonarhNet.dbo.trabajador a inner join SONARH.SonarhNet.dbo.trabvar b on b.idTrab=a.idtrab where b.CharUsr6 = '" & Session("SesUsuario") & "'"
            reader = cmd3.ExecuteReader()
            While reader.Read()
                Session("idtrab") = reader.GetValue(1)
                Session("nombreCompleto") = reader.GetValue(0)
            End While
            reader.Close()
            If Not IsNothing(Session("idtrab")) Then
                Try
                    Funciones.AbrirBase(Funciones.cnxOP)


                    cmd4.CommandText = "SELECT top 1 b.foto2 FROM ONEPEOPLE2.dbo.tbl_personasConfiguracion a inner JOIN ONEPEOPLE2.dbo.tbl_personasFotos b on b.id_persona=a.idPersona WHERE a.numControl = '" & Session("idtrab") & "'"

                    reader = cmd4.ExecuteReader()
                    While reader.Read()
                        Session("fotoUsuario") = "data:image/jpg;base64," + Convert.ToBase64String(reader.GetValue(0))
                        Session("idtrab") = "No." & Session("idtrab")
                    End While
                    reader.Close()
                Catch ex As Exception

                    Session("fotoUsuario") = ResolveUrl("~/dist/img/blank-face.jpg")


                End Try
            Else
                Session("fotoUsuario") = ResolveUrl("~/dist/img/blank-face.jpg")

            End If

               e.Authenticated = True
        Catch ex As Exception
            Dim message As String = New JavaScriptSerializer().Serialize(ex.Message.ToString())

        Finally
            Funciones.CerraBase(Funciones.CnxAppS)
            Funciones.CerraBase(Funciones.cnxOP)

        End Try

    End Sub
    Private Sub Login1_LoggingIn(sender As Object, e As LoginCancelEventArgs) Handles Login1.LoggingIn
        If Login1.UserName.Contains("@") Then
            Login1.UserName = Login1.UserName.Substring(0, Login1.UserName.IndexOf("@"))
        End If
    End Sub
    Private Sub Account_Login_Load(sender As Object, e As EventArgs) Handles Me.Load

        ' aplication_name.Text = Application("aplication_name")
    End Sub
End Class