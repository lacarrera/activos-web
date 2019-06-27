Imports System.Collections.Generic
Imports System.Security.Principal
Imports System.Web
Imports System.Web.Script.Serialization
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Public Partial Class SiteMaster
    Inherits MasterPage
    Private Const AntiXsrfTokenKey As String = "__AntiXsrfToken"
    Private Const AntiXsrfUserNameKey As String = "__AntiXsrfUserName"
    Private _antiXsrfTokenValue As String

    Protected Sub Page_Load(sender As Object, e As EventArgs)
        Dim Mandante As String = System.Configuration.ConfigurationManager.AppSettings("DestinoSAP").ToString
        Page.Title = Application("aplication_name")
        usuario.Text = Session("SesUsuario")
        usuario1.Text = Session("SesUsuario")
        ambienteText.Text = Mandante

        unidad.Text = Session("NombreSociedad")

        If Session("idioma") = "IN" Then
            SiteMapDS.SiteMapProvider = "EnglishSiteMapProvider"
            SiteMapPath2.SiteMapProvider = "EnglishSiteMapProvider"
        Else
            SiteMapDS.SiteMapProvider = "SpanishSiteMapProvider"
            SiteMapPath2.SiteMapProvider = "SpanishSiteMapProvider"
        End If

        '*********************** Según las cookies cambia los menus y su orientacion *******************************
        Dim presentacionPantalla As HttpCookie = Request.Cookies("presentacionPantalla")
        If Not presentacionPantalla Is Nothing Then

            If presentacionPantalla.Value = "max" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "menuChico", "$('div.ajuste').removeClass('container'); maximiza='max';", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "menuGrande", "$('div.ajuste').addClass('container'); maximiza='min';", True)
            End If
        Else
            '****** Configuracion de ancho de pantalla por Default
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "menuDefault", "$('div.ajuste').addClass('container'); maximiza='min'; ", True)

        End If
        Dim menuOrientacion As HttpCookie = Request.Cookies("menuOrientacion")
        If Not menuOrientacion Is Nothing Then
            If menuOrientacion.Value = "vertical" Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "menuSideV", "$('#MenuPrincipalSide').show(); $('.main-sidebar').show(); $('body').removeClass('layout-top-nav').addClass('sidebar-mini');$('#grupoPresentacion').hide(); $('div.ajuste').removeClass('container');$('#botonMenu').show();", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), "menuSideH", "$('#MenuPrincipal').show(); $('#MenuPrincipalSide').hide(); $('body').removeClass('sidebar-mini').addClass('layout-top-nav');$('#grupoPresentacion').show();$('#botonMenu').hide(); ", True)
            End If
        Else
            '******** Configuración de orientación de menu por Default
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), "menuSideDefault", "$('#MenuPrincipal').show(); $('#MenuPrincipalSide').hide(); $('body').removeClass('sidebar-mini').addClass('layout-top-nav');$('#grupoPresentacion').show();$('#botonMenu').hide(); ", True)

        End If
    End Sub



End Class