const messages = document.getElementById('scroll');
const chatform = document.getElementById('chat-form');
const chatheader = document.getElementById('chatheader');



var calcHeight = function() {
    let totalHeight = window.innerHeight;
    let totalWidth = window.innerWidth;

    console.log(`width: ${totalWidth}, height: ${totalHeight}`);

    console.log(`smallscreen`);
    calc = totalHeight - (chatform.offsetHeight + chatheader.offsetHeight + 200);
    messages.setAttribute("style",`height:${calc}px`);
};

window.addEventListener("resize", calcHeight);
window.addEventListener("onload", calcHeight);

const observer = new ResizeObserver(calcHeight);
ResizeObserver.observe(messages);

calcHeight();
