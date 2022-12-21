let blueList = {
    'blueBright':{'label':'Яркость синего', 'min' : 0, 'max' : 225, 'step' : 1, 'value' : 30},
};
let blueListOptions = {
    'blueMinBright':{'label':'Минимальная яркость', 'min' : 0, 'max' : 225, 'step' : 1, 'value' : 30},
    'blueMaxBright':{'label':'Максимальная яркость', 'min' : 0, 'max' : 225, 'step' : 1, 'value' : 180},
    'blueSpeed':{'label':'Скорость', 'min' : 5, 'max' : 225, 'step' : 1, 'value' : 100},
    'blueStep':{'label':'Шаги', 'min' : 1, 'max' : 20, 'step' : 1, 'value' : 2},
};
let rangeList = {
    'buffer':{'label':'Количество диодов','min' : 1, 'max' : 80, 'step' : 1, 'value' : 64},
    'bright':{'label':'Яркость', 'min' : 0, 'max' : 225, 'step' : 1, 'value' : 30},
    'delay':{'label':'Задержка', 'min' : 10, 'max' : 225, 'step' : 1, 'value' : 30},
    'mode_options':{'label':'Опции режима', 'min' : 1, 'max' : 15, 'step' : 1, 'value' : 1}
};
let modeList = {'off': 'Выключить', 'static': 'Статичный', 'static-soft-blink': 'Статичный мягкий мигающий',
    'static-soft-random-blink': 'Случайный мягкий мигающий', 'round-static': 'По кругу статичный', 'round-random': 'По кругу случайный', 'rainbow': 'Радуга',
    'rainbow-circle': 'Радуга по кругу',};

gi('rangeList').innerHTML = generateRange(rangeList);
gi('pwmBlue').innerHTML = generateRange(blueList);
gi('optionsBlue').innerHTML = generateRange(blueListOptions);


let selectOptions = "";
Object.keys(modeList).forEach(function (key) {
    selectOptions += '<option value="' + key + '">' + modeList[key] + '</option>';
});
gi('modeList').innerHTML = selectOptions;

showBlocks();
setTimeout(loadSettings, 100);