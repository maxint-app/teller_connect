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