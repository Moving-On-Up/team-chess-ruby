$(document).ready(function () {
    // will call refreshParital every 3 seconds
    setInterval(refreshPartial, 15000)

});

function refreshPartial() {
    $.ajax({
    url: "/load_available"
    })
}