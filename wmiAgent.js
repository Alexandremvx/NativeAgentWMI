/* WmiJsAgent
PROTO: WmiVbsAgent
RULES:
 [X] Only JS
 [ ] connect to server through http(s)
 [ ] get wmi classes to send
 [ ] parse and collect wmi info
 [ ] send wmi info through http post
 [ ] adjust minimal interval
 [ ] return Exitcode to task scheduler


*/
var objWMIService = GetObject("winmgmts:\\\\.\\root\\CIMV2");
var objWMIClasses = new ActiveXObject("Scripting.Dictionary");

(function Main() {
    log("Iniciando WmiAgent v2");


})();


log(WScript.Arguments(0));

function UsingCScript() { return (WScript.FullName).toLowerCase().replace(/.*?\\/g, "") == "cscript.exe"; }
function getDateTime() { var dt = new Date(); var dtStr = (dt.getFullYear()) + "-" + ("0" + (1 + dt.getMonth())).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2) + " " + ("0" + dt.getHours()).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2); return dtStr };
function log(msg) { if (UsingCScript()) { WScript.StdOut.Write("[" + getDateTime() + "] " + msg); WScript.StdOut.WriteBlankLines(1); } }

