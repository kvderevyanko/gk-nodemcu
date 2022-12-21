function cl(str) {console.log(str);}
function prepareRequest(){
    showBlocks();
    let str = ["mode="+gi('modeList').value, 'blink='+(gi('blink').checked?1:0)];
    let inputs = document.getElementsByTagName('input');
    Object.keys(inputs).forEach(function(key) {
        let inputName = inputs[key].name;
        let inputValue = inputs[key].value;
        if(inputName === "single_color" && inputValue) {inputValue = JSON.stringify(hexToGrb(inputValue));}
        if(inputName && inputName !== "blink") {str.push(inputName+"="+inputValue)}
    });
    sendRequest(str.join('&'))
}
function sendRequest (str){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) { console.log(xhr.responseText);}
    }
    xhr.open('GET', '/ws.lc?'+str, true);
    xhr.send(null);
}
function hexToGrb(hex) {//Rgb
    hex = hex.replace("#", "");
    let arrBuff = new ArrayBuffer(4);
    let vw = new DataView(arrBuff);
    vw.setUint32(0,parseInt(hex, 16),false);
    let arrByte = new Uint8Array(arrBuff);
    return [arrByte[1], arrByte[2], arrByte[3]];
}
function setVal(value, divId) {
    if(divId) gi(divId).innerText = value;
    prepareRequest();
}
function gi(id){
    return document.getElementById(id);
}