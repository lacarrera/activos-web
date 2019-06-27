<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Account_Login" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>

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
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>First Majestic | Activos Fijos </title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <!-- jQuery 2.2.3 -->
      <script src='<%= ResolveClientUrl("~/plugins/jQuery/jquery-2.2.3.min.js")%>'></script>

    <!-- Font Awesome -->
    <script src="https://use.fontawesome.com/d2639ceada.js" async="async"></script>
<%--    <link href='<%= ResolveClientUrl("~/dist/img/favicons.png")%>' rel="shortcut icon" />--%>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js" async="async"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js" async="async"></script>
  <![endif]-->
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href='<%= ResolveClientUrl("~/bootstrap/css/bootstrap.min.css")%>'>
    <!-- Theme style -->
    <link rel="stylesheet" href='<%= ResolveClientUrl("~/dist/css/AdminLTE.min.css")%>'>
    <script src='<%= ResolveClientUrl("~/bootstrap/js/bootstrap.min.js")%>'></script>
    <!-- CSS -->
    <link href="<%=ResolveClientUrl("~/plugins/sweetalert/sweetalert.css")%>" rel="stylesheet" />
    <script src='<%= ResolveClientUrl("~/plugins/sweetalert/sweetalert.min.js")%>' async="async"></script>
    <link href="<%=ResolveClientUrl("~/dist/css/loaders3d.css")%>" rel="stylesheet" />

    <link href='https://fonts.googleapis.com/css?family=Roboto' rel='stylesheet' />
    <script type="text/javascript">
        function alertaError(msg) {
            // alertify.error(msg);
            ok = '<asp:Literal runat="server" Text="<%$ resources:globalResources, ok %>" />';
        swal({
            title: "Oops",
            text: msg,
            icon: "warning",
            buttons: ok,
            dangerMode: true,
        });
        return false;
    }
    function loader() {
        $("#loading").css("display", "block");
    }
    </script>
