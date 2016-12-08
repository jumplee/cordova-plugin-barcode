cordova.define("cordova-plugin-barcode", function(require, exports, module) {
    var exec = require("cordova/exec");
    var BarcodeScan = function() {};
    BarcodeScan.prototype.scan = function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "BarcodeScan", "scan", []);
    }
    module.exports = new BarcodeScan();
});