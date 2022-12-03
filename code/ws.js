function cl(str) {console.log(str)}

function setVal(value, divId) {
    document.getElementById(divId).innerText = value;
    prepareRequest();
}

let selectOptions = "";
Object.keys(modeList).forEach(function(key) {
    selectOptions += '<option value="'+key+'">'+modeList[key]+'</option>';
});
document.getElementById('modeList').innerHTML = selectOptions;

function prepareRequest(){
    let str = ["mode="+document.getElementsByName('mode')[0].value];
    let inputs = document.getElementById('wsBlock').getElementsByTagName('input');
    Object.keys(inputs).forEach(function(key) {
        let inputName = inputs[key].name;
        let inputValue = inputs[key].value;
        if(inputName === "single_color" && inputValue) {inputValue = JSON.stringify(hexToGrb(inputValue));}
        if(inputName) {str.push(inputName+"="+inputValue)}
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
    return [arrByte[2], arrByte[1], arrByte[3]];
}