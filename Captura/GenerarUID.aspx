<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="GenerarUID.aspx.vb" Inherits="Captura_GenerarUID" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">

    <script src="../plugins/qrcode/qrcode.js"></script>
    <script src="../Scripts/GenerarUID.js"></script>
    <div class="box box-solid box-default">
        <div class="box-header with-border">
            <h1 class="box-title"><%if Session("idioma") = "IN" Then%>Generate Unique ID<%Else  %>Generar Unique ID<%End If %><small><br />
                <%--  <%if Session("idioma") = "IN" Then%>Please type a number of UID´s to generate<%Else  %>Por favor Ingrese la cantidad de UID´s a Generar<%End If %>.<br />--%>

            </small>
            </h1>
        </div>
        <div class="box-body">
            <div class="well">
                <div class="row">
                    <div class="col-md-3">
                        <b>
                            <asp:Label ID="lbl_folios" runat="server" Text="Capture La cantidad de UID´s a Generar" AssociatedControlID="folios"></asp:Label></b>
                        <asp:TextBox ID="folios" CssClass="form-control numerico" runat="server"></asp:TextBox>
                        <asp:HiddenField ID="hf_ultimo" runat="server" />
                                           
                    </div>

                    <%--<div class="col-md-3">
                       <b> <asp:Label ID="lbl_fin" runat="server" Text="Capture Folio Final" AssociatedControlID="uid_fin"></asp:Label></b>
                        <asp:TextBox ID="uid_fin" CssClass="form-control numerico" runat="server"></asp:TextBox>
                    </div>--%>

                    <div class="col-md-3">
                        <%--<input id="texto_qr" type="text" runat="server" value="" style="width:80%" /><br />--%>
                        <div id="qrcode" style="width: 100px; height: 100px; margin-top: 15px;"></div>
                    </div>
                    <div class="col-md-4">
                        <div id="success" class="alert alert-success" role="alert">
                            <asp:Label ID="lbl_success" runat="server" Text="Label"></asp:Label>
                        </div>
                        <div id="error" class="alert alert-danger" role="alert">
                            <asp:Label ID="lbl_error" runat="server" Text="Label"></asp:Label>

                        </div>
                        <%--<button type="button" id="btn_print_pdf" runat="server" class="button button-rounded button-action pull-right" style="width: 100%;"><i class="far fa-file-pdf"></i>Imprimir PDF</button>--%>
                       <asp:Button ID="btn_pdf" runat="server" Text="Imprimir PDF" CssClass="button button-rounded button-action pull-right" Width="250px" />
                         </div>

                </div>

                <div class="row">
                    <div class="col-md-3">
                        <button type="button" id="btn_generar" class="button button-rounded button-action pull-right" style="width: 100%;">Generar UID</button>
                        
                    </div>
                </div>

                
 <%--<table width="100%" border="1">

  <tr>
    <td rowspan="2" style="text-align:center;vertical-align:middle">qr</td>
    <td style="text-align:center;vertical-align:top"><img src="../estilos/fm_logo.png" style="width:40%;height:auto;" /></td>
    
      <td rowspan="2" style="text-align:center;vertical-align:middle">qr</td>
    <td style="text-align:center;vertical-align:top"><img src="../estilos/fm_logo.png" style="width:40%;height:auto;" /></td>
    <td rowspan="2" style="text-align:center;vertical-align:middle">qr</td>
    <td style="text-align:center;vertical-align:top"><img src="../estilos/fm_logo.png" style="width:40%;height:auto;" /></td>
    <td rowspan="2" style="text-align:center;vertical-align:middle">qr</td>
    <td style="text-align:center;vertical-align:top"><img src="../estilos/fm_logo.png" style="width:40%;height:auto;" /></td>
  </tr>
  <tr>
    <td style="text-align:center;vertical-align:top">texto 1</td>
    <td style="text-align:center;vertical-align:top">texto 1</td>
    <td style="text-align:center;vertical-align:top">texto 1</td>
    <td style="text-align:center;vertical-align:top">texto 1</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:center;vertical-align:top">texto 2</td>
    <td colspan="2" style="text-align:center;vertical-align:top">texto 2</td>
    <td colspan="2" style="text-align:center;vertical-align:top">texto 2</td>
    <td colspan="2" style="text-align:center;vertical-align:top">texto 2</td>
  </tr>
  
</table>
<br />
                <br />

