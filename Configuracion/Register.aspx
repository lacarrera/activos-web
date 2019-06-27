<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Register.aspx.vb" Inherits="Configuracion_Register" MasterPageFile="~/Site.master" culture="auto" meta:resourcekey="PageResource1" uiculture="auto"   %>
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
   
<script type="text/javascript">
    $(document).ready(function () {
        $("#MainContent_RegisterUser_CreateUserStepContainer_Email").blur(function () {
            var correo = $("#MainContent_RegisterUser_CreateUserStepContainer_Email").val();
            var usuario = correo.split("@", 1);
            $("#MainContent_RegisterUser_CreateUserStepContainer_UserName").val(usuario);
            $("#MainContent_RegisterUser_CreateUserStepContainer_Password").val('Inicio01');
            $("#MainContent_RegisterUser_CreateUserStepContainer_ConfirmPassword").val('Inicio01');

        });
    });
    </script>
     <style type="text/css">
        .CheckboxList input, .CheckboxList label, #MainContent_RegisterUser_CreateUserStepContainer_CheckBoxList_Sociedades input, #MainContent_RegisterUser_CreateUserStepContainer_CheckBoxList_Sociedades label
 	    {
	        display:inline !important;
	    }
	    #MainContent_RegisterUser_CreateUserStepContainer_CheckBoxList_Roles
	    {
	        display:inline !important;
	    }
    </style>
         <asp:createuserwizard id="RegisterUser" runat="server" enableviewstate="False"
             oncreateduser="RegisterUser_CreatedUser" logincreateduser="False"
             requireemail="False" meta:resourcekey="RegisterUserResource1" ContinueDestinationPageUrl="~/Configuracion/Register.aspx">
        <LayoutTemplate>
            <asp:PlaceHolder ID="wizardStepPlaceholder" runat="server"></asp:PlaceHolder>
            <asp:PlaceHolder ID="navigationPlaceholder" runat="server"></asp:PlaceHolder>
        </LayoutTemplate>
             <WizardSteps>
                 <asp:CreateUserWizardStep ID="RegisterUserWizardStep" runat="server"
                     meta:resourcekey="RegisterUserWizardStepResource1">
                     <ContentTemplate>
                         <div class="box box-solid box-default">
                             <div class="box-header with-border">
                                 <h1 class="box-title">   <%if Session("idioma") = "IN" Then%>Create New User<%Else  %>Crear Nuevo Usuario<%End If %><small><br /><%if Session("idioma") = "IN" Then%>Use the form below to create a new account<%Else  %>Use el formulario siguiente para crear una cuenta nueva<%End If %>.<br />
                            <%--  <%if Session("idioma") = "IN" Then%>Passwords must be at least 6 characters in length.<%Else  %>Las contraseñas deben tener una longitud mínima de 6 caracteres.<%End If %> 
                        --%>
                          </small>
                                 </h1>
                             </div>
                             <div class="box-body">
                                 <div id="mensaje" class="alert alert-warning alert-dismissible">
                                     <h4><i class="icon fa fa-warning"></i>
                                         <asp:Label ID="LabelAlerta" runat="server"
                                             meta:resourcekey="LabelAlerta"></asp:Label></h4>
                                     <h6>
                                         <span id="mensajeError">
                                         <asp:Literal ID="ErrorMessage" runat="server"
                                             meta:resourcekey="ErrorMessageResource1"></asp:Literal>
                                         </span>                         
                                         <asp:ValidationSummary ID="RegisterUserValidationSummary" runat="server"
                                             ValidationGroup="RegisterUserValidationGroup"
                                             meta:resourcekey="RegisterUserValidationSummaryResource1" />
                                     </h6>
                                 </div>                            
                                 <div class="box box-solid box-default">
                                     <div class="box-header with-border">
                                         <h3 class="box-title">   <%if Session("idioma") = "IN" Then%>User Information.<%Else  %>Información de cuentas.<%End If %></h3>
                                     </div>
                                     <!-- /.box-header -->
                                     <div class="box-body">
                                         <div class="row">                                             
                                            <div class="col-md-4">

                                                <div class="form-group">
                                                     <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email"
                                                         meta:resourcekey="EmailLabelResource1">Correo electrónico:</asp:Label>

                                                     <div class="input-group">
                                                         <div class="input-group-addon">
                                                             <asp:RequiredFieldValidator ID="EmailRequired" runat="server"
                                                                 ControlToValidate="Email"
                                                                 CssClass="failureNotification"
                                                                 Display="Dynamic"
                                                                 ErrorMessage="El correo electrónico es obligatorio."
                                                                 ToolTip="El correo electrónico es obligatorio."
                                                                 ValidationGroup="RegisterUserValidationGroup"
                                                                 meta:resourcekey="EmailRequiredResource1">*</asp:RequiredFieldValidator>
                                                             <i class="fa fa-at"></i>
                                                         </div>
                                                         <asp:TextBox ID="Email" runat="server" CssClass="form-control"
                                                             meta:resourcekey="EmailResource1"></asp:TextBox>
                                                     </div>
                                                     <!-- /.input group -->
                                                 </div>
                                                 <!-- /.form-group -->

                                                
                                                  
                                                <div class="form-group">
                                                     
                                                     <asp:Label ID="NombreCompletoLabel" runat="server" AssociatedControlID="Email"
                                                         meta:resourcekey="NombreCompletoLabelResource1">Nombre Completo del Usuario:</asp:Label>

                                                     <div class="input-group">
                                                         <div class="input-group-addon">
                                                              <asp:RequiredFieldValidator ControlToValidate="NombreCompleto"
                                                             CssClass="failureNotification" Display="Dynamic"
                                                             ErrorMessage="Nombre Completo es obligatorio."
                                                             ID="RequiredFieldValidator1" runat="server"
                                                             ToolTip="Nombre Completo es obligatorio."
                                                             ValidationGroup="RegisterUserValidationGroup"
                                                             meta:resourcekey="RequiredFieldValidator1Resource1">*</asp:RequiredFieldValidator>
                                                             <i class="fa fa-male"></i>
                                                         </div>
                                                         <asp:TextBox ID="NombreCompleto" runat="server" CssClass="form-control"
                                                             meta:resourcekey="NombreCompletoResource1"></asp:TextBox>
                                                        
                                                     </div>
                                                     <!-- /.input group -->
                                                 </div>

                                                 
                                                
                                             </div>
                                             <!-- /.col -->
                                             <div class="col-md-4">

                                                  <div class="form-group">
                                                     <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName"
                                                         meta:resourcekey="UserNameLabelResource1">Id del usuario:</asp:Label>
                                                     <div class="input-group">
                                                         <div class="input-group-addon">
                                                                                   <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                             CssClass="failureNotification"
                                                             ErrorMessage="El nombre de usuario es obligatorio." ToolTip="El nombre de usuario es obligatorio."
                                                             ValidationGroup="RegisterUserValidationGroup"
                                                             meta:resourcekey="UserNameRequiredResource1">*</asp:RequiredFieldValidator>
                                                             <i class="fa fa-key"></i>
                                                         </div>
                                                         <asp:TextBox ID="UserName" runat="server" CssClass="form-control"
                                                             meta:resourcekey="UserNameResource1"></asp:TextBox>
                                                    </div>
                                                     <!-- /.input group -->
                                                 </div>
                                                
                                                 <!-- /.form-group -->

                                                
                                                 <div class="form-group">
                                                     <asp:Label ID="PuestoTrabajoLabel1" runat="server" AssociatedControlID="Email"
                                                         meta:resourcekey="PuestoTrabajoLabel1Resource1">Puesto de Trabajo:</asp:Label>

                                                     <div class="input-group">
                                                         <div class="input-group-addon">
                                                             <asp:RequiredFieldValidator ControlToValidate="PuestoTrabajo"
                                                                 CssClass="failureNotification" Display="Dynamic"
                                                                 ErrorMessage="El Puesto de Trabajo es obligatorio."
                                                                 ID="RequiredFieldValidator2" runat="server"
                                                                 ToolTip="El Puesto de Trabajo es obligatorio."
                                                                 ValidationGroup="RegisterUserValidationGroup"
                                                                 meta:resourcekey="RequiredFieldValidator2Resource1">*</asp:RequiredFieldValidator>
                                                             <i class="fa  fa-wrench"></i>
                                                         </div>
                                                         <asp:TextBox ID="PuestoTrabajo" runat="server" CssClass="form-control"
                                                             meta:resourcekey="PuestoTrabajoResource1"></asp:TextBox>

                                                     </div>
                                                     <!-- /.input group -->
                                                 </div>
                                                 <!-- /.form-group -->
                                             </div>
                                             <!-- /.col -->
                                             <div class="col-md-4" style="display:none;">
                                                  <div class="form-group">
                                                     <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password"
                                                         meta:resourcekey="PasswordLabelResource1">Contraseña:</asp:Label>

                                                     <div class="input-group">
                                                         <div class="input-group-addon">
                                                              <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                             CssClass="failureNotification"
                                                             ErrorMessage="La contraseña es obligatoria." ToolTip="La contraseña es obligatoria."
                                                             ValidationGroup="RegisterUserValidationGroup"
                                                             meta:resourcekey="PasswordRequiredResource1">*</asp:RequiredFieldValidator>
                                                             <i class="fa fa-lock"></i>
                                                         </div>
                                                         <asp:TextBox ID="Password" runat="server" CssClass="form-control"
                                                             TextMode="Password" meta:resourcekey="PasswordResource1"></asp:TextBox>
                                                        
                                                     </div>
                                                     <!-- /.input group -->
                                                 </div>
                                                 <!-- /.form-group -->

                                                 <div class="form-group">
                                                     <asp:Label ID="ConfirmPasswordLabel" runat="server"
                                                         AssociatedControlID="ConfirmPassword"
                                                         meta:resourcekey="ConfirmPasswordLabelResource1">Confirmar contraseña:</asp:Label>

                                                     <div class="input-group">
                                                         <div class="input-group-addon">
                                                             <asp:RequiredFieldValidator ControlToValidate="ConfirmPassword"
                                                                 CssClass="failureNotification" Display="Dynamic"
                                                                 ErrorMessage="Confirmar contraseña es obligatorio."
                                                                 ID="ConfirmPasswordRequired" runat="server"
                                                                 ToolTip="Confirmar contraseña es obligatorio."
                                                                 ValidationGroup="RegisterUserValidationGroup"
                                                                 meta:resourcekey="ConfirmPasswordRequiredResource1">*</asp:RequiredFieldValidator>
                                                             <asp:CompareValidator ID="PasswordCompare" runat="server"
                                                                 ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                                                                 CssClass="failureNotification" Display="Dynamic" ErrorMessage="Contraseña y Confirmar contraseña deben coincidir."
                                                                 ValidationGroup="RegisterUserValidationGroup"
                                                                 meta:resourcekey="PasswordCompareResource1">*</asp:CompareValidator>
                                                             <i class="fa fa-lock"></i>
                                                         </div>
                                                         <asp:TextBox ID="ConfirmPassword" runat="server" CssClass="form-control"
                                                             TextMode="Password" meta:resourcekey="ConfirmPasswordResource1"></asp:TextBox>

                                                     </div>
                                                     <!-- /.input group -->
                                                 </div>
                                                 <!-- /.form-group -->
                                                 
                                             </div>
                                         </div>
                                         <div class="row">
                                             <div class="col-md-6">
                                                 <div class="box box-solid box-default">
                                                     <div class="box-header with-border">
                                                         <asp:Label ID="lbl_SociedadPermitida" runat="server"
                                                             Text="Sociedad(es) Permitida(s):"
                                                             meta:resourcekey="lbl_SociedadPermitidaResource1"></asp:Label>
                                                     </div>
                                                     <div id="sociedad" class="box-body">
                                                         <asp:CheckBoxList ID="CheckBoxList_Sociedades" runat="server" DataSourceID="SDSSociedades" CssClass="checkbox" DataTextField="Nombre" DataValueField="Sociedad"></asp:CheckBoxList>
                                                         
                                                                                                                 
                                                         <%--<asp:RadioButtonList ID="CheckBoxList_Sociedades" runat="server" DataSourceID="SDSSociedades"
                                                             DataTextField="Descripcion" DataValueField="Sociedad" RepeatLayout="Flow"
                                                             CssClass="radio"
                                                             OnDataBound="CheckBoxList_Sociedades_DataBound"
                                                             meta:resourcekey="CheckBoxList_SociedadesResource1">
                                                         </asp:RadioButtonList>--%>
                                                         <asp:SqlDataSource ID="SDSSociedades" runat="server"
                                                             ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="Select cast(Sociedad as varchar) as Sociedad, cast(Sociedad as varchar) + ' - ' + Descripcion As Nombre from Sociedades
