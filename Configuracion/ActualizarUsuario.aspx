<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ActualizarUsuario.aspx.vb" Inherits="Configuracion_ActualizarUsuario" MasterPageFile="~/Site.master" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>

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
        $(function () {
            $('#general').click(function () {
                document.getElementById('<%= tabSeleccionado.ClientID%>').value = 'general';
            });
            $('#sociedades').click(function () {
                document.getElementById('<%= tabSeleccionado.ClientID%>').value = 'sociedades';

            });
            $('#roles').click(function () {
                document.getElementById('<%= tabSeleccionado.ClientID%>').value = 'roles';

            });
            sele = document.getElementById('<%= tabSeleccionado.ClientID%>').value;
            $('#general, #generales').removeClass("active");
            $('#sociedad, #sociedades').removeClass("active");
            $('#rol, #roles').removeClass("active");
          
            if (sele == 'general') {
                $('#general, #generales').addClass("active");
            }
            if (sele == 'sociedades') {
                $('#sociedad, #sociedades').addClass("active");
            }
            if (sele == 'roles') {
                $('#rol, #roles').addClass("active");
            }
        });
    </script>
    <asp:HiddenField ID="tabSeleccionado" ClientIDMode="Static" runat="server" />
    <script type="text/javascript" src="../Scripts/ActualizarUsuario.js"></script>
    <div class="well">
       <input class="form-control" id="buscar" type="text" placeholder="Buscar Usuario..." />
    </div>
   
    <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
            <li id="generales" class="active"><a href="#general" data-toggle="tab"><% If Session("Idioma") = "IN" Then %>General Information<% Else%>Información General<% End If%></a></li>
            <li id="sociedad"><a href="#sociedades" data-toggle="tab"><% If Session("Idioma") = "IN" Then %>Set Society<% Else%>Asignar Sociedades<% End If%></a></li>
            <li id="rol"><a href="#roles" data-toggle="tab"><% If Session("Idioma") = "IN" Then %>Set Roles<% Else%>Asignar roles<% End If%></a></li>
        </ul>
        <div class="tab-content" style="padding-top: 20px">
            <div class="tab-pane active" id="general">
                <div id="grid" class="box box-default" style="height: 100%; width: 100%; overflow: auto;">
                   
                <div class="box-body">
                <div class="well">
                <h1>               
                <asp:LinkButton ID="btnExport" runat="server" CausesValidation="False" CssClass="btn btn-success Excel" title="Exportar" Text="Exportar a Excel"  Font-Size="Large" ForeColor="White"><i class="fa fa-file-excel-o" aria-hidden="true"></i> Exportar</asp:LinkButton>
                <asp:Label ID="lbl_Titulo" runat="server" Text="Usuarios Activos" Font-Bold="True"></asp:Label>
                    <asp:Label ID="lblTotalRegistros" runat="server" Text="" CssClass="label label-warning bg-gray-active" />
                </h1>
                <hr />
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>

                        <asp:HiddenField ID="hf_pestana" runat="server" />
                        <script type="text/javascript">
                            var prm = Sys.WebForms.PageRequestManager.getInstance();
                            prm.add_endRequest(function () {
                                $(".Editar_grid").click(function () {
                                    $("#" + this.id + " i:first").removeClass("fa-pencil con-4x").addClass("fa-refresh fa-spin");

                                });

                                $(".Actualizar").click(function () {
                                    $("#" + this.id).html("<i class='fa fa-refresh fa-spin'></i> Actualizando...");
                                });

                                $(".Cancelar").click(function () {
                                    $("#" + this.id).html("<i class='fa fa-cog fa-spin'></i> Cancelando...");
                                });
                            });
                        </script>

                        <div id="grid1" runat="server" class="box  box-solid box-default  table-responsive">
                            <asp:GridView ID="GridView1" runat="server"  AutoGenerateColumns="False" DataSourceID="SDSCambiarSociedad" DataKeyNames="UserName" Font-Size="16px"
                                HorizontalAlign="Center" CssClass="table table-bordered table-hover table-striped no-padding">
                               
                                <Columns>
                                    <asp:TemplateField ShowHeader="False">


                                        <EditItemTemplate>
                                            <asp:LinkButton ID="Button1" runat="server" CausesValidation="True" CommandName="Update" CssClass="btn btn-default btn-sm Actualizar" title="Modificar Posición" Text="Modificar" Font-Size="Large"><i class="fa" aria-hidden="true"></i> Modificar</asp:LinkButton>
                                            <asp:LinkButton ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="btn btn-default btn-sm Cancelar" title="Cancelar" Text="Modificar" Font-Size="Large"><i class="fa" aria-hidden="true"></i> Cancelar</asp:LinkButton>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="Editar" runat="server" CausesValidation="False" CommandName="Edit" CssClass="btn btn-default btn-sm Editar_grid" title="Editar Posición" Text="Editar" Font-Size="Large"><i class="fas fa-pencil-alt"></i></asp:LinkButton>

                                        </ItemTemplate>

                                    </asp:TemplateField>
                                    <asp:BoundField DataField="UserName" HeaderText="Usuario"
                                        SortExpression="UserName" ReadOnly="True">
                                        <ItemStyle BackColor="#CCCCCC" Font-Bold="True" ForeColor="Black" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre Completo" SortExpression="NombreCompleto" ControlStyle-CssClass="form-control">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PuestoTrabajo" HeaderText="Puesto de Trabajo" SortExpression="PuestoTrabajo" ControlStyle-CssClass="form-control">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" ControlStyle-CssClass="form-control">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RoleName" HeaderText="RoleName" ReadOnly="True" SortExpression="RoleName" />
                                    <asp:BoundField DataField="Sociedad" HeaderText="Sociedad" ReadOnly="True" SortExpression="Sociedad" />
                                 
                                </Columns>
                               <HeaderStyle BackColor="#D2D6DE" />
                 <RowStyle CssClass="Renglon" />
                 <AlternatingRowStyle CssClass="Renglon" />
                            </asp:GridView>
                        </div>
                        <asp:SqlDataSource ID="SDSCambiarSociedad" runat="server"
                            ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT a.UserName, b.Email, dbo.SociedadesPermitidas_Lineal(a.UserName, @ApplicationId) AS Sociedad,  dbo.RolesAsignados_Lineal(a.UserName, @ApplicationId) AS RoleName, a.NombreCompleto, a.PuestoTrabajo FROM Autenticacion.dbo.aspnet_Users AS a LEFT OUTER JOIN Autenticacion.dbo.aspnet_Membership AS b ON a.UserId = b.UserId LEFT OUTER JOIN Sociedades AS e ON a.Sociedad = e.Sociedad WHERE (a.ApplicationId = @ApplicationId) and b.IsApproved = 1 ORDER BY a.UserName"
                            UpdateCommand="-- Actualizar Sociedad, Nombre Completo y Puesto de Trabajo
