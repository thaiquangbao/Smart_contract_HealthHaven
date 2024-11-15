const MedicalRecordContract = artifacts.require("MedicalRecordContract");
module.exports = function (deployer) {
  deployer.deploy(MedicalRecordContract);
}
// 