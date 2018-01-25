
jQuery(document).ready(function() {
	
    /*
        Fullscreen background
    */
    $.backstretch("/img/1.jpg");
    
    /*
        Form validation
    */
    $('.login-form input[type="text"], .login-form input[type="password"], .login-form textarea').on('focus', function() {
    	$(this).removeClass('input-error');
    });
    
    $('.login-form').on('submit', function(e) {

    	$(this).find('input[type="text"], input[type="password"], textarea').each(function(){
    		if( $(this).val() == "" ) {
    			e.preventDefault();
    			$(this).addClass('input-error');
    		}
    		else {
    			$(this).removeClass('input-error');
    		}
    	});

        // var username = document.getElementById("form-username");
        // if(!(/^[0-9a-zA-Z]*$/.test(username.value))){
         //    e.preventDefault();
         //    $(username).focus();
         //    $(username).addClass('input-error');
        // }
        //
		// var password = document.getElementById("form-password");
		// var repsword = document.getElementById("form-repassword");
        // if(password.length<6){
         //    e.preventDefault();
         //    $(password).focus();
         //    $(password).addClass('input-error');
        // }
        // if(repsword.length<6){
         //    e.preventDefault();
         //    $(repsword).focus();
         //    $(repsword).addClass('input-error');
        // }
		// if(password.value != repsword.value) {
		// 	e.preventDefault();
         //    $(password).focus();
		// 	$(password).addClass('input-error');
		// 	$(repsword).addClass('input-error');
		// }

        //var mobile = document.getElementById("form-phone")
        //if(!(/^1[3|4|5|8][0-9]\d{4,8}$/.test(mobile.value))){
        //    e.preventDefault();
        //    $(mobile).focus();
        //    $(mobile).addClass('input-error');
        //}

    });

    var code = document.getElementById("form-code-image");
    code.onclick = function(){
        code.src = '/captcha?time='+new Date();
    }

    // var step = 59;
    // var sms = document.getElementById("form-sms-button");
    // sms.onclick = function(){
    //     $.ajax({
    //         url: '/func/sms_send',
    //         method: 'POST',
    //         data: "phone="+$("#form-phone").val(),
    //         processData: false,
    //         contentType: 'application/x-www-form-urlencoded',
    //         headers: {
    //             'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    //         },
    //         success: function(result) {
    //             if(result == 'true'){
    //                 $(sms).text('重新发送60');
    //                 var _res = setInterval(function()
    //                 {
    //                     $(sms).attr("disabled", true);//设置disabled属性
    //                     $(sms).text('重新发送'+step);
    //                     step-=1;
    //                     if(step <= 0){
    //                         $(sms).removeAttr("disabled"); //移除disabled属性
    //                         $(sms).text('获取验证码');
    //                         clearInterval(_res);//清除setInterval
    //                     }
    //                 },1000);
    //             }
    //         }
    //     });
    // }

});
