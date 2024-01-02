console.info("Teller Connect is loading");

const webviewScript = document.createElement("script");
webviewScript.type = "application/javascript";
webviewScript.defer = true;
webviewScript.src = "/assets/packages/flutter_inappwebview_web/assets/web/web_support.js";

const tellerConnectScript = document.createElement("script")
tellerConnectScript.src = "https://cdn.teller.io/connect/connect.js";

document.head.appendChild(webviewScript);
document.head.appendChild(tellerConnectScript);

console.info("Teller Connect scripts are loaded");


document.addEventListener("DOMContentLoaded", function () {
  console.info("Teller Connect is ready");
  
  let tellerConnect;

  window.setupTellerConnect = function setupTellerConnect(config) {
    tellerConnect = TellerConnect.setup({
      ...config,
      onSuccess: function (enrollment) {
        window.teller.onSuccess(JSON.stringify(enrollment));
      },
      onExit: function () {
        window.teller.onExit();
      },
    });
  }

  window.openTellerConnect = function openTellerConnect() {
    if (!tellerConnect) {
      throw Error("Teller Connect is not initialized. Use setupTellerConnect to initialize")
    }
    tellerConnect.open();
  }

  window.closeTellerConnect = function closeTellerConnect() {
    if (!tellerConnect) {
      throw Error("Teller Connect is not initialized. Use setupTellerConnect to initialize")
    }
    tellerConnect.close();
  }
});