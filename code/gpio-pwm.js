const pins = {5:5,6:6,7:7,8:8};
let htmlPwm = "";

for (const [key, value] of Object.entries(pins)) {

    htmlPwm += '<label><div class="label-name">' + pins[key] + '</div><input name="' + key + '" onchange="sendPwmStatus(this)"  ' +
        'type="range" value="0" min="0" max="1023" step="5"  class="range-slider" id="' + key + '"> ' +
        '<span class="badge" id="' + key + 'BId">0</span></label>';

}
document.getElementById('pwmBlock').innerHTML = htmlPwm;

function sendPwmStatus(e){
    document.getElementById(e.getAttribute('id')+"BId").innerHTML = e.value;
    let inputs = document.getElementsByTagName('input');
    let str = ['clock=500'];
    Object.keys(inputs).forEach(function(key) {
        str.push(inputs[key].name+"="+inputs[key].value)
    });
    sendPwmRequest (str.join('&'));
}

function sendPwmRequest (str){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) { console.log(xhr.responseText);}
    }
    xhr.open('GET', '/gpio-pwm.lc?'+str, true);
    xhr.send(null);
}


function loadSettings(){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            try {
                let response = JSON.parse(xhr.response);
                Object.keys(response).forEach(function (key) {
                    let e = document.getElementById(key);
                    if(e) {
                        e.value = Number(response[key]);
                        document.getElementById(key+"BId").innerHTML = Number(response[key]);
                    }
                });
            } catch (err) {
                console.log(err)
            }
        }
    }
    xhr.open('GET', '/json/pwm-action.json', true);
    xhr.send(null);
}
setTimeout(loadSettings, 500);