UPDATE Autenticacion.dbo.aspnet_Users SET NombreCompleto = @NombreCompleto, PuestoTrabajo = @PuestoTrabajo, FechaUltimaModificacion = GetDate() WHERE UserName = @UserName AND ApplicationId = @ApplicationId;
-- Actualizar Correo Electrónico
UPDATE Autenticacion.dbo.aspnet_Membership SET Email = @Email
WHERE
	ApplicationId = @ApplicationId AND UserId = (
	SELECT UserId FROM Autenticacion.dbo.aspnet_Users WHERE UserName = @UserName AND ApplicationId = @ApplicationId
);
--Actualizar  Roles
--UPDATE Autenticacion.dbo.aspnet_UsersInRoles SET RoleId = @RoleId
--WHERE UserId = (
--	SELECT UserId FROM Autenticacion.dbo.aspnet_Users WHERE UserName = @UserName AND ApplicationId = @ApplicationId
--)">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                    Name="ApplicationId" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="NombreCompleto" />
                                <asp:Parameter Name="UserName" />
                                <asp:Parameter Name="Email" />
                                <asp:Parameter Name="RoleId" />
                                <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                    Name="ApplicationId" />
                                <asp:Parameter Name="PuestoTrabajo" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>        
                    </div>
                </div>
            </div>
            
            <div class="tab-pane" id="sociedades">
                <div class="box-default">
                    <div class="box-body">
                   <div class="row">
                  <div class="col-md-6">
                      <div class="box box-solid box-default" style="margin-bottom: 0px;">
                        <div class="box-header with-border">
                        <h3 class="box-title"><% If Session("Idioma") = "IN" Then %>Search<% Else%>Buscar<% End If%></h3>
                        </div>

                           <div class="row" style="margin: 5px;">
                            <div class="col-md-12">
                                <asp:Label ID="Label14" runat="server" Text="Usuario: " AssociatedControlID="ddl_UsuariosFiltro"></asp:Label>
                                <asp:DropDownList ID="ddl_UsuariosFiltro" runat="server" DataSourceID="SDSUsuariosActivosFiltro" DataTextField="Nombre"
                                    DataValueField="UserName" CssClass="form-control select2" Width="100%">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
	        '%' AS UserName,
	        CASE
		        WHEN @idioma = 'ES' THEN 'Todos'
		        ELSE 'All'
	        END AS Nombre
        UNION
        SELECT
	        a.UserName,
	        IsNull(a.UserName,'') As Nombre
        FROM Autenticacion.dbo.aspnet_Users As a LEFT JOIN
	        Autenticacion.dbo.aspnet_Membership As b ON a.ApplicationId = b.ApplicationId AND a.UserId = b.UserId
        WHERE a.ApplicationId = @ApplicationId AND b.IsApproved = '1'">
                                    <SelectParameters>
                                        <asp:SessionParameter DefaultValue="ES" Name="idioma" SessionField="LANG" />
                                        <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                            Name="ApplicationId" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                               </div>
                           <div class="row" style="margin: 5px;">
                            <div class="col-md-12">
                                <asp:Label ID="Label15" runat="server" Text="Sociedad: " AssociatedControlID="ddl_SociedadFiltro"></asp:Label>
                                <asp:DropDownList ID="ddl_SociedadFiltro" runat="server" Width="100%"
                                    DataSourceID="SDSSociedadFiltro" DataTextField="Nombre"
                                    DataValueField="Sociedad" CssClass="form-control select2">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SDSSociedadFiltro" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
	        '%' AS Sociedad,
	        CASE
		        WHEN @idioma = 'ES' THEN 'Todos'
		        ELSE 'All'
	        END AS Nombre
        UNION
        SELECT
            cast(Sociedad as varchar)
            ,cast(Sociedad as varchar) + ' - ' + [Descripcion] As Nombre
        FROM [Sociedades]
        WHERE Activo = 1">
                                    <SelectParameters>
                                        <asp:SessionParameter DefaultValue="ES" Name="idioma" SessionField="LANG" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                               </div>
                
                <div class="row" style="margin: 5px;">
                    <div class="col-md-12">
                      <asp:Button ID="btn_Filtrar" runat="server" Text="Filtrar" CssClass="button button-rounded button-action pull-right" Width="250px" />
                    </div>
                </div>

                        </div>

                  </div>

                   <div class="col-md-6">
                       <div class="box box-solid box-default" style="margin-bottom: 0px;">
                        <div class="box-header with-border">
                        <h3 class="box-title"><% If Session("Idioma") = "IN" Then %>Add Company<% Else%>Agregar Sociedad<% End If%></h3>
                        </div>

                           <div class="row" style="margin: 5px;">
                    <div class="col-md-12">
                        <asp:Label ID="Label16" runat="server" Text="Usuarios Activos: " AssociatedControlID="ddl_UsuariosActivos"></asp:Label>
                        <asp:DropDownList ID="ddl_UsuariosActivos" runat="server" DataSourceID="SDSUsuariosActivos" DataTextField="Nombre" DataValueField="UserId" Width="100%" CssClass="form-control select2">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDSUsuariosActivos" runat="server"
                            ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
	a.UserId,
	IsNull(a.UserName,'') As Nombre
