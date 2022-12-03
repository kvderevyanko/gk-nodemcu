const pins = {5:"Красный",6:"Зелёный",7:"Синий",8:"Белый"};
let htmlGpio = "";

for (const [key, value] of Object.entries(pins)) {
    htmlGpio += '<li><label><input type="checkbox" value="'+key+'" onchange="sendGpioStatus(this)"> '+value+'</label></li>';
}
document.getElementById('gpioBlock').innerHTML = htmlGpio;

function sendGpioStatus(e){ sendRequest (e.value+"="+(e.checked?1:0)); }

function sendRequest (str){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) { console.log(xhr.responseText);}
    }
    xhr.open('GET', '/gpio.lc?'+str, true);
    xhr.send(null);
}