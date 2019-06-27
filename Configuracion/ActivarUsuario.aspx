<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ActivarUsuario.aspx.vb" Inherits="Configuracion_ActivarUsuario" MasterPageFile="~/Site.master" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>
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
$(document).ready(function(){
  $("#buscar").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $(".Renglon").filter(function () {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});
</script>
        <div class="box box-solid box-default">
              <div class="box-header with-border">
              <h3 class="box-title"> <asp:Label ID="lbl_Titulo" runat="server" Text="Seleccione un Usario y Activelo o Inactivelo" meta:resourcekey="lbl_TituloResource1"></asp:Label></h3>
            </div>
          
            <div class="box-body" >
                <input class="form-control" id="buscar" type="text" placeholder="Buscar Usuario..."/><br />
      <asp:Button ID="btn_inactivate" runat="server" Text="Desactivar Seleccionados" CssClass="btn  btn-default"  meta:resourcekey="btn_inactivateResource1" />
                             
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="btn_activate" runat="server" Text="Activar Seleccionados" CssClass="btn  btn-default"  meta:resourcekey="btn_activateResource1" />
           
        </div>
            <!-- /.box-body -->
            

   </div>
           <div id="Grid"   class="box box-default"  style ="height:100%; width:100%; overflow:hidden;" > 
                   <div id="DivGrid" class="row">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SDSActivarUsuarios"  meta:resourcekey="GridView1Resource1"   GridLines="None"  
                AllowPaging="True"  CssClass="table table-bordered table-hover table-striped no-padding" PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt"  
                PageSize="50"        >
                <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                <Columns>
            <asp:TemplateField meta:resourcekey="TemplateFieldResource1">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox_Autorizar" runat="server" meta:resourcekey="CheckBox_AutorizarResource1" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox_Autorizar" runat="server" meta:resourcekey="CheckBox_AutorizarResource2" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Estatus" HeaderText="Estatus" ReadOnly="True" 
                SortExpression="Estatus" meta:resourcekey="BoundFieldResource1" />
            <asp:BoundField DataField="UserName" HeaderText="UserName" 
                SortExpression="UserName" meta:resourcekey="BoundFieldResource2" />
            <asp:BoundField DataField="Sociedad" HeaderText="Sociedad" 
                SortExpression="Sociedad" meta:resourcekey="BoundFieldResource3" />
            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" meta:resourcekey="BoundFieldResource4" />
            <asp:BoundField DataField="LastActivityDate" HeaderText="LastActivityDate" 
                SortExpression="LastActivityDate" DataFormatString="{0:yyyy-MM-dd}" meta:resourcekey="BoundFieldResource5" />
            <asp:BoundField DataField="Roles" HeaderText="Roles" SortExpression="Roles" meta:resourcekey="BoundFieldResource6" />
        </Columns>
      
                <HeaderStyle BackColor="#D2D6DE" />
                 <RowStyle CssClass="Renglon" />
                 <AlternatingRowStyle CssClass="Renglon" />
                <PagerStyle CssClass="pgr"></PagerStyle>
      
                  </asp:GridView>
    <asp:SqlDataSource ID="SDSActivarUsuarios" runat="server" 
        
        ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
	CASE
		WHEN b.IsApproved=1 THEN 'Activo'
		ELSE 'Inactivo'
	END As Estatus,
	a.UserName,
	b.Email,
	a.LastActivityDate,
	dbo.SociedadesPermitidas_Lineal(a.UserName,@ApplicationId) As Sociedad,
                   dbo.RolesAsignados_Lineal(a.UserName,@ApplicationId) As Roles
FROM Autenticacion.dbo.aspnet_Users AS a LEFT JOIN
	Autenticacion.dbo.aspnet_Membership AS b ON a.UserId = b.UserId
	WHERE a.ApplicationId = @ApplicationId" 
    ProviderName="<%$ ConnectionStrings:Activos.ProviderName %>">
        <SelectParameters>
            <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>" 
                Name="ApplicationId" />
        </SelectParameters>
    </asp:SqlDataSource>
       </div>
                        </div>

 
</asp:Content>