FROM Autenticacion.dbo.aspnet_Users As a LEFT JOIN
	Autenticacion.dbo.aspnet_Membership As b ON a.ApplicationId = b.ApplicationId AND a.UserId = b.UserId
WHERE a.ApplicationId = @ApplicationId AND b.IsApproved = '1'">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                    Name="ApplicationId" />
                                <asp:ControlParameter ControlID="ddl_UsuariosFiltro" Name="Usuario" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    </div>
                           <div class="row" style="margin: 5px;">
                    <div class="col-md-12">
                        <asp:Label ID="Label17" runat="server" Text="Sociedad: " AssociatedControlID="ddl_Sociedad"></asp:Label>
                        <asp:DropDownList ID="ddl_Sociedad" runat="server" DataSourceID="SDSSociedad"
                            DataTextField="Nombre" DataValueField="Sociedad" Width="100%" CssClass="form-control select2">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SDSSociedad" runat="server"
                            ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
       cast(Sociedad as varchar) as Sociedad
      ,cast(Sociedad as varchar) + ' - ' + [Descripcion] As Nombre
  FROM [Sociedades]
  WHERE activo = 1"></asp:SqlDataSource>
                    </div>
                </div>
              
                <div class="row" style="margin: 5px;">
                    <div class="col-md-12">
                        <asp:Button ID="btn_Insertar" runat="server" Text="Agregar" CssClass="button button-rounded button-primary pull-right" Width="250px" />
                    </div>
                </div>

                  </div>
                  </div>
                 </div>
                 

            <div class="well">

                <div class="row ">
                    <div class="col-md-12">
                        <asp:Button ID="btn_Quitar" runat="server" Text="Quitar" CssClass="button button-rounded button-caution pull-left" Width="250px" />
                    </div>
                </div>
                      <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False"
                    DataSourceID="SDSAgregarQuitarSociedad" HorizontalAlign="Center" CssClass="table table-bordered table-hover table-striped no-padding">
                    <AlternatingRowStyle BackColor="Gainsboro" />
                    <Columns>
                        <asp:TemplateField>
                            <EditItemTemplate>
                                <asp:CheckBox ID="CheckBox1" runat="server" />
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="CheckBox_Autorizar" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="UserName" HeaderText="Usuario"
                            SortExpression="UserName" />
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre Completo"
                            SortExpression="NombreCompleto" />
                        <asp:BoundField DataField="Sociedad" HeaderText="Sociedad" ReadOnly="True"
                            SortExpression="Sociedad" />
                        <asp:BoundField DataField="NombreSociedad" HeaderText="Nombre Sociedad" ReadOnly="True"
                            SortExpression="NombreSociedad" />
                        <asp:BoundField DataField="PuestoTrabajo" HeaderText="PuestoTrabajo"
                            SortExpression="PuestoTrabajo" />
                        <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                    </Columns>
                    <HeaderStyle BackColor="#D2D6DE" />
                    <RowStyle HorizontalAlign="Center" CssClass="Renglon" />
                    <AlternatingRowStyle CssClass="Renglon" />
                </asp:GridView>
                <asp:SqlDataSource ID="SDSAgregarQuitarSociedad" runat="server"
                    ConnectionString="<%$ ConnectionStrings:Activos %>"
                    SelectCommand="SELECT a.UserId,
	c.Sociedad,
	a.UserName,
	a.NombreCompleto,
	d.Descripcion As NombreSociedad,
	a.PuestoTrabajo,
	b.Email
