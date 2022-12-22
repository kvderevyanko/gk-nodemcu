const pins = {5:"Красный",6:"Зелёный",7:"Синий",8:"Белый"};
let htmlGpio = "";
for (const [key, value] of Object.entries(pins)) {
    htmlGpio += '<label><input type="checkbox"  name="'+key+'"  id="'+key+'"  value="'+key+'" onchange="sendGpioStatus(this)"> '+value+'</label>';
}
document.getElementById('gpioBlock').innerHTML = htmlGpio;

function sendGpioStatus(e){
    let inputs = document.getElementsByTagName('input');
    let str = [];
    Object.keys(inputs).forEach(function(key) {
        str.push(inputs[key].name+"="+(inputs[key].checked?1:0))
    });
    sendGpioRequest (str.join('&'));
}
function sendGpioRequest (str){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) { console.log(xhr.responseText);}
    }
    xhr.open('GET', '/gpio.lc?'+str, true);
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
                    if(e && Number(response[key])) {
                        e.checked = true;
                    }
                });
            } catch (err) {
                console.log(err)
            }
        }
    }
    xhr.open('GET', '/json/gpio-action.json', true);
    xhr.send(null);
}
setTimeout(loadSettings, 500);