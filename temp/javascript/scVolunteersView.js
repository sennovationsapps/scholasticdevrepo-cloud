$('#cancelVolunteer').click(function(){
	  $('#closeVolunteer').click();
});

function submitVolunteerForm() {
    $.ajax({
        url:  jQuery('#volunteerForm').attr('action'),
        type: jQuery('#volunteerForm').attr('method'),
        data: jQuery('#volunteerForm').serialize(),
        dataType : 'html',
        success: function (response) {
          $('#volunteerModalBody').empty();
          $('#volunteerModal').modal('hide');
          location.reload();
        },
        error: function (xhr, ajaxOptions, thrownError) {
          $('#volunteerModalBody').empty();
          $('#volunteerModalBody').html(xhr.responseText);
          $('#volunteerModalBody').scrollTop(0);
        }
    });
}