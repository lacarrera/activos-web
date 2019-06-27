<%@ Application Language="VB" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    Sub Application_Start(sender As Object, e As EventArgs)
        'RouteConfig.RegisterRoutes(RouteTable.Routes)


        Application("aplication_name") = "ACTIVOS FIJOS"
        Application("backgroundImage") = "fm.svg"
        Application("patron") = "pattern2.png"
        Application("inicio") = "../../Default.aspx"
        Application("anioActual") = Date.Now.Date.Year
        Application("version") = "1.0.0"

    End Sub
    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a new session is started
        Session.Timeout = "20"
    End Sub



    'Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
    '    Dim URL_path As String = HttpContext.Current.Request.Path
    '    If URL_path.Contains(".aspx") Then
    '        Context.RewritePath(URL_path.Replace(".aspx", ""))
    '    End If
    'End Sub

</script>