Union
Select '%' As Sociedad, '% - Todas las Sociedades' As Nombre" 
                                                             ProviderName="<%$ ConnectionStrings:Activos.ProviderName %>"></asp:SqlDataSource>
                                                     </div>
                                                 </div>
                                             </div>
                                             <div class="col-md-6">
                                                 <div class="box box-solid box-default">
                                                     <div class="box-header with-border">
                                                         <asp:Label ID="lbl_RolAsignado" runat="server" Text="Rol(es):"
                                                             meta:resourcekey="lbl_RolAsignadoResource1"></asp:Label>
                                                     </div>
                                                     <div id="roles" class="box-body">
                                                          <asp:CheckBoxList ID="CheckBoxList_Roles" runat="server"
                                                             DataSourceID="SDSRoles" DataTextField="RoleName" DataValueField="RoleId"
                                                             RepeatLayout="Flow" CssClass="checkbox"
                                                             Font-Bold="False"
                                                             meta:resourcekey="CheckBoxList_RolesResource1">
                                                         </asp:CheckBoxList>
                                                         <asp:SqlDataSource ID="SDSRoles" runat="server"
                                                             ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
                                                             SelectCommand="SELECT [RoleId], [RoleName] FROM [Autenticacion].[dbo].[vw_aspnet_Roles] WHERE ApplicationId = @ApplicationId">
                                                             <SelectParameters>
                                                                 <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                                                     Name="ApplicationId" />
                                                             </SelectParameters>
                                                         </asp:SqlDataSource>

                                                     </div>
                                                 </div>
                                             </div>
                                         </div>
                                         <!-- /.row -->
                                       <%--  <div class="row">
                                             <div class="col-md-12">
                                                 <div id="generico">
                                                <asp:CheckBox ID="check_esgenerico" runat="server" meta:resourcekey="GenericoLabelResource1" />
                                                     </div>
                                             </div>
                                         </div>--%>
                                     </div>
                                     <!-- /.box-body -->
                                     <div class="box-footer">
                                         <asp:Button ID="CreateUserButton" runat="server" CommandName="MoveNext"
                                             ValidationGroup="RegisterUserValidationGroup"
                                             CssClass="pull-right btn btn-default"
                                             meta:resourcekey="CreateUserButtonResource1" />
                                     </div>
                                 </div>
                             </div>
                         </div>
                         <br />
                         <br />
                     </ContentTemplate>
                     <CustomNavigationTemplate>
                     </CustomNavigationTemplate>
                 </asp:CreateUserWizardStep>
                 <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server"
                     meta:resourcekey="CompleteWizardStep1Resource1">
                     <ContentTemplate>
                         <div class="row vertical-align">
                             <div class="col-md-4 col-md-offset-4">
                                 <div class="box box-solid box-default">
                                     <div class="box-header">
                                         <h1 class="box-title">Nuevo usuario</h1>
                                     </div>
                                     <div class="box-body">
                                         <div class="info-box">
                                             <span class="info-box-icon bg-green"><i class="fa fa-male"></i></span>

                                             <div class="info-box-content">
                                                 <span class="info-box-number">
                                                     <asp:Label ID="exitoTitulo" runat="server" meta:resourcekey="exitoTituloResource1"></asp:Label>
                                                 </span>
                                                 <span>
                                                     <asp:Label ID="exitoMensaje" runat="server" meta:resourcekey="exitoMensajeResource1"></asp:Label>
                                                 </span>
                                             </div>
                                         </div>
                                     <div class="box-footer">
                                         <asp:Button ID="ContinueButton" runat="server" CssClass="pull-right btn btn-default" CausesValidation="False" CommandName="Continue" Font-Names="Verdana" ForeColor="#284775" Text="Continuar" ValidationGroup="CreateUserWizard1" meta:resourcekey="ContinueButtonResource1" />
                                     </div>
                                 </div>
                                  <!-- small box -->
                                 
                             </div>
                         </div>
                         
                          
                     </ContentTemplate>
                 </asp:CompleteWizardStep>
             </WizardSteps>
    </asp:createuserwizard>
      
   <script type="text/javascript">
       $(function () {
          // $("#test input").removeAttr('style');
           $("#roles input, #sociedad input, #generico input ").css("margin-left", "0px");

           
          
       });
      // $("#mensaje").hide();
       function WebForm_OnSubmit() {
          
                       if (typeof (ValidatorOnSubmit) == "function" && ValidatorOnSubmit() == false) {
                           $("#mensaje").slideDown("slow");
                           return false;
                     } else
                           $("#mensaje").slideUp("slow");
                       return true;
       }

   </script>   
          <script src='<%= ResolveClientUrl("~/plugins/jQueryUI/jquery-ui.js")%>'></script>

 </asp:Content>