FROM Autenticacion.dbo.aspnet_Users AS a LEFT JOIN
	Autenticacion.dbo.aspnet_Membership AS b ON a.ApplicationId = b.ApplicationId AND a.UserId = b.UserId LEFT JOIN
	Autenticacion.dbo.aspnet_Sociedades AS c ON a.ApplicationId = c.ApplicationId AND a.UserId = c.UserId LEFT JOIN
	Sociedades As d ON c.Sociedad = d.Sociedad
WHERE a.ApplicationId = @ApplicationId AND a.UserName LIKE '%' + @usuario AND c.Sociedad LIKE '%' + @Sociedad + '%' and b.IsApproved = 1">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                            Name="ApplicationId" />
                        <asp:ControlParameter ControlID="ddl_UsuariosFiltro" DefaultValue="%"
                            Name="usuario" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="ddl_SociedadFiltro" DefaultValue=""
                            Name="Sociedad" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
                         
                    </div>
                </div>
            </div>

            <div class="tab-pane" id="roles">
                <div class="box box-solid box-default">
                    <div class="box-body">
                        <div class="row ">
                            <div class="col-md-6">
                                <div class="box box-solid box-default" style="margin-bottom: 0px;">
                                    <div class="box-header with-border">
                                        <h3 class="box-title"><% If Session("Idioma") = "IN" Then %>Search<% Else%>Busqueda<% End If%></h3>
                                    </div>
                                    <div class="row " style="margin: 5px;">
                                         
                                        <div class="col-md-12">
                                            <asp:Label ID="Label2" runat="server" Text="Usuarios Activos" meta:resourcekey="Label2Resource1"></asp:Label>
                                            <asp:DropDownList ID="ddl_UsuariosFiltroTab3" runat="server"
                                                DataSourceID="SDSUsuariosActivosFiltro" DataTextField="Nombre" CssClass="form-control select2" Style="width: 100%"
                                                DataValueField="UserName" meta:resourcekey="ddl_UsuariosFiltroTab3Resource1">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="row " style="margin: 5px;">
                                         
                                        <div class="col-md-12">
                                            <asp:Label ID="Label1" runat="server" Text="Roles " meta:resourcekey="Label1Resource1"></asp:Label>
                                            <asp:DropDownList ID="ddl_RolesFiltro" runat="server"
                                                DataSourceID="SDSRolesFiltro" DataTextField="RoleName" DataValueField="RolId" CssClass="form-control select2" Style="width: 100%" meta:resourcekey="ddl_RolesFiltroResource1">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SDSRolesFiltro" runat="server"
                                                ConnectionString="<%$ ConnectionStrings:ApplicationServices %>" SelectCommand="SELECT
	                                                                                                                          '%' AS RolId,
	                                                                                                                           CASE
		                                                                                                                            WHEN @idioma = 'ES' THEN 'Todos'
		                                                                                                                            ELSE 'All'
	                                                                                                                            END AS RoleName
                                                                                                                                UNION
                                                                                                                                SELECT
	                                                                                                                                RoleName As RoleId,
	                                                                                                                                RoleName
                                                                                                                                FROM Autenticacion.dbo.aspnet_Roles
                                                                                                                                WHERE ApplicationId = @ApplicationId">
                                                <SelectParameters>
                                                    <asp:SessionParameter DefaultValue="ES" Name="Idioma" SessionField="Idioma" />
                                                    <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                                        Name="ApplicationId" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="row " style="margin: 5px;">
                                        <div class="col-md-12">
                                            <asp:Button ID="btn_FiltrarTab3" runat="server" Text="Filtrar" CssClass="button button-rounded button-action pull-right" Width="250px" meta:resourcekey="btn_FiltrarTab3Resource1" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="box box-solid box-default" style="margin-bottom: 0px;">
                                    <div class="box-header with-border">
                                        <h3 class="box-title"><% If Session("Idioma") = "IN" Then %>Add/Remove Rol<% Else%>Agregar/quitar Rol<% End If%></h3>
                                    </div>
                                    <div class="row " style="margin: 5px;">
                                        
                                        <div class="col-md-12">
                                            <asp:Label ID="lbl_UsuariosTab3" runat="server" Text="Usuarios Activos" meta:resourcekey="lbl_UsuariosTab3Resource1"></asp:Label>
                                            <asp:DropDownList ID="ddl_UsuariosActivosTab3" runat="server" CssClass="form-control select2" Style="width: 100%" DataSourceID="SqlDataSource1" DataTextField="Nombre" DataValueField="UserId" meta:resourcekey="ddl_UsuariosActivosTab3Resource1"></asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                                ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
	                                                                                                                a.UserId,
	                                                                                                                IsNull(a.UserName,'') As Nombre
                                                                                                                    FROM Autenticacion.dbo.aspnet_Users As a LEFT JOIN
	                                                                                                                Autenticacion.dbo.aspnet_Membership As b ON a.ApplicationId = b.ApplicationId AND a.UserId = b.UserId
                                                                                                                    WHERE a.ApplicationId = @ApplicationId AND b.IsApproved = '1'">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>" Name="ApplicationId" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="row " style="margin: 5px;">
                                        
                                        <div class="col-md-12">
                                            <asp:Label ID="lbl_Roles" runat="server" Text="Roles" meta:resourcekey="lbl_RolesResource1"></asp:Label>
                                            <asp:DropDownList ID="ddl_Roles" runat="server" DataSourceID="SDSRoles" CssClass="form-control select2" Style="width: 100%" DataTextField="RoleName" DataValueField="RoleId" meta:resourcekey="ddl_RolesResource1"></asp:DropDownList>
                                            <asp:SqlDataSource ID="SDSRoles" runat="server"
                                                ConnectionString="<%$ ConnectionStrings:ApplicationServices %>" SelectCommand="SELECT
	                                                                                                                           RoleId,
	                                                                                                                           RoleName
                                                                                                                               FROM Autenticacion.dbo.aspnet_Roles
                                                                                                                               WHERE ApplicationId = @ApplicationId">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                                        Name="ApplicationId" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="row" style="margin: 5px;">
                                        <div class="col-md-12">
                                            <asp:Button ID="btn_AsignarRol" runat="server" Text="Agregar" CssClass="button button-rounded button-action pull-right" Width="250px" meta:resourcekey="btn_AsignarRolResource1" />
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>

                            
                            <%--cieere row--%>
                        </div>
                    </div>
                    <div class="well">
                        <div class="row">
                            <div class="col-md-12">
                                            <asp:Button ID="btn_QuitarRol" runat="server" Text="Quitar" CssClass="button button-rounded button-action pull-left" Width="250px" meta:resourcekey="btn_QuitarRolResource1" />
                                        </div>
                        </div>
                    <div id="grid3" class="box box-default" style="height: 100%; width: 100%; overflow: auto;">
                        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False"
                            DataSourceID="SDSAsignacionRoles" GridLines="None"
                            AllowPaging="True" CssClass="table table-bordered table-hover table-striped no-padding" PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt"
                            PageSize="7" meta:resourcekey="GridView3Resource1">
                            <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                            <Columns>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="CheckBox_AutorizarTab3" runat="server" meta:resourcekey="CheckBox_AutorizarTab3Resource1" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="UserName" HeaderText="UserName" ReadOnly="True"
                                    SortExpression="UserName" meta:resourcekey="BoundFieldResource7">
                                    <ItemStyle Font-Bold="True" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NombreCompleto" HeaderText="NombreCompleto"
                                    ReadOnly="True" SortExpression="NombreCompleto" meta:resourcekey="BoundFieldResource8" />
                                <asp:BoundField DataField="PuestoTrabajo" HeaderText="PuestoTrabajo"
                                    ReadOnly="True" SortExpression="PuestoTrabajo" meta:resourcekey="BoundFieldResource9" />
                                <asp:BoundField DataField="RoleName" HeaderText="RoleName" ReadOnly="True"
                                    SortExpression="RoleName" meta:resourcekey="BoundFieldResource10">
                                    <ItemStyle Font-Bold="True" />
                                </asp:BoundField>
                            </Columns>
                            <HeaderStyle BackColor="#D2D6DE" />
                 <RowStyle CssClass="Renglon" />
                 <AlternatingRowStyle CssClass="Renglon" />
                            <PagerStyle CssClass="pgr"></PagerStyle>
                        </asp:GridView>
                        <br />
                        <asp:SqlDataSource ID="SDSUsuariosActivosFiltro" runat="server"
                            ConnectionString="<%$ ConnectionStrings:Activos %>" SelectCommand="SELECT
	                                                                                            '%' AS UserName,
	                                                                                            CASE
		                                                                                            WHEN @idioma = 'ES' THEN 'Todos'
		                                                                                            ELSE 'All'
	                                                                                            END AS Nombre
                                                                                                UNION
                                                                                                SELECT
	                                                                                                a.UserName,
	                                                                                                IsNull(a.UserName,'') As Nombre
                                                                                                FROM Autenticacion.dbo.aspnet_Users As a LEFT JOIN
	                                                                                                Autenticacion.dbo.aspnet_Membership As b ON a.ApplicationId = b.ApplicationId AND a.UserId = b.UserId
                                                                                                WHERE a.ApplicationId = @ApplicationId AND b.IsApproved = '1'">
                                <SelectParameters>
                                <asp:SessionParameter DefaultValue="ES" Name="idioma" SessionField="Idioma" />
                                <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                    Name="ApplicationId" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SDSAsignacionRoles" runat="server"
                            ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
                            SelectCommand="SELECT
	                                a.UserName,
	                                isnull(a.NombreCompleto,'') As NombreCompleto,
	                                isnull(a.PuestoTrabajo,'') As PuestoTrabajo,
	                                c.RoleName
                                    FROM Autenticacion.dbo.aspnet_Users As a JOIN
	                                Autenticacion.dbo.aspnet_UsersInRoles As b ON a.UserId = b.UserId JOIN
	                                Autenticacion.dbo.aspnet_Roles As c ON a.ApplicationId = c.ApplicationId AND b.RoleId = c.RoleId
                                    WHERE a.ApplicationId = @ApplicationId AND a.UserName LIKE '%' + @usuario AND C.RoleName LIKE '%' + @rol">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="<%$ appSettings:ApplicationId %>"
                                    Name="ApplicationId" />
                                <asp:ControlParameter ControlID="ddl_UsuariosFiltroTab3" DefaultValue=""
                                    Name="usuario" PropertyName="SelectedValue" />
                                <asp:ControlParameter ControlID="ddl_RolesFiltro" Name="rol"
                                    PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
                    </div>
            </div>
            <asp:HiddenField ID="TabName" runat="server" />
        </div>
    </div>
</asp:Content>
