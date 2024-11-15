const { Web3 } = require('web3');
const MedicalRecordContract = require('./contracts/MedicalRecordContract.json');

// Kết nối Infura Sepolia
// const infuraUrl = 'http://127.0.0.1:7545/';
// const web3 = new Web3(new Web3.providers.HttpProvider(infuraUrl));
// const contract = new web3.eth.Contract(contractABI.abi, '0x1E64432C47c1F902B8B624F85122B6b4437bef9E');
const web3 = new Web3('http://3.1.85.125:8545/');
const contract = new web3.eth.Contract(MedicalRecordContract.abi, '0x8E41e9f6C84ED7E8963d81b908418b821dA00C06');
const checkBalance = async () => {
    try {
      
      // const data = await contract.methods.getAllPatients().call();
      // console.log('Contract:', data);
      
        const balance = await web3.eth.getBalance('0x1E64432C47c1F902B8B624F85122B6b4437bef9E');
        console.log('Account balance:', web3.utils.fromWei(balance, 'ether'), 'ETH');
    } catch (error) {
        console.error('Error fetching balance:', error);
    }
};

// checkBalance();

// Dữ liệu bệnh nhân cần thêm
const patientData = {
    fullName: "Thái Quang Bảo",
    dateOfBirth: "1990-01-01",
    sex: true, // true hoặc false
    phone: "123-456-7890",
    email: "john.doe@example.com",
    image: "https://example.com/image.jpg",
    id: "patient_id_123"
};

const addPatient = async () => {
    try {
        const data = contract.methods.addPatient(
            patientData.fullName,
            patientData.dateOfBirth,
            patientData.sex,
            patientData.phone,
            patientData.email,
            patientData.image,
            patientData.id
        ).encodeABI();

        // Lấy giá gas ước lượng từ mạng
        const gasEstimate = await web3.eth.estimateGas({
            to: '0x8E41e9f6C84ED7E8963d81b908418b821dA00C06',
            data: data,
            from: '0x1E64432C47c1F902B8B624F85122B6b4437bef9E'
        });

        // Lấy giá gas hiện tại
        const gasPrice = await web3.eth.getGasPrice();

        const tx = {
            from: '0x1E64432C47c1F902B8B624F85122B6b4437bef9E',
            to: '0x8E41e9f6C84ED7E8963d81b908418b821dA00C06',
            gas: gasEstimate,
            gasPrice: gasPrice,
            data: data
        };

        // Ký giao dịch
        const signedTx = await web3.eth.accounts.signTransaction(tx, '0x7d77ca663700d74a576d5198e020d3f7beda9d53ffded2c8bb7ed3c6837c1696');
        const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

        console.log('Transaction successful with hash:', receipt.transactionHash);
    } catch (error) {
        console.error('Error adding patient:', error);
    }
};

// addPatient();
async function getAllPatientss() {
  try {
   const data = await contract.methods.getAllPatients().call();
   console.log(data);
   
  } catch (error) {
    console.error("Lỗi khi lấy danh sách bệnh nhân:", error);
  }
}
// getAllPatientss()
async function getAllMedicalRecords() {
  try {
   const data = await contract.methods.getAllMedicalRecords().call();
   console.log('Data:', data);
   
   return data;
  } catch (error) {
    console.error("Lỗi khi lấy danh sách bệnh nhân:", error);
  }
}
// getAllMedicalRecords()
getData = async  () => {
  try {
    const www = await web3.eth.getTransaction('0xc77dd0a5f1040993d7e3d5f6bc316f6e43b673a150cdaeb7e9be9e0e414041f3')
   
    const decodedData = contract.decodeMethodData(www.data);
    
    console.log(decodedData);
  } catch (error) {
    console.log("null");
    
    return null;
  }
  
 
}
getData()
async function getOneMedicalRecords() {
  try {
   const data = await contract.methods.getMedicalRecord('66f3863e5a479bb1f5c25034g').call();
   console.log('Data:', data);
   
   return data;
  } catch (error) {
    console.error("Lỗi khi lấy danh sách bệnh nhân:", error);
  }
}
// getOneMedicalRecords()