</head>
<body class="hold-transition login-page">
    <header class="panel-heading bg-black ">
        <div class="panel-title text-center">
            <b>
                <asp:Label ID="aplication_name" Style="color:white;" runat="server" meta:resourcekey="tituloPortal"></asp:Label>
            </b>
        </div>
    </header>
    <div class="login-box">
      <div style="box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);">
        <div class=" text-center" style="background-color:white" >
            <%--<img src="../dist/img/fm.svg" alt="" style="width: 50%;" />--%>
            <div id="loading" class="loader loader--fade" style="display: none">
                <span class="loader-item">1</span>
                <span class="loader-item">2</span>
                <span class="loader-item">3</span>
                <span class="loader-item">4</span>
                <span class="loader-item">5</span>
                <span class="loader-item">6</span>
            </div>
        </div>
       <div class="login-box-body no-margin">
            <form id="form1" runat="server">
                <script type="text/javascript">
                    $(document).ready(function () {
                        if ($("#HiddenField1").val() != "") {
                            $("#mensaje").show();
                        } else {
                            $("#mensaje").hide();
                        }
                        document.getElementById('<%= HiddenSociedad.ClientID%>').value = localStorage.getItem("cualSociedad")
                    });
                    function WebForm_OnSubmit() {
                        if (typeof (ValidatorOnSubmit) == "function" && ValidatorOnSubmit() == false) {
                            $("#mensaje").slideDown("slow");
                            $("#loading").css("display", "none");
                        } else
                            $("#mensaje").slideUp("slow");
                    }
                </script>
               <asp:Login ID="Login1" runat="server" EnableViewState="False" RenderOuterTable="False" meta:resourcekey="Login1Resource1">
                    <LayoutTemplate>
                        <div>
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                        CssClass="failureNotification" ErrorMessage="<%$ resources:errorUser %>" ToolTip="El nombre de usuario es obligatorio."
                                        ValidationGroup="LoginUserValidationGroup" meta:resourcekey="UserNameRequiredResource1">*</asp:RequiredFieldValidator><i class="fa  fa-user fa-lg"></i></span>
                                <asp:TextBox ID="UserName" runat="server" CssClass="form-control" meta:resourcekey="UserNameResource1"></asp:TextBox>
                            </div>
                            <br />
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                        CssClass="failureNotification" ErrorMessage="<%$ resources:errorPass %>" ToolTip="La contraseña es obligatoria."
                                        ValidationGroup="LoginUserValidationGroup" meta:resourcekey="PasswordRequiredResource1">*</asp:RequiredFieldValidator><i class="fa fa-lock fa-lg "></i></span>
                                <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password" meta:resourcekey="PasswordResource1"></asp:TextBox>
                            </div>
                            <br />
                        </div>
                        <asp:Button ID="LoginButton" runat="server" CommandName="Login" OnClientClick="loader();"
                            CssClass="btn btn-info btn-block btn-flat" meta:resourcekey="sesion" ValidationGroup="LoginUserValidationGroup" />
                         <hr style="margin-bottom:0px">
                        <div id="mensaje" class="alert alert-warning alert-dismissible">
                            <h4><i class="icon fa fa-warning"></i>
                                <asp:Literal runat="server" Text="<%$ resources:atencion %>" /></h4>
                            <span class="failureNotification">
                                <asp:Literal ID="FailureText" runat="server" Text="<%$ resources:FailureText %>"></asp:Literal>
                            </span>
                            <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="failureNotification"
                                ValidationGroup="LoginUserValidationGroup" meta:resourcekey="LoginUserValidationSummaryResource1" />
                        </div>
                        <div class="checkbox" style="font-size:.9em">
                            <label>
                                <asp:CheckBox ID="RememberMe" runat="server" CssClass="checkbox" meta:resourcekey="RememberMeResource1" />
                                <asp:Literal runat="server" Text="<%$ resources:conectado %>" />
                            </label>
                        </div>
                    </LayoutTemplate>
                </asp:Login>
                <asp:HiddenField ID="sinUnidad" runat="server" Value="<%$ resources:sinUnidad %>"></asp:HiddenField>
                <asp:HiddenField ID="sinRol" runat="server" Value="<%$ resources:sinRol %>"></asp:HiddenField>
                <asp:HiddenField ID="sinSociedad" runat="server" Value="<%$ resources:sinSociedad %>"></asp:HiddenField>
                <asp:HiddenField ID="sinContratista" runat="server" Value="<%$ resources:sincontratista %>"></asp:HiddenField>
                <asp:HiddenField ID="usuarioNoActivo" runat="server" Value="<%$ resources:usuarioActivo %>"></asp:HiddenField>
                <asp:HiddenField ID="HiddenField1" runat="server" />
              <asp:HiddenField ID="HiddenSociedad" runat="server" />
                <asp:HiddenField ID="mensajeDominio" runat="server" Value="<%$ resources:errorDominio %>"></asp:HiddenField>
                <asp:HiddenField ID="errorDatos" runat="server" Value="<%$ resources:errorDatos %>"></asp:HiddenField>
            </form>
         <hr class="no-margin">
            <div class="row">
                <div class="col-xs-12 text-right pad"><a style="font-size:.9em" href="mailto:SoporteDev@firstmajestic.com">
                   <i class="fa fa-wrench" aria-hidden="true"></i> <asp:Literal runat="server" Text="<%$ resources:problemas %>" /></a></div>
            </div>
        </div>
        </div>
        <div class="row no-margin no-padding  text-right">
            <% If Session("Idioma") = "IN" Then %>
            <asp:HyperLink ID="HyperLink_Spanish" runat="server"
                NavigateUrl="~/IdiomaES.aspx"
                ToolTip="Cambiar de Idioma a Español" meta:resourcekey="HyperLink_SpanishResource1"><img src="<%= ResolveClientUrl("~/dist/img/mexico_flag_round.png")%>" class="img-circle"   style="width:40px; padding-top:3px" /></asp:HyperLink>
            <% Else%>
            <asp:HyperLink ID="HyperLink_English" runat="server"
                NavigateUrl="~/IdiomaEN.aspx"
                ToolTip="Change language to English" meta:resourcekey="HyperLink_EnglishResource1"><img src="<%= ResolveClientUrl("~/dist/img/canada_flag_round.png")%>" class="img-circle"  style="width:40px; padding-top:3px" /></asp:HyperLink>
            <% End If%>
        </div>
        <!-- /.login-box-body -->
    </div>
    <!-- /.login-box -->
</body>
</html>