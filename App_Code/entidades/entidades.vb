Imports System.Web.Script.Serialization
Imports Microsoft.VisualBasic

Public Class Ent_Catalogos

    Public Property id As String
    Public Property descripcion As String
    Public Property activo As String
    Public Property Sociedad As String
    Public Property NombrePantalla As String


End Class


Public Class Ent_Documento
    Public Property mandt As String
    Public Property doc_inventario As String
    Public Property sociedad As String
    Public Property ejercicio As String
    Public Property ubicacion As String
    Public Property denom_ubicacion As String
    Public Property usuario_doc_inv As String
    Public Property fecha_doc_inv As String
    Public Property hora_doc_inv As String
    Public Property status_conteo As String
    Public Property aprobacion_final As String
    Public Property codigo_aprobado As String
    Public Property siguiente_aprob As String
    Public Property sig_codigo_aprob As String
    Public Property descargado_por As String
    Public Property fecha_descarga As String
    Public Property hora_descarga As String
    Public Property activos As List(Of Ent_Activo)


End Class

Public Class Ent_Activo
    Public Property mandt As String
    Public Property doc_inventario As String
    Public Property posicion_docto As String
    Public Property activo_fijo As String
    Public Property ubicacion As String
    Public Property denom_ubicacion As String
    Public Property subnumero As String
    Public Property denominacion1 As String
    Public Property denominacion2 As String
    Public Property numero_serie As String
    Public Property equipo As String
    Public Property indicador_conteo As String
    Public Property est_inventario As String
    Public Property comentario As String
    Public Property sociedad_origen As String
    Public Property af_origen As String
    Public Property ind_borrado As String
    Public Property texto_borrado As String
    Public Property usuario_borrado As String
    Public Property fecha_borrado As String
    Public Property hora_borrado As String
    Public Property numero_uid As String
    Public Property nombre_ubicacion As String
    Public Property longitud As String
    Public Property latitud As String





End Class

Public Class Ent_ActivoMaestro
    Public Property activo_fijo As String
    Public Property subnumero As String
    Public Property denominacion1 As String
    Public Property denominacion2 As String
    Public Property numero_serie As String
    Public Property equipo As String
    Public Property sociedad As String
    Public Property numero_uid As String
    Public Property ubicacion As String
    Public Property nombre_ubicacion As String





End Class

Public Class Ent_Usuario
    Public Property idusuario As String
    Public Property nombre As String
    Public Property idtrab As String
    Public Property nombreCompleto As String
    Public Property Sociedad As String
    Public Property NombreSociedad As String
    Public Property nombreCortoSociedad As String
    Public Property token As String
    Public Property fotoUsuario As String
    Public Property Rol As String
    Public Property SesAplicacion As String
    Public Property Autorizado As String
    Public Property sociedades As List(Of Ent_Sociedad)


End Class

Public Class Ent_Ubicaciones
    Public Property ubicacion As String
    Public Property denom_ubicacion As String

End Class
Public Class Ent_EstadoInventario
    Public Property est_inventario As String
    Public Property descripcion As String

End Class
Public Class Ent_EstadoDocumento
    Public Property est_documento As String
    Public Property descripcion As String

End Class


Public Class Ent_Sociedad
    Public Property sociedad As String
    Public Property descripcion As String
    Public Property NombrePantalla As String



End Class

