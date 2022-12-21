function generateRange(rangeList){
    let rangeListHtml = "";
    Object.keys(rangeList).forEach(function (key) {
    rangeListHtml += '<label><div class="label-name">' + rangeList[key]['label'] + '</div><input name="' + key + '" onChange="setVal(this.value, \'' + key + 'BId\')" ' +
        'type="range" min="' + rangeList[key]['min'] + '" max="' + rangeList[key]['max'] + '" step="' + rangeList[key]['step'] + '" ' +
        'value="' + rangeList[key]['value'] + '"  class="range-slider" id="' + key + '"> <span class="badge" id="' + key + 'BId">' + rangeList[key]['value'] + '</span></label>';
    });
return rangeListHtml;
}

function loadSettings(){
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            try {
                let response = JSON.parse(xhr.response);
                cl(response)
                Object.keys(response).forEach(function (key) {
                    if (key === "mode") {
                        gi('modeList').value = response[key];
                    } else if (key === "blink") {
                        if(Number(response[key])) gi(key).checked = true;
                    } else {
                        if(gi(key))  gi(key).value = response[key];
                        if(gi(key+'BId'))  gi(key+'BId').innerHTML = response[key];
                    }
                });
                showBlocks();
            } catch (err) {
                cl(err)
            }
        }
    }
    xhr.open('GET', '/json/ws-action.json', true);
    xhr.send(null);
}

function showBlocks(){
    if(gi('modeList').value === "off") {
        gi('wsBlock').style.display = 'none';
        gi('blueBlock').style.display = 'block';
        if(gi('blink').checked) {
            gi('optionsBlue').style.display = 'block';
            gi('pwmBlue').style.display = 'none';
        } else {
            gi('optionsBlue').style.display = 'none';
            gi('pwmBlue').style.display = 'block';
        }
    } else {
        gi('wsBlock').style.display = 'block'
        gi('blueBlock').style.display = 'none'
    }
}