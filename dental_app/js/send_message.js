var teethDecay;
var teethAbscess;
var ctx_composer_name;
var ctx_healthcare_facility;

var teeth_with_decay;

$(document).ready(function () {


    $("#btnSend").click(function () {
        alert("Thank you. Your message has sent!");

        teethDecay = $('#num_radio_teeth_decay').val();
        teethAbscess = $('#num_teeth_abscess').val();

        ctx_composer_name = $('#ctx_composer_name').val();
        ctx_healthcare_facility = $('#ctx_healthcare_facility').val();

        teeth_with_decay = $('#num_teeth_decay').val();
        // console.log('the teeth value is :' + teethAbscess + teethDecay);

        $.getJSON("src/AoMRC Community Dental Assessment \(STRUCTURED\).json", function (data) {
            js_traverse(data);
        });

    });

});


var selectedItem;
$('.myDropdown li a').click(function () {
    selectedItem = $(this).text();
    $('#patient_gender').text(selectedItem);
});


var flag = 0;
var flag1 = 0;

function js_traverse(obj) {
    var type = typeof obj;
    if (type == "object") {
        for (var key in obj) {
            // Dentist info
            if (key == "ctx/composer_name") {
                obj[key] = ctx_composer_name;
                console.log("ctx_composer_name : " + obj[key]);
                //subobj.value = ctx_composer_name;
            }
            if (key == "teeth_with_decay") {
                obj[key] = teeth_with_decay;
                console.log("teeth_with_decay : " + obj[key]);
            }
            if (key == "ctx/health_care_facility|name") {
                obj[key] = ctx_healthcare_facility;
                console.log("health_care_facility : " + obj[key]);

            }

            // Decayed teeth numeric value
            if (key == "decayed_teeth") {
                flag++;
                if (flag == 2) {
                    obj.decayed_teeth = teethDecay;
                    console.log(obj.decayed_teeth);
                }
            }
            // Decayed teeth numeric value
            if (key == "teeth_with_associated_abscesses") {
                flag1++;
                if (flag1 == 2) {
                    obj.teeth_with_associated_abscesses = teethAbscess;
                    console.log(obj.teeth_with_associated_abscesses);
                }
            }

            js_traverse(obj[key]);
        }
    }
};

