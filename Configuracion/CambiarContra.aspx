<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CambiarContra.aspx.vb" Inherits="Configuracion_CambiarContra" MasterPageFile="~/Site.master" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>
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
                    <asp:Label ID="Label1" runat="server" Text="Resetar Contraseña" meta:resourcekey="Label1Resource1"></asp:Label></h3>
            </div>
            <div class="box-body">
                <div class="row" style="margin: 5px;">
                    <div class="col-md-4">
                        <asp:Label ID="lbl_Usuario" runat="server" Text="Usuario: " meta:resourcekey="lbl_UsuarioResource1"></asp:Label>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddl_Usuarios" runat="server" DataSourceID="SDSUsuarios"
                            DataTextField="UserName" DataValueField="UserId" CssClass="form-control select2" Style="width: 100%"  meta:resourcekey="ddl_UsuariosResource1">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDSUsuarios" runat="server"
                            ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
                            SelectCommand="SELECT [UserId], [UserName] FROM [Autenticacion].[dbo].[vw_aspnet_Users] WHERE LOWER(ApplicationId) = LOWER(@ApplicationId)">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                    Name="ApplicationId" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div class="col-md-4">
                    
                    <asp:Button ID="btn_Restart" runat="server" Text="Reiniciar Contraseña"
                        CssClass="btn btn-default" Width="250px" meta:resourcekey="btn_RestartResource1" />
                        </div>
                </div>
            </div>

        

        </div>
</asp:Content>