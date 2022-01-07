$(document).ready(function(){
    window.addEventListener('message', function(event) {
        if (event.data.action == 'openPd') {
          $('#pd-card').css('display', 'flex');
          let photo = event.data.array.photo
          if (photo == "resimsiz") {
            $(".imgbox img").attr("src", "assets/images/pdresim.png");
          } else {
            $(".imgbox img").attr("src", event.data.array.photo);
          }
          $("#rankbox").html(event.data.array.rank)
          $("#namebox").html(event.data.array.name)
        } else if (event.data.action == 'open') {
            var userData    = event.data.array['user'];
            var licenseData = event.data.array['licenses'];
            var type = event.data.type;

            if (type == 'driver' || type == null) {
                $('img').show();
                $('#name').css('color', '#282828');
                if ( sex == 0 ) {
                  if ( userimage == "resimsiz" ) {
                    $("#new-user-photo img").attr("src", "assets/images/male.png");
                  } else {
                    $("#new-user-photo img").attr("src", userimage);
                  }
                  $('#sex').text('Erkek');
                } else {
                  if ( userimage == "resimsiz" ) {
                    $("#new-user-photo img").attr("src", "assets/images/female.png");
                  } else {
                    $("#new-user-photo img").attr("src", userimage);
                  }
                  $('#sex').text('Kadın');
                }
                
                $('#name').text(userData.name);
                $('#dob').text(userData.dob);
                $('#lastdigits').text(userData.lastdigits);
                $('#signature').text(userData.name);

                if ( type == 'driver' ) {
                    if ( licenseData != null ) {
                    Object.keys(licenseData).forEach(function(key) {
                      var type = licenseData[key].type;
                      if ( type == 'drive_bike') {
                        $('#licenses').append('<p>Motor</p>');
                      } else if ( type == 'drive_truck' ) {
                        $('#licenses').append('<p>Tır</p>');
                      } else if ( type == 'drive' ) {
                        $('#licenses').append('<p>Araba</p>');
                      } else if ( type == 'aircraft' ) {
                        $('#licenses').append('<p>Pilot</p>');
                      }
          
                    });
                  }
                  
                    $('#id-card').css('background', 'url(assets/images/license.png)');
                } else {
                    $('#id-card').css('background', 'url(assets/images/idcard.png)');
                }
            } else if ( type == 'weapon' ) {
              $('#name').css('color', '#d9d9d9');
              $('#name').text(userData.name);
              $('#dob').text(userData.dob);
              $('#signature').text(userData.name);
              $('#id-card').css('background', 'url(assets/images/firearm.png)');
            }

            $('#id-card').show();
        } else if (event.data.action == 'close') {
            $('#name').text('');
            $('#dob').text('');
            $('#height').text('');
            $('#signature').text('');
            $('#sex').text('');
            $('#id-card').hide();
            $('#pd-card').hide();
            $('#licenses').html('');
        }
    });
});