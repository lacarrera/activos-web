<%@ Page Title="Home Page" Language="VB" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default"  UICulture="auto" Culture="es-MX"   MasterPageFile="~/Site.Master"%>
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
<%--Aqui ponemos el contenido--%>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
       <script src='https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js'></script>
   <style>
    .daterangepicker tr:hover {
      background-color: rgba(0,0,0,.2) !important;
    }

    .daterangepicker td {
      border-radius: 0 !important;
    }

      .daterangepicker td.off {
        background-color: transparent;
      }

    .daterangepicker th {
      background-color: white;
      cursor:default;
    }

  </style>
 <script>

    //******************************************** rango de fechas inicialización
    function dateRangeWeek() {
      switch( <%= Session("Sociedad")%>) {
        case 1000:
          iniciaSemana=3;

          break;
        case 1010:
          iniciaSemana=0;

          break;
        case 1050:
          iniciaSemana=0;

          break;
        default:
          iniciaSemana = 1;
          
      }

        <% If Session("Idioma") = "IN" Then %>
              $('.dateRangeWeek').daterangepicker({
                autoUpdateInput: false,
                showWeekNumbers: true,
                singleDatePicker: true,
                showWeekNumbers: true,
                showCustomRangeLabel: false,
                alwaysShowCalendars: true,
                "locale": {
                  "format": "MM/DD/YYYY",
                  "separator": " - ",
                  "applyLabel": "Apply",
                  "cancelLabel": "Clean",
                  "fromLabel": "From",
                  "toLabel": "To",
                  "customRangeLabel": "Custom",
                  "daysOfWeek": [
                      
                      "Su",
                      "Mo",
                      "Tu",
                      "We",
                      "Th",
                      "Fr",
                       "Sa",
                  ],
                  "monthNames": [
                      "January",
                      "February",
                      "March",
                      "April",
                      "May",
                      "June",
                      "July",
                      "August",
                      "September",
                      "October",
                      "November",
                      "December"
                  ],
                  "firstDay": 1
                },
                "applyClass": "btn-default",
                "opens": "right",
                "alwaysShowCalendars": true,
                ranges: {
                  'Today': [moment(), moment()],
                  'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                  'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                  'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                  'This Month': [moment().startOf('month'), moment().endOf('month')],
                  'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                }
              });
              $('.dateRangeWeek').on('apply.daterangepicker', function (ev, picker) {

                var firstDate =moment( moment(picker.startDate, "MM/DD/YYYY").startOf('isoWeek')).add(iniciaSemana, 'day').format("MM/DD/YYYY");
                var lastDate = moment(moment(firstDate, "MM/DD/YYYY").day(iniciaSemana)).add(7, 'day').format("MM/DD/YYYY");
  
                $(this).val(firstDate + ' - ' + lastDate);
                 
              });

           <% else %>
              $('.dateRangeWeek').daterangepicker({
                autoUpdateInput: false,
                showWeekNumbers: true,
                singleDatePicker: true,
                showWeekNumbers: true,
                showCustomRangeLabel: false,
                alwaysShowCalendars: true,
                "locale": {
                  "format": "DD/MM/YYYY",
                  "separator": " - ",
                  "applyLabel": "Aplicar",
                  "cancelLabel": "Limpiar",
                  "fromLabel": "From",
                  "toLabel": "To",
                  "customRangeLabel": "Selección",
                  "daysOfWeek": [
                     
                      "Do",
                      "Lu",
                       "Ma",
                        "Mi",
                      "Ju",
                      "Vi",  
                      "Sa",
                  ],
                  "monthNames": [
                      "Enero",
                      "Febrero",
                      "Marzo",
                      "Abril",
                      "Mayo",
                      "Junio",
                      "Julio",
                      "Agosto",
                      "Septiembre",
                      "Octubre",
                      "Noviembre",
                      "Diciembre"
                  ],
                  "firstDay": 1
                },
                "applyClass": "btn-default",
                "opens": "right",
                "alwaysShowCalendars": true
               
              });

              $('.dateRangeWeek').on('apply.daterangepicker', function (ev, picker) {
                var firstDate =moment( moment(picker.startDate, "DD/MM/YYYY").startOf('isoWeek')).add(iniciaSemana, 'day').format("DD/MM/YYYY");
                var lastDate = moment(moment(firstDate, "DD/MM/YYYY").day(iniciaSemana)).add(7, 'day').format("DD/MM/YYYY");
                $(this).val(firstDate + ' - ' + lastDate);

              });
            <% End If%>
              $('.dateRangeWeek').on('cancel.daterangepicker', function (ev, picker) {
                $(this).val('');
              });
            

              }

   //**************************************** carga los datos desde BD *******************************************
    //***************************************** carga datos de AVANCE ************************************************
   function cargaDatos(){
            fechaBusqueda=$("#rangoFecha").val().split(" - ");
            $.ajax({
              url: '<%= ResolveUrl("default.aspx/avanceAproximado") %>',
              data: "{fechaInicial:'" +fechaBusqueda[0] + "', fechaFinal:'" +fechaBusqueda[1] + "'}",
              method: "POST",
              contentType: "application/json; charset=utf-8",
              dataType: "json",
              success: function(data) {
                if (data.d.length>0){
                var fecha = [];
                var avance = [];
                var avanceMineral = [];
                var avanceTepetate = [];

                for(var i in data.d) {
                    fecha.push( data.d[i].fecha_reporte);
                    avance.push(data.d[i].avance);
                    if (data.d[i].material=='MINERAL')
                      avanceMineral.push(data.d[i].avance);
                  else 
                      avanceTepetate.push(data.d[i].avance);

                }
               // avanceMineral = words.filter(word => word.length > 6);
                var uniqueFechas = Array.from(new Set(fecha))
                var chartdata = {
                  labels: uniqueFechas,
                  datasets : [
                      {
                        label: '<asp:Literal runat="server" Text="<%$ resources:globalResources,metersTepetate%>" />',
                        backgroundColor: 'rgba(255, 193, 7, 0.6)',
                        hoverBackgroundColor: 'rgba(255, 193, 7, 1)',
                        borderWidth: 0,
                        fontStyle: 'normal',
                        data: avanceTepetate
                      },     {
                        label: '<asp:Literal runat="server" Text="<%$ resources:globalResources, metersMineral%>" />',
                        backgroundColor: 'rgba(255, 255, 141, 0.6)',
                        hoverBackgroundColor: 'rgba(255, 255, 141, 1)',
                        borderWidth: 0,
                        fontStyle: 'normal',
                        data: avanceMineral
                      }
                  ]
                };
                $('#chart').closest('.dashBoardItem').show();
                barGraph.data= chartdata
                barGraph.update();
                }
                else{
                  $('#chart').closest('.dashBoardItem').hide();
                }
              },
              error: function(data) {
                console.log(data);
              }
            });
   }
     //******************************************* Carga Datos de Toneladas Tumbe**********************************************
   function cargaDatosToneladasTumbe(){
            fechaBusqueda=$("#rangoFecha").val().split(" - ");
            $.ajax({
              url: '<%= ResolveUrl("default.aspx/cargaDatosToneladasTumbe") %>',
              data: "{fechaInicial:'" +fechaBusqueda[0] + "', fechaFinal:'" +fechaBusqueda[1] + "'}",
              method: "POST",
              contentType: "application/json; charset=utf-8",
              dataType: "json",
              success: function(data) {
                if (data.d.length>0){
                  var fecha = [];
                  var toneladas = [];
                  var toneladasMineral = [];
                  var toneladasTepetate = [];

                  for(var i in data.d) {
                    fecha.push( data.d[i].fecha_reporte);
                    toneladas.push(data.d[i].toneladas);
                    if (data.d[i].material=='MINERAL')
                      toneladasMineral.push(data.d[i].toneladas);
                    else 
                      toneladasTepetate.push(data.d[i].toneladas);

                  }
                  // avanceMineral = words.filter(word => word.length > 6);
                  var uniqueFechas = Array.from(new Set(fecha))
                  var chartdata = {
                    labels: uniqueFechas,
                    datasets : [
                        {
                          label: '<asp:Literal runat="server" Text="<%$ resources:globalResources, tonsTepetate%>" />',
                          backgroundColor: 'rgba(255, 193, 7, 0.6)',
                          hoverBackgroundColor: 'rgba(255, 193, 7, 1)',
                          borderWidth: 0,
                          fontStyle: 'normal',
                          data: toneladasTepetate
                        },     {
                          label: '<asp:Literal runat="server" Text="<%$ resources:globalResources, tonsMineral%>" />',
                          backgroundColor: 'rgba(255, 255, 141, 0.6)',
                          hoverBackgroundColor: 'rgba(255, 255, 141, 1)',
                          borderWidth: 0,
                          fontStyle: 'normal',
                          data: toneladasMineral
                        }
                    ]
                  };
                  $('#chart2').closest('.dashBoardItem').show();
                  barGraph2.data= chartdata
                  barGraph2.update();
                }
                else{
                  $('#chart2').closest('.dashBoardItem').hide();
                }
              },
              error: function(data) {
                console.log(data);
              }
            });
   }
   
  
   
   //************* funcion que crea el intervalo que muestra el mensaje ****************************
   function cerrarMensaje() {
     $('#mensaje').css('right','-100%')
     clearInterval(tiempoMensaje);
   }
   let tiempoMensaje = setInterval(cerrarMensaje, 10000);
   //***************************************************** READY **************************************************
         $(document).ready(function () {
           $("#fondo").show();
           $("#fondoBlancoLogo").show();
           $('#mensaje').css('right','0%');
           $('#cerrarMensaje').on('click', () => $('#mensaje').css('right','-100%'));
           dateRangeWeek();
           //********************* Se inicializa el calendario en la semana actual y se procede a argar los datos de las diferentes graficas****************
           if  ( $("#dashboard").is(":visible")){
             loadAllGraph();
           }

           //************* Oculta mensaje o lo muestra segun si el cursor esta sobre el mensaje ****************************
           $("#mensaje").mouseenter(function () {
             clearInterval(tiempoMensaje);
             console.log("entra");
           });
           $("#mensaje").mouseleave(function () {
             tiempoMensaje = setInterval(cerrarMensaje, 10000); 
             console.log("sale");
           });

         });
</script>
<%--  ***************************************** FILTROS ***************************************--%>
  <div id="dashboard" style="display:none">
  <div class="row">
    <div class="col-md-6">
      <div class="box box-solid box-default">

        <div class="box-body ">
          <div class="row">
            <div class="col-md-6">
              <input ID="rangoFecha"  name="dateRange" placeholder='<asp:Literal runat="server" Text="<%$ resources:globalResources, semana%>" />' class="form-control dateRangeWeek" />
            </div>
             <div class="col-md-6">
               <button type="button" onclick='loadAllGraph();' class="btn btn-default btn-block"><i class="fa fa-bar-chart"></i><asp:Literal runat="server" Text="<%$ resources:globalResources, graficar %>" /></button>
               </div>
          </div>
        </div>
        
      </div>
    </div>
     
  </div>


    <seccion class="contenedorDashBoard">
      <%--  ****************  KPIS  *******************************************--%>
      <div class="dashBoardItem">
                     <div class="small-box bg-gray-active">
            <div class="inner">
              <h3 id="totalDisparos"></h3>

              <p><asp:Literal runat="server" Text="<%$ resources:globalResources, totalDisparos %>" /></p>
            </div>
            <div class="icon">
              <i class="fa fa-info-circle"></i>
            </div>
            <a href="<%= ResolveClientUrl("~/Consulta/ConsultaPierna.aspx")%>" class="small-box-footer"><asp:Literal runat="server" Text="<%$ resources:globalResources, masInfo %>" /> <i class="fa fa-arrow-circle-right"></i></a>
          </div>
          </div>
      <div class="dashBoardItem">
          <!-- small box -->
          <div class="small-box bg-gray-active">
            <div class="inner">
              <h3 id="horasPerdidas"></h3>

              <p><asp:Literal runat="server" Text="<%$ resources:globalResources, horasMensaje %>" /></p>
            </div>
            <div class="icon">
              <i class="fa fa-history"></i>
            </div>
            <a href="<%= ResolveClientUrl("~/Reportes/ReportesGenerales/ReporteAvisos.aspx")%>" class="small-box-footer"><asp:Literal runat="server" Text="<%$ resources:globalResources, masInfo %>" /> <i class="fa fa-arrow-circle-right"></i></a>
          </div>
        </div>
      <%--  ****************  canvas para grafica 1 *******************************************--%>
      <div class="dashBoardItem">
      <div class="box box-solid box-default">
        <div class="box-header with-border">

          <h3 class="box-title">
            <asp:Label ID="lbl_titulo" runat="server" Text="<%$ resources:globalResources, avanceMts %>"></asp:Label>

          </h3>

        </div>
        <div class="box-body ">
          <div>
            <canvas id="chart"></canvas>
          </div>

        </div>
        
      </div>
    </div>
      <%--  ****************  canvas para grafica 2 *******************************************--%>
      <div class="dashBoardItem">
      <div class="box box-solid box-default">
        <div class="box-header with-border">
          <h3 class="box-title">
            <asp:Label ID="Label1" runat="server" Text="<%$ resources:globalResources, toneladasTumbe %>"></asp:Label>

          </h3>

        </div>
        <div class="box-body ">
          <div>
            <canvas id="chart2"></canvas>
          </div>

        </div>

      </div>
    </div>
      <%--  ****************  canvas para grafica 3 *******************************************--%>
      <div class="dashBoardItem">
      <div class="box box-solid box-default">
        <div class="box-header with-border">

          <h3 class="box-title">
            <asp:Label ID="Label2" runat="server" Text="<%$ resources:globalResources, disparos %>"></asp:Label>

          </h3>

        </div>
        <div class="box-body ">
          <div class="row">
            <canvas id="disparos"></canvas>
          </div>
 
        </div>
        
      </div>
    </div>
          <%--  ****************  canvas para grafica 4 *******************************************--%>
      <div class="dashBoardItem">
      <div class="box box-solid box-default">
        <div class="box-header with-border">

          <h3 class="box-title">
            <asp:Label ID="Label3" runat="server" Text="<%$ resources:globalResources, incumplimientos %>"></asp:Label>

          </h3>

        </div>
        <div class="box-body ">
          <div class="row">
             
            <canvas id="incumplimientos"></canvas>
               </div>
            

          </div>

        </div>
        
      </div>

  </seccion>



  </div>

<%--  ****************  Mensaje *******************************************--%>
    <div id="mensaje" class="callout callout-info" >
    <div id="cerrarMensaje" style="position:absolute; right:5%; cursor:pointer; "><i class="fa fa-times"></i></div>
      <h4><asp:Literal runat="server" Text="<%$ resources:globalResources, tituloMensaje %>" /></h4>

    <p>
      <asp:Literal runat="server" Text="<%$ resources:globalResources, descripcionMensaje %>" />
    </p>
    <a href='<%= ResolveClientUrl("~/dist/img/DiagramaProcesoBitaMina.pdf")%>' target="_blank" class="btn  btn-social btn-dropbox" style="position: relative; bottom: 90%; right: 0%; text-decoration: none;">
      <i class="fa fa-download"></i><asp:Literal runat="server" Text="<%$ resources:globalResources, botonMensaje %>" />
    </a>
  </div>
    
<%--**************************************************************************************--%>
  <script>
    var ctx = $("#chart");

    var barGraph = new Chart(ctx, {
      type: 'bar',
      options: {
        legend: {
          display: true,
          fontStyle: 'normal',
          labels: {
        // This more specific font property overrides the global property
            fontStyle: 'lighter'
      }
                      
        },
        scales: {
          xAxes: [{
            ticks: {
              autoSkip: false,
              maxRotation: 45,
              minRotation: 45
            }
          }]
        },

      }
    });
    //********************************** Grafica 2 ***************************************

    var barGraph2 = new Chart($("#chart2"), {
      type: 'horizontalBar',
      options: {
        legend: {
          display: true,
          fontStyle: 'normal',
          labels: {
            // This more specific font property overrides the global property
            fontStyle: 'lighter'
          }
                      
        },
        scales: {
          xAxes: [{
            ticks: {
              autoSkip: false,
              maxRotation: 45,
              minRotation: 45
            }
          }]
        },

      }
    });
    //******************************** Grafica de Dona ************************************

    var dona = new Chart($("#disparos"), {
      type: 'doughnut',
     
      options: {
        legend: {
          display: true,
          fontStyle: 'normal',
          labels: {
            // This more specific font property overrides the global property
            fontStyle: 'lighter'
          }
                      
        }

      }
    });
    //******************************** Grafica de Dona ************************************

    var incumplimientos = new Chart($("#incumplimientos"), {
      type: 'doughnut',
     
      options: {
        legend: {
          display: true,
          fontStyle: 'normal',
          labels: {
            // This more specific font property overrides the global property
            fontStyle: 'lighter'
          },
          position: 'right'
                      
        },
        title: {
          display: false,
          text: 'Incumplimientos semanales'
        }

      }
    });
   
    //************************************************************************************
  </script>
</asp:Content>
