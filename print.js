function printdiv(a) {
    var headstr = "<html><head><title></title></head><body>";
    var footstr = "</body>";
    var newstr = document.getElementById(a).innerHTML;
    var oldstr = document.body.innerHTML;
    document.body.innerHTML = headstr + newstr + footstr;
    window.print();
    document.body.innerHTML = oldstr;

    return false;
}
window.addEventListener("afterprint", (event) => {
  console.log("After print");
  window.location.reload(true);
});
