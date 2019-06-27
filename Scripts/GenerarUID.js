
$(document).ready(function () {
$(".numerico").on("keypress keyup blur", function (event) {
    $(this).val($(this).val().replace(/[^\d].+/, ""));
    if ((event.which < 48 || event.which > 57)) {
        event.preventDefault();
    }
});
var qrcode = new QRCode(document.getElementById("qrcode"), {
    width: 150,
    height: 150
});

makeCode(0);
    //******************** OBTENER NUMEROS **********************

$("#qrcode").hide();
$("#success").hide();
$("#error").hide();
$("#btn_print_pdf").hide();
var res;
var ultimo_uid;
fn_ultimo_uid();
$(".logo").attr("src", "../estilos/fm_logo.png");


$("#btn_generar").click(function () {
//************** identifica el último uid generado ******************
    $("#" + this.id).html("<i class='fa fa-refresh fa-spin'></i> Generando...");
    var cantidad = $('#MainContent_folios').val();
    
    if (parseInt(cantidad) <= 0) { alerta('Error: La cantidad de Folios debe ser Mayor que 0'); $('#MainContent_folios').val(''); $("#" + this.id).html("Generar QR"); }

    $("#qrcode").hide();
    $("#success").hide();
    $("#error").hide();
    fn_ultimo_uid();
    
    var ultimo = $('#MainContent_hf_ultimo').val();
    
    var fin = (parseInt(ultimo) + parseInt(cantidad))-1;
    var i;

    for (i = ultimo; i <= fin; i++) {
        
          makeCode(i);
          var imagen = $("#qrcode").find('img');
          var src = $("#qrcode img").attr('src');
          
          fn_inserta_uid(i,src,ultimo,fin);
          
    }
    $("#" + this.id).html("Generar QR");
    
});



function makeCode(valor) { qrcode.makeCode(valor.toString()); } 

function fn_ultimo_uid() {
    $.ajax({
        type: "POST",
        url: "GenerarUID.aspx/UltimoUID",
        data:"{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $("#MainContent_hf_ultimo").val(response.d);
        },
        failure: function (response) {
            alert(response.d);

        }
    });

}

function fn_inserta_uid(valor,imagen,ultimo,fin) {
    $.ajax({
        type: "POST",
        url: "GenerarUID.aspx/GeneraUID",
        data: "{valor: '" + valor + "', imagen: '" + imagen + "', inicio: '" + ultimo + "', fin: '" + fin + "' }",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            if (response.d == "OK") {
                $("#success").show();
                $("#qrcode").show();
                $("#MainContent_lbl_success").html('<b> UID´s del ' + ultimo + ' al ' + fin + ' Generados Correctamente </b>');
                $("#success").show();
                $('#MainContent_folios').val('');
                fn_ultimo_uid();
                $("#btn_print_pdf").show();
            }
            else {
                $("#qrcode").hide();
                $("#MainContent_lbl_error").html('<b> ¡ Error ! </b> <br>' + response.d);
                $("#error").show();
                $('#MainContent_folios').val('');
                fn_ultimo_uid();

            }

            //  return response.d.responseText;
        },
        failure: function (response) {
            alert(response.d);

        }
    });

}

 



}); // ready

/*

$(".float").on("keypress keyup blur", function (event) {
    $(this).val($(this).val().replace(/[^0-9\.]/g, ''));
    if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
        event.preventDefault();
    }
});

$('.desc_material').attr("placeholder", "p.e. DIESEL");


$('.date').mask('00/00/0000', { placeholder: "mm/dd/yyyy" });
$('.phone').mask('(000) 000-0000', { placeholder: "(000) 000-0000" });
$('.zip_code').mask('00000', { placeholder: "00000" });
$('.material').mask('000000', { placeholder: "000000" });

$('.email').attr("placeholder", "some@domain.com");
$(".email").keyup(function () {
    this.value = this.value.toLowerCase();
});

-------------------------
 //var elText = document.getElementById("MainContent_texto_qr");

    //if (!elText.value) {
    //    alert("Input a text");
    //    elText.focus();
    //    return;
    //}
-------------------------
//makeCode();
//$("#text").on("blur", function () {
//    makeCode();
//}).on("keydown", function (e) {
//    if (e.keyCode == 13) {
//        makeCode();
//    }
//});



--------------------
AJAX


$.ajax({
        type: "POST",
        url: "GenerarUID.aspx/Nuevo",
        data: "{valor: '" + i + "', imagen: '" + src + "', inicio: '" + inicio + "', fin: '" + fin + "' }",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            if (response.d == "OK") {
                $("#qrcode").show();
                $("#MainContent_lbl_success").html('<b> UID´s del ' + inicio + ' al ' + fin + ' Generados Correctamente </b>');
                $("#success").show();

            }
            else {
                $("#qrcode").hide();
                $("#MainContent_lbl_error").html('<b> ¡ Error ! </b> <br>' + response.d);
                $("#error").show();

            }

            //  return response.d.responseText;
        },
        failure: function (response) {
            alert(response.d);

        }
    });


*/