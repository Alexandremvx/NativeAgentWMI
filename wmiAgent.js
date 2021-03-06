/* WmiJsAgent
PROTO: WmiVbsAgent
RULES:
 [X] Only JScript
 [ ] connect to server through http(s)
 [ ] get wmi classes to send
 [ ] parse and collect wmi info
 [ ] send wmi info through http post
 [ ] adjust minimal interval
 [ ] return Exitcode to task scheduler


*/

//Include json2.js [https://github.com/douglascrockford/JSON-js]
if (typeof JSON !== "object") { JSON = {}; }; (function () { "use strict"; var rx_one = /^[\],:{}\s]*$/; var rx_two = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g; var rx_three = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g; var rx_four = /(?:^|:|,)(?:\s*\[)+/g; var rx_escapable = /[\\"\u0000-\u001f\u007f-\u009f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g; var rx_dangerous = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g; function f(n) { return (n < 10) ? "0" + n : n; } function this_value() { return this.valueOf(); } if (typeof Date.prototype.toJSON !== "function") { Date.prototype.toJSON = function () { return isFinite(this.valueOf()) ? (this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z") : null; }; Boolean.prototype.toJSON = this_value; Number.prototype.toJSON = this_value; String.prototype.toJSON = this_value; } var gap; var indent; var meta; var rep; function quote(string) { rx_escapable.lastIndex = 0; return rx_escapable.test(string) ? "\"" + string.replace(rx_escapable, function (a) { var c = meta[a]; return typeof c === "string" ? c : "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4); }) + "\"" : "\"" + string + "\""; } function str(key, holder) { var i; var k; var v; var length; var mind = gap; var partial; var value = holder[key]; if (value && typeof value === "object" && typeof value.toJSON === "function") { value = value.toJSON(key); } if (typeof rep === "function") { value = rep.call(holder, key, value); } switch (typeof value) { case "string": return quote(value); case "number": return (isFinite(value)) ? String(value) : "null"; case "boolean": case "null": return String(value); case "object": if (!value) { return "null"; } gap += indent; partial = []; if (Object.prototype.toString.apply(value) === "[object Array]") { length = value.length; for (i = 0; i < length; i += 1) { partial[i] = str(i, value) || "null"; } v = partial.length === 0 ? "[]" : gap ? ("[\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "]") : "[" + partial.join(",") + "]"; gap = mind; return v; } if (rep && typeof rep === "object") { length = rep.length; for (i = 0; i < length; i += 1) { if (typeof rep[i] === "string") { k = rep[i]; v = str(k, value); if (v) { partial.push(quote(k) + ((gap) ? ": " : ":") + v); } } } } else { for (k in value) { if (Object.prototype.hasOwnProperty.call(value, k)) { v = str(k, value); if (v) { partial.push(quote(k) + ((gap) ? ": " : ":") + v); } } } } v = partial.length === 0 ? "{}" : gap ? "{\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "}" : "{" + partial.join(",") + "}"; gap = mind; return v; } } if (typeof JSON.stringify !== "function") { meta = { "\b": "\\b", "\t": "\\t", "\n": "\\n", "\f": "\\f", "\r": "\\r", "\"": "\\\"", "\\": "\\\\" }; JSON.stringify = function (value, replacer, space) { var i; gap = ""; indent = ""; if (typeof space === "number") { for (i = 0; i < space; i += 1) { indent += " "; } } else if (typeof space === "string") { indent = space; } rep = replacer; if (replacer && typeof replacer !== "function" && (typeof replacer !== "object" || typeof replacer.length !== "number")) { throw new Error("JSON.stringify"); } return str("", { "": value }); }; } if (typeof JSON.parse !== "function") { JSON.parse = function (text, reviver) { var j; function walk(holder, key) { var k; var v; var value = holder[key]; if (value && typeof value === "object") { for (k in value) { if (Object.prototype.hasOwnProperty.call(value, k)) { v = walk(value, k); if (v !== undefined) { value[k] = v; } else { delete value[k]; } } } } return reviver.call(holder, key, value); } text = String(text); rx_dangerous.lastIndex = 0; if (rx_dangerous.test(text)) { text = text.replace(rx_dangerous, function (a) { return ("\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)); }); } if (rx_one.test(text.replace(rx_two, "@").replace(rx_three, "]").replace(rx_four, ""))) { j = eval("(" + text + ")"); return (typeof reviver === "function") ? walk({ "": j }, "") : j; } throw new SyntaxError("JSON.parse"); }; } }());

var agent = { version: "v2 beta", description: "WMI Js Agent", serverURL: getServerUrl() };
var objWMIService = GetObject("winmgmts:\\\\.\\root\\CIMV2");
var objWMIClasses = new ActiveXObject("Scripting.Dictionary");

(function Main() {
    log("Iniciando WmiAgent " + agent.version);
    //log(httpGet(agent.serverURL));
    //log(JSON.stringify(agent));
})();


wmiQuery("SELECT SerialNumber,BiosCharacteristics FROM win32_bios");
//wmiQuery("SELECT * FROM Win32_NetworkAdapter");

function wmiQuery(wmiQuery) {
    log(wmiQuery);
    var wmieItem = new Enumerator(objWMIService.ExecQuery(wmiQuery));
    for (; !wmieItem.atEnd(); wmieItem.moveNext()) {
        //log("Name: " + wmieItem.item().Name);
        var wmieProp = new Enumerator(wmieItem.item().Properties_);
        for (; !wmieProp.atEnd(); wmieProp.moveNext()) {
            wmiNowItem = wmieProp.item();
            // log(wmieProp.item().Name);
            // log(wmieProp.item());
            log("\t" + wmiNowItem.name + "[" + typeof (wmiNowItem.value) + "]: " + eval("wmieItem.item()." + wmiNowItem.name));
            //log(wmiNowItem.value instanceof Array); 
        }

        //log(typeof (wmieItem.item().Properties_));
    }


    /*On Error Resume Next
        dim WMIPropList, rSep, wVal
        rSep = ""
        wReq = LCase(wPropReq)
        wReqClass = Split(wReq,"$")(0)
        wProp = Split(wReq,"$")(1)
        For each wItem in getWMIClass(wReqClass)
          wVal = Eval("wItem."&wProp)
          if wVal <> "" then
            if VarType(Eval("wItem."&wProp)) = (vbVariant + vbArray) then
              wVal = join(Eval("wItem."&wProp),",")
            Else
              wVal = Eval("wItem."&wProp)
            end if
            WMIPropList = WMIPropList & rSep & wVal
            rSep = ","
          end if
          wVal = ""
        Next
        getWMIProp = WMIPropList    */
}


function getNetWorkAdapter() {
    var strComputer = ".";
    var objWMIService = GetObject("winmgmts:\\\\" + strComputer + "\\root\\cimv2");
    var colItems = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter", null, 48);
    var objItem = new Enumerator(colItems);
    for (; !objItem.atEnd(); objItem.moveNext()) {
        WScript.Echo("-----------------------------------");
        WScript.Echo("Win32_NetworkAdapter instance");
        WScript.Echo("-----------------------------------");
        WScript.Echo("Name: " + objItem.item().Name);
    }

}



function isArray(x) {
    return x.constructor.toString().indexOf("Array") > -1;
}
function httpPost(sUrl, sRequest) { var oHTTP = new ActiveXObject("Microsoft.XMLHTTP"); try { oHTTP.open("POST", sUrl, false); oHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); oHTTP.setRequestHeader("Content-Length", sRequest.length); oHTTP.send(sRequest); if (oHTTP.status != 200) exitReason(204, "Erro ao acessar [" + sUrl + "] HTTP_" + oHTTP_status); } catch (err) { exitReason(204, "Erro ao acessar [" + sUrl + "]: " + err.message); } return oHTTP.responseText; }
function httpGet(sUrl) { var oHTTP = new ActiveXObject("Microsoft.XMLHTTP"); try { oHTTP.open("GET", sUrl, false); oHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); oHTTP.send(); if (oHTTP.status != 200) exitReason(204, "Erro ao acessar [" + sUrl + "] HTTP_" + oHTTP_status); } catch (err) { exitReason(204, "Erro ao acessar [" + sUrl + "]: " + err.message); } return oHTTP.responseText; }
function getServerUrl() { if (WScript.Arguments.length < 1) exitReason(160, "[ERRO] NECESSARIO ESPECIFICAR A URL DE DESTINO"); return WScript.Arguments(0); }
function exitReason(eCode, eMessage) { log(eMessage); WScript.quit(eCode); }
function usingCScript() { return (WScript.FullName).toLowerCase().replace(/.*?\\/g, "") == "cscript.exe"; }
function getDateTime() { var dt = new Date(); var dtStr = (dt.getFullYear()) + "-" + ("0" + (1 + dt.getMonth())).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2) + " " + ("0" + dt.getHours()).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2); return dtStr };
function log(msg) { if (usingCScript()) { WScript.StdOut.Write("[" + getDateTime() + "] " + msg); WScript.StdOut.WriteBlankLines(1); } }




