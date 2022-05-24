window.androidObj = function AndroidClass(){};
//
//var textContainer = document.createElement("p");
//var nativeText = document.createTextNode("Android Text");
//textContainer.appendChild(nativeText);
//
//var inputContainer = document.createElement("p");
//var input = document.createElement("INPUT");
//input.setAttribute("type", "text");
//inputContainer.appendChild(input);
//
//var buttonContainer = document.createElement("p");
//var button = document.createElement("button");
//button.innerHTML = "Send to Android";
//button.style.width = "150px";
//button.style.height = "30px";
//button.addEventListener ("click", function() {
//  window.androidObj.textToAndroid(input.value);
//});
//buttonContainer.appendChild(button);
//
//document.body.appendChild(textContainer);
//document.body.appendChild(inputContainer);
//document.body.appendChild(buttonContainer);
//
//function updateFromAndroid(message){
//    nativeText.nodeValue = message;
//}

function startTimer() {
    var setTime = setInterval(function () {
        console.log('increasing');
        if (isPaused)
            clearInterval(setTime);
        else {
            counter++;
            setLocalStorage("counter", counter + 1);
        }
    }, 1000);
}

function setLocalStorage(key, val) {
    if (getLocalStorageValue(key) !== null)
        removeLocalStorage(key);
    localStorage.setItem(key, val);
}

function getLocalStorageValue(key) {
    return localStorage.getItem(key);
}

function removeLocalStorage(key) {
    localStorage.removeItem(key);
}