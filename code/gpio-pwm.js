const pins = {5:"Красный",6:"Зелёный",7:"Синий",8:"Белый"};
let htmlPwm = "";

for (const [key, value] of Object.entries(pins)) {
    htmlPwm += '<b>'+value+'</b><br><input type="range" name="'+key+'" onchange="sendPwmStatus(this)" value="0" min="0" max="1023" step="5"><br><br>';
}
document.getElementById('pwmBlock').innerHTML = htmlPwm;

function sendPwmStatus(e){ sendPwmRequest (e.name+"="+e.value); }

function sendPwmRequest (str){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) { console.log(xhr.responseText);}
    }
    xhr.open('GET', '/gpio-pwm.lua?'+str, true);
    xhr.send(null);
}