<table width = '100%' border='1'>
<tr>
<td rowspan = "2" style="text-align:center;vertical-align:middle">qr</td>
<td style = "text-align:center;vertical-align:top" ><img src="../estilos/fm_logo.png" style="width:40%;height:auto;"/></td>
<td rowspan = '2' style='text-align:center;vertical-align:middle'>qr</td>
<td style = 'text-align:center;vertical-align:top' ><img src='../estilos/fm_logo.png' style='width:40%;height:auto;'/></td>
<td rowspan = '2' style='text-align:center;vertical-align:middle'>qr</td>
<td style = 'text-align:center;vertical-align:top' ><img src='../estilos/fm_logo.png' style='width:40%;height:auto;'/></td>
<td rowspan = '2' style='text-align:center;vertical-align:middle'>qr</td>
<td style = 'text-align:center;vertical-align:top' ><img src='../estilos/fm_logo.png' style='width:40%;height:auto;'/></td>
</tr>

<tr>
<td style = 'text-align:center;vertical-align:top' > texto 1</td>
<td style = 'text-align:center;vertical-align:top' > texto 1</td>
<td style = 'text-align:center;vertical-align:top' > texto 1</td>
<td style = 'text-align:center;vertical-align:top' > texto 1</td>
</tr>

<tr>
<td colspan = 2' style='text-align:center;vertical-align:top'>texto 2</td>
<td colspan = 2' style='text-align:center;vertical-align:top'>texto 2</td>
<td colspan = 2' style='text-align:center;vertical-align:top'>texto 2</td>
<td colspan = 2' style='text-align:center;vertical-align:top'>texto 2</td>
</tr>
</table>--%>




                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" ShowHeader="False" GridLines="None" >
                    <Columns>
                        <asp:TemplateField HeaderText="Columna1">
                              <ItemTemplate>
                                <div class="row">
                                <div class="col-md-5">
                                <asp:Image ID="Image13" runat="server" style="width:100%;height:auto;" ImageUrl='<%# Bind("QR1") %>' />
                                </div>

                                <div class="col-md-6 text-center">
                                    <img src="<%# GetUrl("{0}") %>" style="width:100%;height:auto;" /><br /><b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Col1") %>'></asp:Label></b>
                                </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Col1 a" ControlStyle-Width="30px">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Columna2">
                            <ItemTemplate>
                                <div class="row">
                                <div class="col-md-5">
                                <asp:Image ID="Image13" runat="server" style="width:100%;height:auto;" ImageUrl='<%# Bind("QR2") %>' />
                                </div>

                                <div class="col-md-6 text-center">
                                    <img src="<%# GetUrl("{0}") %>" style="width:100%;height:auto;" /><br /><b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Col2") %>'></asp:Label></b>
                                </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Col 2a" ControlStyle-Width="30px">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Columna 3">
                           <ItemTemplate>
                               <div class="row">
                                <div class="col-md-5">
                                <asp:Image ID="Image13" runat="server" style="width:100%;height:auto;" ImageUrl='<%# Bind("QR3") %>' />
                                </div>

                                <div class="col-md-6 text-center">
                                    <img src="<%# GetUrl("{0}") %>" style="width:100%;height:auto;" /><br /><b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Col3") %>'></asp:Label></b>
                                </div>
                                </div>
                               
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Col 3a" ControlStyle-Width="30px">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox3" runat="server"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Columna 4">
                            
                            <ItemTemplate>
                                <div class="row">
                                <div class="col-md-5">
                                <asp:Image ID="Image13" runat="server" style="width:100%;height:auto;" ImageUrl='<%# Bind("QR4") %>' />
                                </div>

                                <div class="col-md-6 text-center">
                                    <img src="<%# GetUrl("{0}")%>" style="width:100%;height:auto;" /><br /><b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Col4") %>'></asp:Label></b>
                                </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                       <%-- <asp:TemplateField HeaderText="Columna 5">
                            <ItemTemplate>
                                <div class="row">
                                <div class="col-md-5">
                                <asp:Image ID="Image13" runat="server" style="width:100%;height:auto;" ImageUrl='<%# Bind("QR5") %>' />
                                </div>

                                <div class="col-md-6 text-center">
                                    <img src="<%# GetUrl("{0}") %>" style="width:100%;height:auto;" /><br /><b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Col5") %>'></asp:Label></b>
                                </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Columna 6">
                           <ItemTemplate>
                               <div class="row">
                                <div class="col-md-5">
                                <asp:Image ID="Image13" runat="server" style="width:100%;height:auto;" ImageUrl='<%# Bind("QR6") %>' />
                                </div>

                                <div class="col-md-6 text-center">
                                    <img src="<%# GetUrl("{0}") %>" style="width:100%;height:auto;" /><br /><b>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Col6") %>'></asp:Label></b>
                                </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Col4a" ControlStyle-Width="30px">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox4" runat="server"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                 

           

            </div>
        </div>
    </div>
</asp:Content>


