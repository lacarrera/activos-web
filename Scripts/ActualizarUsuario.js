$(document).ready(function () {
    
    $("#buscar").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $(".Renglon").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });

    $(".Editar_grid").click(function () {
     $("#" + this.id + " i:first").removeClass("fa-pencil con-4x").addClass("fa-refresh fa-spin");
 
    });
    $("#MainContent_btnExport").click(function () {
         setTimeout(function () {
            $(".preloader-wrapper").fadeOut();
            $("body").removeClass("preloader-site");
           // alertify.ok('Desc');
        }, 5000);
    });
    
   
});
 