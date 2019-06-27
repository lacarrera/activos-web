<%@ WebService Language="VB" Class="WebServiceActivos" %>

Imports System.Web
Imports System.Web.Services
Imports SAP.Middleware.Connector
Imports System.Data
Imports System.Web.Script.Serialization
Imports System.Web.Configuration
Imports System.Data.SqlClient


Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()>
<WebService(Namespace := "http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
Public Class WebServiceActivos
  Inherits System.Web.Services.WebService

  Public Function getSociedades(usuario As String) As List(Of Ent_Sociedad)
    Dim cnx As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Activos").ConnectionString)
    Dim cmd As New Data.SqlClient.SqlCommand()
    Dim dReader As System.Data.SqlClient.SqlDataReader
    Dim ListaRenglones As New List(Of Ent_Sociedad)
    Try
      cnx.Open()
      cmd.Connection = cnx
      cmd.CommandText = "Select  d.Sociedad, d.descripcion, d.nombrePantalla From Autenticacion.dbo.aspnet_Users AS a LEFT Join Autenticacion.dbo.aspnet_Membership AS b ON a.ApplicationId = b.ApplicationId And a.UserId = b.UserId LEFT Join  Autenticacion.dbo.aspnet_Sociedades AS c ON a.ApplicationId = c.ApplicationId And a.UserId = c.UserId LEFT Join sociedades As d On c.Sociedad = d.Sociedad  Where a.ApplicationId = @aplicationID And a.username = @usuario"
      cmd.Parameters.AddWithValue("@aplicationID", WebConfigurationManager.AppSettings("ApplicationId"))
      cmd.Parameters.AddWithValue("@usuario", usuario)
      dReader = cmd.ExecuteReader()

      While dReader.Read()
        Dim renglon As New Ent_Sociedad()
        renglon.sociedad = dReader.GetValue(0)
        renglon.descripcion = dReader.GetValue(1)
        If Not dReader.IsDBNull(2) Then
          renglon.NombrePantalla = dReader.GetValue(2)
        End If

        ListaRenglones.Add(renglon)
      End While

      dReader.Close()

    Catch sqlEx As SqlException
      Throw (sqlEx)
    Catch ex As Exception
      Throw (ex)
    Finally
      cnx.Close()


    End Try
    Return ListaRenglones
  End Function
  ' ************************************************ SE OBTIENE EL NOMBRE COMPLETO PARA USUARIOS QUE NO ESTAN REGISTRADOS EN SONARTH ************************************************************************

  Private Function obtenerUsuarioAutenticado(usuario As String) As String
    Dim con As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("ApplicationServices").ConnectionString)
    Dim cmd As New Data.SqlClient.SqlCommand(" ", con)
    Dim nombreCompleto As String

    Try
      con.Open()
      cmd.CommandText = "SELECT top 1 nombreCompleto  FROM aspnet_Users WHERE UserName = @username and ApplicationId= '" & WebConfigurationManager.AppSettings("ApplicationId") & "'"


      cmd.Parameters.AddWithValue("@username", usuario)

      nombreCompleto = cmd.ExecuteScalar()

    Catch ex As Exception
      nombreCompleto = Nothing
    Finally
      con.Close()
    End Try
    Return nombreCompleto
  End Function
  ' ************************************************ VERIFICA EXISTENCIA DE ROL ************************************************************************
  Private Function obtenerRolAppMovil(usuario As String) As String
    Dim con As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("ApplicationServices").ConnectionString)
    Dim cmd As New Data.SqlClient.SqlCommand(" ", con)

    Dim rol As String = Nothing
    Try
      con.Open()
      cmd.CommandText = "select isnull(RoleName,0) from aspnet_Users a  " &
              " Left Join     aspnet_UsersInRoles  b  on a.userid=b.userid " &
             " Left Join  aspnet_roles  c on  b.RoleId=c.RoleId  " &
             " WHERE a.UserName = @usuario and a.ApplicationId= '" & WebConfigurationManager.AppSettings("ApplicationId") & "' and c.RoleName='" & WebConfigurationManager.AppSettings("rolApp") & "'"
      cmd.Parameters.AddWithValue("@usuario", usuario)
      rol = cmd.ExecuteScalar
    Catch ex As Exception
      rol = Nothing
    Finally
      con.Close()
    End Try
    Return rol
  End Function
  ' ************************************************ GENERA TOKEN ************************************************************************
  Private Function getToken(usuario As String) As String
    Dim con As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Activos").ConnectionString)
    Dim cmd As New Data.SqlClient.SqlCommand(" ", con)
    Dim existe As Integer
    Dim numAleatorio As New Random(CInt(Date.Now.Ticks And Integer.MaxValue))
    Dim token As String = System.Convert.ToString(numAleatorio.Next)
    Try
      con.Open()
      cmd.CommandText = "select COUNT(username) from token where username = @username "
      cmd.Parameters.AddWithValue("@username", usuario)

      existe = cmd.ExecuteScalar()
      If (existe > 0) Then
        cmd.CommandText = "UPDATE token SET token = @token  WHERE username = @username"

      Else
        cmd.CommandText = "INSERT INTO token (token, username ) VALUES( @token , @username)"

      End If

      cmd.Parameters.AddWithValue("@token", token)
      cmd.ExecuteNonQuery()
      cmd.CommandText = "select token from token where username = @username "

      token = cmd.ExecuteScalar()
    Catch ex As Exception
      token = Nothing
    Finally
      con.Close()
    End Try
    Return token
  End Function

  ' ************************************************ AUTENTICACIÓN DE USUARIO  ************************************************************************
  <System.Web.Services.WebMethod(EnableSession:=True)>
  Public Sub userAuthentication(Usuario As String, Contra As String)
    If Usuario.Contains("@") Then
      Usuario = Usuario.Substring(0, Usuario.IndexOf("@"))
    End If
    Dim renglon As New Ent_Usuario()
    Dim ListaRenglones As New List(Of Ent_Usuario)

    Dim cnx As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("ApplicationServices").ConnectionString)
    Dim cnxOnePeople As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("OnePeople").ConnectionString)

    Dim cmd As New Data.SqlClient.SqlCommand("SELECT isnull(B.IsApproved , 0) AS IsApproved FROM aspnet_users AS A JOIN aspnet_Membership AS B ON A.UserId = B.UserId " &
                    "WHERE B.ApplicationId='" & WebConfigurationManager.AppSettings("ApplicationId") & "'  AND A.UserName = @username ", cnx)
    Dim cmd2 As New Data.SqlClient.SqlCommand(" ", cnx)
    Dim cmd3 As New Data.SqlClient.SqlCommand(" ", cnx)
    Dim reader As System.Data.SqlClient.SqlDataReader
    Dim cmd4 As New Data.SqlClient.SqlCommand(" ", cnxOnePeople)


    Dim cmd_generic As New Data.SqlClient.SqlCommand(" ", cnx)
    Dim valido As Boolean
    Dim obtenernombresociedad As ObtenerSociedad = New ObtenerSociedad()
    'Dim AmbienteActual As String

    Try
      cnx.Open()

      renglon.SesAplicacion = WebConfigurationManager.AppSettings("ApplicationId")
      renglon.nombre = Usuario
      cmd_generic.CommandText = "SELECT CASE WHEN IsGeneric = 0 THEN 'S' " &
                                        "Else 'N' " &
                                 "END AS UsuarioDominio " &
                                    "FROM Autenticacion.dbo.aspnet_Users WHERE LoweredUserName ='" & Usuario & "' AND ApplicationId ='" & WebConfigurationManager.AppSettings("ApplicationId") & "'"

      Dim estaendominio As String = cmd_generic.ExecuteScalar
      Dim Authenticated As Boolean
      If estaendominio = "S" Then
        'validar si esta en dominio
        Dim adPath As String = "LDAP://firstmajestic.local" 'Fully-qualified Domain Name        
        Dim adAuth As Autenticacionvb = New Autenticacionvb()
        adAuth.LdapAuthentication(adPath)

        If adAuth.IsAuthenticated("firstmajestic", Usuario, Contra) Then
          Authenticated = True
        Else
          Throw New Exception("Error en dominio")

        End If
        cmd.Parameters.AddWithValue("@username", Usuario)
        valido = cmd.ExecuteScalar
        Authenticated = True
        If Not valido Then
          Throw New Exception("Usuario no Activo")
        End If
      Else
        Authenticated = Membership.ValidateUser(Usuario, Contra)
      End If
      renglon.Autorizado = Authenticated
      If Not Authenticated Then
        Throw New Exception("Error de Sesion")

      End If




      cmd2.CommandText = "SELECT top 1 isnull(a.Sociedad,0) FROM aspnet_Sociedades as a join [aspnet_Users] as b on a.UserId=b.UserId WHERE b.UserName = '" & Usuario & "' and a.ApplicationId= '" & WebConfigurationManager.AppSettings("ApplicationId") & "'"
      '' organizacion a la cual tiene acceso
      renglon.Sociedad = cmd2.ExecuteScalar

      '************ SE comprueba tenga el rol asignado ***********************
      renglon.Rol = obtenerRolAppMovil(Usuario)
      If renglon.Rol = Nothing Then
        Throw New Exception("Sin autorización")
      End If
      '********************* Se obtiene el Token    ***************************
      renglon.token = getToken(Usuario)
      '*********************************************************
      Dim listaSociedades As New List(Of Ent_Sociedad)
      listaSociedades = getSociedades(Usuario)
      If listaSociedades.Count = 0 Then
        Throw New Exception("Sin sociedad")
      End If
      renglon.sociedades = listaSociedades

      renglon.NombreSociedad = listaSociedades(0).descripcion
      renglon.Sociedad = listaSociedades(0).sociedad
      renglon.nombreCortoSociedad = listaSociedades(0).NombrePantalla

      '*********************  obtener foto de perfil******************************************
      cmd3.CommandText = "select top 1 nombre+' '+Paterno+ ' ' + materno as nombre, b.idtrab from SONARH.SonarhNet.dbo.trabajador a inner join SONARH.SonarhNet.dbo.trabvar b on b.idTrab=a.idtrab where b.CharUsr6 = '" & renglon.nombre & "' order by b.FeUltAct desc"
      reader = cmd3.ExecuteReader()
      While reader.Read()
        renglon.idtrab = reader.GetValue(1)
        renglon.nombreCompleto = reader.GetValue(0)
      End While
      reader.Close()
      If Not IsNothing(renglon.idtrab) Then
        Try
          cnxOnePeople.Open()

          cmd4.CommandText = "SELECT top 1 b.foto2 FROM ONEPEOPLE2.dbo.tbl_personasConfiguracion a inner JOIN ONEPEOPLE2.dbo.tbl_personasFotos b on b.id_persona=a.idPersona WHERE a.numControl = '" & renglon.idtrab & "'"

          reader = cmd4.ExecuteReader()
          While reader.Read()
            renglon.fotoUsuario = "data:image/jpg;base64," + Convert.ToBase64String(reader.GetValue(0))

          End While
          reader.Close()
        Catch ex As Exception

          renglon.fotoUsuario = "https://bitacoramina.firstmajestic.com/dist/img/blank-face.jpg"


        End Try
      Else
        renglon.nombreCompleto = obtenerUsuarioAutenticado(Usuario)

        renglon.fotoUsuario = "https://bitacoramina.firstmajestic.com/dist/img/blank-face.jpg"

      End If
      ListaRenglones.Add(renglon)
      Dim js As JavaScriptSerializer = New JavaScriptSerializer()
      Dim Result As String = js.Serialize(ListaRenglones)

      Context.Response.Write(Result)
      '***************************************************************************************

    Catch ex As Exception
      renglon.Autorizado = False
      ListaRenglones.Add(renglon)
      Dim js As JavaScriptSerializer = New JavaScriptSerializer()
      Dim Result As String = js.Serialize(ListaRenglones)

      Context.Response.Write(Result)

    Finally
      cnx.Close()
      cnxOnePeople.Close()
    End Try
  End Sub

  ' ************************************************ ASIGNA TOKEN DE NOTIFICACIONES  ************************************************************************
  Private Function obtenerUsuario(token As String) As String
    Dim con As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Activos").ConnectionString)
    Dim cmd As New Data.SqlClient.SqlCommand(" ", con)

    Dim username As String = Nothing
    Try
      con.Open()
      cmd.CommandText = "select username from token where token = @token "
      cmd.Parameters.AddWithValue("@token", token)

      username = cmd.ExecuteScalar()

    Catch ex As Exception
      token = Nothing
    Finally
      con.Close()
    End Try
    Return username
  End Function
  <System.Web.Services.WebMethod()>
  Public Function tokenNotification(token As String, pushToken As String) As String
    Dim con As New Data.SqlClient.SqlConnection(ConfigurationManager.ConnectionStrings("Activos").ConnectionString)
    Dim cmd As New Data.SqlClient.SqlCommand(" ", con)
    Dim respuesta As String = Nothing
    Dim username As String = Nothing
    Try
      username = obtenerUsuario(token)
      If (username = Nothing) Then
        Return Nothing
      End If
      con.Open()
      cmd.CommandText = "UPDATE token SET expoPushToken = @pushToken  WHERE token = @token"
      cmd.Parameters.AddWithValue("@token", token)
      cmd.Parameters.AddWithValue("@pushToken", pushToken)
      cmd.ExecuteNonQuery()
      respuesta = "ok"
    Catch ex As Exception
      respuesta = Nothing
    Finally
      con.Close()
    End Try
    Return respuesta
  End Function

  <WebMethod()>
  Public Function quienDescarga(usuario As String, doc_inventario As String, sociedad As String) As String

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    ' Dim Respuesta As String


    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "ASIGNA_DOCINV")
      funcion.SetValue("USUARIO", usuario)
      funcion.SetValue("SOCIEDAD", sociedad)
      funcion.SetValue("DOC_INVENTARIO", doc_inventario)

      funcion.Invoke(dest)

      ' Respuesta = funcion.GetValue("MSG_RESPUESTA")
      Return "ok"

    Catch ex As Exception
      Throw (ex)
    End Try
  End Function
  <WebMethod()>
  Public Function ObtenerDocumentos(sociedad As String, doc_inventario As String, index As String, cantidad As String) As List(Of Ent_Documento)

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Diko As IRfcTable
    Dim iTable_Dipo As IRfcTable


    Dim dt_datos As System.Data.DataTable = New System.Data.DataTable()
    Dim dt_activos As System.Data.DataTable = New System.Data.DataTable()


    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "BAJAR_DOCINV")
      funcion.SetValue("SOCIEDAD", sociedad)
      funcion.SetValue("DOC_INVENTARIO", doc_inventario)
      funcion.SetValue("INDEX_FROM", index)
      funcion.SetValue("NUM_REGISTROS", cantidad)
      funcion.Invoke(dest)
      '  iTable_Diko = funcion.GetTable("ET_DIKO")
      ' iTable_Dipo = funcion.GetTable("ET_DIPO")


      iTable_Diko = funcion.GetTable("ET_DIKO")
      iTable_Dipo = funcion.GetTable("ET_DIPO")
      dt_datos = Funciones.ConvertirTablaiRFC(iTable_Diko)
      dt_activos = Funciones.ConvertirTablaiRFC(iTable_Dipo)
      Dim ListaRenglones As New List(Of Ent_Documento)

      If dt_datos.Rows.Count > 0 Then
        Try

          For Each Fila As System.Data.DataRow In dt_datos.Rows
            Try
              Dim documento As Ent_Documento = New Ent_Documento()
              documento.mandt = Fila("MANDT")
              documento.doc_inventario = Fila("DOC_INVENTARIO")
              documento.sociedad = Fila("SOCIEDAD")
              documento.ejercicio = Fila("EJERCICIO")

              documento.usuario_doc_inv = Fila("USUARIO_DOC_INV")
              documento.hora_doc_inv = Fila("HORA_DOC_INV")
              documento.status_conteo = Fila("STATUS_CONTEO")
              documento.aprobacion_final = Fila("APROBACION_FINAL")
              documento.codigo_aprobado = Fila("CODIGO_APROBADO")
              documento.siguiente_aprob = Fila("SIGUIENTE_APROB")
              documento.sig_codigo_aprob = Fila("SIG_CODIGO_APROB")
              documento.descargado_por = Fila("DESCARGADO_POR")
              documento.fecha_descarga = Fila("FECHA_DESCARGA")
              documento.hora_descarga = Fila("HORA_DESCARGA")

              Dim listaActivos As List(Of Ent_Activo) = New List(Of Ent_Activo)({})

              Dim mdrow() As DataRow = dt_activos.Select("DOC_INVENTARIO='" & documento.doc_inventario & "'")

              For Each dr In mdrow
                Dim activo As Ent_Activo = New Ent_Activo()
                activo.mandt = dr("MANDT")
                activo.doc_inventario = dr("DOC_INVENTARIO")
                activo.posicion_docto = dr("POSICION_DOCTO")
                activo.activo_fijo = dr("ACTIVO_FIJO")
                activo.ubicacion = dr("UBICACION")
                activo.denom_ubicacion = dr("DENOM_UBICACION")
                activo.subnumero = dr("SUBNUMERO")
                activo.denominacion1 = dr("DENOMINACION1")
                activo.denominacion2 = dr("DENOMINACION2")
                activo.numero_uid = dr("NUMERO_UID")
                activo.numero_serie = dr("NUMERO_SERIE")
                activo.equipo = dr("EQUIPO")
                activo.indicador_conteo = dr("INDICADOR_CONTEO")
                activo.est_inventario = dr("EST_INVENTARIO")
                activo.comentario = dr("COMENTARIO")
                activo.sociedad_origen = dr("SOCIEDAD_ORIGEN")
                activo.af_origen = dr("AF_ORIGEN")
                activo.ind_borrado = dr("DOC_INVENTARIO")
                activo.texto_borrado = dr("IND_BORRADO")
                activo.usuario_borrado = dr("USUARIO_BORRADO")
                activo.fecha_borrado = dr("FECHA_BORRADO")
                activo.hora_borrado = dr("HORA_BORRADO")
                activo.latitud = dr("LATITUD")
                activo.longitud = dr("LONGITUD")

                listaActivos.Add(activo)
              Next
              documento.activos = listaActivos
              ListaRenglones.Add(documento)

            Catch ex As Exception
              Throw (ex)
            End Try
          Next
          'My.Response.Write("<script>alert('Se ha actualizando la tabla de Equipos desde SAP')</script>")
        Catch ex As Exception
          Throw (ex)

        End Try

      End If



      Return ListaRenglones


    Catch ex As Exception
      Throw (ex)
    End Try
  End Function

  <WebMethod()>
  Public Sub ObtenerDocumentosJson(sociedad As String, doc_inventario As String, index As String, cantidad As String)

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Diko As IRfcTable
    Dim iTable_Dipo As IRfcTable


    Dim dt_datos As System.Data.DataTable = New System.Data.DataTable()
    Dim dt_activos As System.Data.DataTable = New System.Data.DataTable()


    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "BAJAR_DOCINV")
      funcion.SetValue("SOCIEDAD", sociedad)
      funcion.SetValue("DOC_INVENTARIO", doc_inventario)
      funcion.SetValue("INDEX_FROM", index)
      funcion.SetValue("NUM_REGISTROS", cantidad)
      funcion.Invoke(dest)
      '  iTable_Diko = funcion.GetTable("ET_DIKO")
      ' iTable_Dipo = funcion.GetTable("ET_DIPO")


      iTable_Diko = funcion.GetTable("ET_DIKO")
      iTable_Dipo = funcion.GetTable("ET_DIPO")
      dt_datos = Funciones.ConvertirTablaiRFC(iTable_Diko)
      dt_activos = Funciones.ConvertirTablaiRFC(iTable_Dipo)
      Dim ListaRenglones As New List(Of Ent_Documento)

      If dt_datos.Rows.Count > 0 Then
        Try

          For Each Fila As System.Data.DataRow In dt_datos.Rows
            Try
              Dim documento As Ent_Documento = New Ent_Documento()
              documento.mandt = Fila("MANDT")
              documento.doc_inventario = Fila("DOC_INVENTARIO")
              documento.sociedad = Fila("SOCIEDAD")
              documento.ejercicio = Fila("EJERCICIO")
              documento.ubicacion = Fila("UBICACION")
              documento.usuario_doc_inv = Fila("USUARIO_DOC_INV")
              documento.hora_doc_inv = Fila("HORA_DOC_INV")
              documento.status_conteo = Fila("STATUS_CONTEO")
              documento.aprobacion_final = Fila("APROBACION_FINAL")
              documento.codigo_aprobado = Fila("CODIGO_APROBADO")
              documento.siguiente_aprob = Fila("SIGUIENTE_APROB")
              documento.sig_codigo_aprob = Fila("SIG_CODIGO_APROB")

              Dim listaActivos As List(Of Ent_Activo) = New List(Of Ent_Activo)({})

              Dim mdrow() As DataRow = dt_activos.Select("DOC_INVENTARIO='" & documento.doc_inventario & "'")

              For Each dr In mdrow
                Dim activo As Ent_Activo = New Ent_Activo()
                activo.mandt = dr("MANDT")
                activo.doc_inventario = dr("DOC_INVENTARIO")
                activo.posicion_docto = dr("POSICION_DOCTO")
                activo.activo_fijo = dr("ACTIVO_FIJO")

                activo.subnumero = dr("SUBNUMERO")
                activo.denominacion1 = dr("DENOMINACION1")
                activo.denominacion2 = dr("DENOMINACION2")
                activo.numero_uid = dr("NUMERO_UID")
                activo.numero_serie = dr("NUMERO_SERIE")
                activo.equipo = dr("EQUIPO")
                activo.indicador_conteo = dr("INDICADOR_CONTEO")
                activo.est_inventario = dr("EST_INVENTARIO")
                activo.comentario = dr("COMENTARIO")
                activo.sociedad_origen = dr("SOCIEDAD_ORIGEN")
                activo.af_origen = dr("AF_ORIGEN")
                activo.ind_borrado = dr("DOC_INVENTARIO")
                activo.texto_borrado = dr("IND_BORRADO")
                activo.usuario_borrado = dr("USUARIO_BORRADO")
                activo.fecha_borrado = dr("FECHA_BORRADO")
                activo.hora_borrado = dr("HORA_BORRADO")

                listaActivos.Add(activo)
              Next
              documento.activos = listaActivos
              ListaRenglones.Add(documento)

            Catch ex As Exception
              Throw (ex)
            End Try
          Next
          'My.Response.Write("<script>alert('Se ha actualizando la tabla de Equipos desde SAP')</script>")
        Catch ex As Exception
          Throw (ex)

        End Try

      End If



      Dim js As JavaScriptSerializer = New JavaScriptSerializer()
      js.MaxJsonLength = 1073741824
      Dim Result As String = js.Serialize(ListaRenglones)
      Context.Response.Write(Result)


    Catch ex As Exception
      Throw (ex)
    End Try
  End Sub


  <WebMethod()>
  Public Sub allActivos()

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Lista_Af As IRfcTable


    Dim dt_activos As System.Data.DataTable = New System.Data.DataTable()


    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "BAJARLISTA_AF")
      funcion.Invoke(dest)



      iTable_Lista_Af = funcion.GetTable("ET_LISTA_AF")
      dt_activos = Funciones.ConvertirTablaiRFC(iTable_Lista_Af)

      Dim listaActivos As List(Of Ent_ActivoMaestro) = New List(Of Ent_ActivoMaestro)({})

      If dt_activos.Rows.Count > 0 Then


        For Each Fila As System.Data.DataRow In dt_activos.Rows

          Dim activo As Ent_ActivoMaestro = New Ent_ActivoMaestro()
          activo.sociedad = Fila("BUKRS")
          activo.activo_fijo = Fila("ANLN1")
          activo.subnumero = Fila("ANLN2")
          activo.numero_uid = Fila("INVNR")
          activo.denominacion1 = Fila("TXT50")
          activo.denominacion2 = Fila("TXA50")
          activo.ubicacion = Fila("STORT")
          activo.nombre_ubicacion = Fila("KTEXT")
          activo.numero_serie = Fila("SERNR")
          activo.equipo = Fila("EQUNR")

          listaActivos.Add(activo)
        Next
      End If
      Dim js As JavaScriptSerializer = New JavaScriptSerializer()
      js.MaxJsonLength = 1073741824
      Dim Result As String = js.Serialize(listaActivos)
      Context.Response.Write(Result)


      'Return listaActivos
    Catch ex As Exception
      Throw (ex)
    End Try
  End Sub


  <WebMethod()>
  Public Function allActivosXml() As List(Of Ent_ActivoMaestro)

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Lista_Af As IRfcTable


    Dim dt_activos As System.Data.DataTable = New System.Data.DataTable()


    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "BAJARLISTA_AF")
      funcion.Invoke(dest)



      iTable_Lista_Af = funcion.GetTable("ET_LISTA_AF")
      dt_activos = Funciones.ConvertirTablaiRFC(iTable_Lista_Af)

      Dim listaActivos As List(Of Ent_ActivoMaestro) = New List(Of Ent_ActivoMaestro)({})

      If dt_activos.Rows.Count > 0 Then


        For Each Fila As System.Data.DataRow In dt_activos.Rows

          Dim activo As Ent_ActivoMaestro = New Ent_ActivoMaestro()
          activo.sociedad = Fila("BUKRS")
          activo.activo_fijo = Fila("ANLN1")
          activo.subnumero = Fila("ANLN2")
          activo.numero_uid = Fila("INVNR")
          activo.denominacion1 = Fila("TXT50")
          activo.denominacion2 = Fila("TXA50")
          activo.ubicacion = Fila("STORT")
          activo.nombre_ubicacion = Fila("KTEXT")
          activo.numero_serie = Fila("SERNR")
          activo.equipo = Fila("EQUNR")

          listaActivos.Add(activo)
        Next
      End If



      Return listaActivos
    Catch ex As Exception
      Throw (ex)
    End Try
  End Function

  <WebMethod()>
  Public Function getUbicaciones(sociedad As String) As List(Of Ent_Ubicaciones)

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Lista_Af As IRfcTable


    Dim dt_ubicaciones As System.Data.DataTable = New System.Data.DataTable()


    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "C_UBICACIONES")
      funcion.SetValue("sociedad", sociedad)
      funcion.Invoke(dest)



      iTable_Lista_Af = funcion.GetTable("ET_UBICACION")
      dt_ubicaciones = Funciones.ConvertirTablaiRFC(iTable_Lista_Af)

      Dim listaUbicaciones As List(Of Ent_Ubicaciones) = New List(Of Ent_Ubicaciones)({})

      If dt_ubicaciones.Rows.Count > 0 Then


        For Each Fila As System.Data.DataRow In dt_ubicaciones.Rows

          Dim ubicacion As Ent_Ubicaciones = New Ent_Ubicaciones()

          ubicacion.ubicacion = Fila("stand")
          ubicacion.denom_ubicacion = Fila("ktext")


          listaUbicaciones.Add(ubicacion)
        Next
      End If



      Return listaUbicaciones
    Catch ex As Exception
      Throw (ex)
    End Try
  End Function
  <WebMethod()>
  Public Function getEstadoInventario() As List(Of Ent_EstadoInventario)

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Lista_Af As IRfcTable
    Dim dt_estadoInventario As System.Data.DataTable = New System.Data.DataTable()
    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "C_EST_INVENTARIO")
      funcion.Invoke(dest)
      iTable_Lista_Af = funcion.GetTable("ET_IND_STINVENTARIO")
      dt_estadoInventario = Funciones.ConvertirTablaiRFC(iTable_Lista_Af)
      Dim listaEstados As List(Of Ent_EstadoInventario) = New List(Of Ent_EstadoInventario)({})
      If dt_estadoInventario.Rows.Count > 0 Then
        For Each Fila As System.Data.DataRow In dt_estadoInventario.Rows
          Dim estado As Ent_EstadoInventario = New Ent_EstadoInventario()
          estado.est_inventario = Fila("EST_INVENTARIO")
          estado.descripcion = Fila("DESCRIPCION")
          listaEstados.Add(estado)
        Next
      End If
      Return listaEstados
    Catch ex As Exception
      Throw (ex)
    End Try
  End Function

  <WebMethod()>
  Public Function getEstadoDocumento() As List(Of Ent_EstadoDocumento)

    Dim dest As RfcDestination = RfcDestinationManager.GetDestination(Funciones.DestinoSAP)
    Dim funcion As IRfcFunction
    Dim iTable_Lista_Af As IRfcTable
    Dim dt_estadoDocumento As System.Data.DataTable = New System.Data.DataTable()
    Try
      funcion = dest.Repository.CreateFunction("ZAF_INTERFAZ")
      funcion.SetValue("OPCION", "C_EST_DOCUMENTO")
      funcion.Invoke(dest)
      iTable_Lista_Af = funcion.GetTable("ET_STDOCUMENTO")
      dt_estadoDocumento = Funciones.ConvertirTablaiRFC(iTable_Lista_Af)
      Dim listaEstados As List(Of Ent_EstadoDocumento) = New List(Of Ent_EstadoDocumento)({})
      If dt_estadoDocumento.Rows.Count > 0 Then
        For Each Fila As System.Data.DataRow In dt_estadoDocumento.Rows
          Dim estado As Ent_EstadoDocumento = New Ent_EstadoDocumento()
          estado.est_documento = Fila("STATUS_CONTEO")
          estado.descripcion = Fila("DESCRIPCION")
          listaEstados.Add(estado)
        Next
      End If
      Return listaEstados
    Catch ex As Exception
      Throw (ex)
    End Try
  End Function
End Class


