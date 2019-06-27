<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CrearRol.aspx.vb" Inherits="Configuracion_CrearRol" MasterPageFile="~/Site.master" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Globalization" %>
<script runat="server">
    Protected Overrides Sub InitializeCulture()
        If Not Session("Idioma") Is Nothing Then
            Dim selectedLanguage As String = "" 'Session("LANG")
            If Session("Idioma") = "IN" Then
                selectedLanguage = "en"
            Else
                selectedLanguage = "es-mx"
            End If
            UICulture = selectedLanguage
            Culture = selectedLanguage
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(selectedLanguage)
            Thread.CurrentThread.CurrentUICulture = New CultureInfo(selectedLanguage)
            MyBase.InitializeCulture()
        End If
    End Sub
</script>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
        <div class="box box-solid box-default">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <asp:Label ID="Label1" runat="server" Text="Crear nuevo Rol" ></asp:Label></h3>
            </div>
            <div class="box-body">
                <div class="row" style="margin: 5px;">
                    <div class="col-md-4">
                        <asp:Label ID="LBL_ROL" runat="server" Text="Nuevo Rol: " ></asp:Label>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txt_descripcion_rol" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                    
                    <asp:Button ID="btn_Restart" runat="server" Text="Generar Rol"
                        CssClass="btn btn-default" Width="250px"  />
                        </div>
                </div>
            </div>   
        </div>
</asp:Content>