﻿
Partial Class IdiomaES
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim PathPreviousPage As String = Page.Request.ServerVariables("HTTP_REFERER").ToString
        'Dim previousPage As Page = Page.PreviousPage
        Session("Idioma") = "ES"
        'Session("LANG") = Request.QueryString("lang")
        Response.Redirect(PathPreviousPage)
        'Response.Write("<script language='javascript'>history.back();</script>")
    End Sub
End Class
