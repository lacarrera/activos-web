Imports System.Data.Odbc
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Imports Microsoft.VisualBasic

Public Class ObtenerSociedad



    Public Function obtener_datos_sociedad(where As String) As List(Of Ent_Catalogos)
        Dim cnx As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Bitacora").ConnectionString)
        Dim cmd As New Data.SqlClient.SqlCommand()
        Dim dReader As System.Data.SqlClient.SqlDataReader
        Try
            cnx.Open()
            cmd.Connection = cnx
            cmd.CommandText = " SELECT Sociedad, Descripcion, NombrePantalla FROM  MM_Sociedades WHERE Sociedad='" & where & "'"
            dReader = cmd.ExecuteReader()
            Dim ListaRenglones As New List(Of Ent_Catalogos)
            While dReader.Read()
                Dim renglon As New Ent_Catalogos()
                renglon.id = dReader.GetInt32(0)
                renglon.descripcion = dReader.GetValue(1)
                renglon.NombrePantalla = dReader.GetValue(2)
                ListaRenglones.Add(renglon)
            End While
            Return ListaRenglones
            dReader.Close()

        Catch sqlEx As SqlException
            Throw (sqlEx)
        Catch ex As Exception
            Throw (ex)
        Finally
            cnx.Close()


        End Try
    End Function

    Public Function obter_usuario_contratista(usuario As String) As List(Of Ent_Catalogos)


        Dim cnx As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Bitacora").ConnectionString)
        Dim cmd As New Data.SqlClient.SqlCommand()
        Dim dReader As System.Data.SqlClient.SqlDataReader


        Try
            cnx.Open()
            cmd.Connection = cnx
            cmd.CommandText = "select  idusuariocontratista,idcontratista   from UsuariosContratista WHERe usuario='" & usuario & "'"
            dReader = cmd.ExecuteReader()
            Dim ListaRenglones As New List(Of Ent_Catalogos)
            While dReader.Read()
                Dim renglon As New Ent_Catalogos()
                renglon.id = dReader.GetInt32(0)
                renglon.descripcion = dReader.GetValue(1)
                ListaRenglones.Add(renglon)
            End While


            Return ListaRenglones
            dReader.Close()

        Catch sqlEx As SqlException
            Throw (sqlEx)
        Catch ex As Exception
            Throw (ex)
        Finally
            cnx.Close()


        End Try
    End Function
End Class
