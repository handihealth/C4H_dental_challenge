$(document).ready(function() {
	function cariesRAG(){
		var caries_red = ["#caries_clinical_lesions",
                          "#caries_patient_symptoms"];
		var caries_amber = ["#caries_patient_diet",
                            "#caries_patient_plaque_control",
                            "#caries_patient_sibling"];
        for(i=0; i<caries_red.length; i++){
            var item = $(caries_red[i])
            if(item.is(':checked')) {
                return 'red';
            }
        }
        for(i=0; i<caries_amber.length; i++){
            var item = $(caries_amber[i])
            if(item.is(':checked')) {
                return 'amber';
            }
		}
        return 'green';
	}

	function toothSurfaceLossRAG (parameters) {
        if($('#surface_loss_excessive').is(':checked')){
            return 'red';
        }
        if($('#surface_loss_patient_symptoms').is(':checked')) {
            return 'red';
        }
        if($('#surface_loss_moderate').is(':checked')) {
            return 'amber';
        }

        var amber = [
            '#surface_loss_diet',
            '#surface_loss_brushing',
            '#surface_loss_para',
            '#surface_loss_reflux'
        ]
        for(i=0; i<amber.length; i++){
            var item = $(amber[i])
            if(item.is(':checked')) {
                return 'amber';
            }
		}
        return 'green';
	}

	function periodontalRAG (parameters) {
        if($('#periodontal_severe').is(':checked')){
            return 'red';
        }
        if($('#periodontal_patient_symptoms').is(':checked')) {
            return 'red';
        }
        if($('#periodontal_moderate').is(':checked')) {
            return 'amber';
        }

        var amber = [
            '#periodontal_patient_plaque_control',
            '#periodontal_patient_smoking',
            '#periodontal_patient_poor_diabetes'
        ]
        for(i=0; i<amber.length; i++){
            var item = $(amber[i])
            if(item.is(':checked')) {
                return 'amber';
            }
		}
        return 'green';
	}

	function softTissueRAG (parameters) {
        if($('#soft_tissue_referral').is(':checked')){
            return 'red';
        }
        if($('#soft_tissue_patient_symptoms').is(':checked')) {
            return 'red';
        }

        if ($('#soft_tissue_patient_site').is(':checked')) {
            return 'red';
        }

        if($('#soft_tissue_lesion').is(':checked')) {
            return 'amber';
        }

        var amber = [
            '#soft_tissue_patient_tobacco_use',
            '#soft_tissue_patient_alchohol'
        ];
        for(i=0; i<amber.length; i++){
            var item = $(amber[i])
            if(item.is(':checked')) {
                return 'amber';
            }
		}
        return 'green';
	}

    function setResult(domElement, message) {
        var label = 'label';
        var classname = 'bg-success';
        if(message === 'red') {
            classname = 'bg-danger';
            label += ' label-danger';
        } else if (message === 'amber') {
            classname = 'bg-warning';
            label += ' label-warning';
        } else {
            label += ' label-success';
        }
        console.log(domElement);
        $(domElement + '_result').text(message).attr('class', label);
    }

	$('#caries_clinical_lesions').click(function(e){
        setResult('#caries', cariesRAG());
    });

    $('#caries_no_lesions').click(function(e){
        setResult('#caries', cariesRAG());
    });

    $('#caries_patient_symptoms').click(function(e){
        setResult('#caries', cariesRAG());
    });

    $('#caries_patient_diet').click(function(e){
        setResult('#caries', cariesRAG());
    });

    $('#caries_patient_plaque_control').click(function(e){
        setResult('#caries', cariesRAG());
    });

    $('#caries_patient_sibling').click(function(e){
        setResult('#caries', cariesRAG());
    });

    $('#surface_loss_excessive').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

    $('#surface_loss_patient_symptoms').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

    $('#surface_loss_moderate').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

    $('#surface_loss_commensurate').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

    $('#surface_loss_diet').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

    $('#surface_loss_para').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

    $('#surface_loss_reflux').click(function(e){
        setResult('#surface_loss', toothSurfaceLossRAG());
    });

	$('#periodontal_severe').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

    $('#periodontal_patient_symptoms').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

    $('#periodontal_moderate').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

    $('#periodontal_healthy').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

    $('#periodontal_patient_plaque_control').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

    $('#periodontal_patient_smoking').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

    $('#periodontal_patient_poor_diabetes').click(function(e){
        setResult('#periodontal', periodontalRAG());
    });

	$('#soft_tissue_referral').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

    $('#soft_tissue_patient_symptoms').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

    $('#soft_tissue_patient_site').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

    $('#soft_tissue_patient_tobacco_use').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

    $('#soft_tissue_patient_alchohol').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

    $('#soft_tissue_lesion').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

    $('#soft_tissue_healthy').click(function(e){
        setResult('#cancer', softTissueRAG());
    });

});
