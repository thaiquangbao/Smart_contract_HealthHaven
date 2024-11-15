// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

contract MedicalRecordContract {
    struct Patient {
        string fullName;
        string dateOfBirth;
        bool sex;
        string phone;
        string email;
        string image;
        string _id;
    }

    struct Doctor {
        string fullName;
        string email;
        string phone;
        string image;
        string _id;
    }

    struct Medical {
        string medicalName;
        uint256 quantity;
        string unitOfCalculation;
    }

    struct Date {
        uint256 day;
        uint256 month;
        uint256 year;
        string time;
    }

    struct MedicalRecord {
        string patient;
        string doctor;
        string diagnosisDisease;
        string symptoms;
        string note;
        Medical[] medical;
        string date;
        string appointment;
        string[] images;
        string _id;
    }

    struct MedicalInput {
        string[] medicalNames;
        uint256[] quantities;
        string[] unitsOfCalculation;
    }

    mapping(string => Patient) private patients;
    mapping(string => Doctor) private doctors;
    mapping(string => Date) private dates;
    mapping(string => Medical) private medicals;
    mapping(string => MedicalRecord) private medicalRecords;

    // Mảng để lưu trữ danh sách các ID
    string[] private patientIds;
    string[] private doctorIds;
    string[] private dateKeys;
    string[] private medicalKeys;
    string[] private medicalRecordIds;

    // Chuyển đổi uint thành chuỗi
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    function addPatient(
        string memory _fullName,
        string memory _dateOfBirth,
        bool _sex,
        string memory _phone,
        string memory _email,
        string memory _image,
        string memory _id
    ) public {
        Patient memory newPatient = Patient({
            fullName: _fullName,
            dateOfBirth: _dateOfBirth,
            sex: _sex,
            phone: _phone,
            email: _email,
            image: _image,
            _id: _id
        });
        
        patients[_id] = newPatient;
        patientIds.push(_id); // Lưu trữ ID vào mảng
    }

    function addDoctor(
        string memory _fullName,
        string memory _phone,
        string memory _email,
        string memory _image,
        string memory _id
    ) public {
        Doctor memory newDoctor = Doctor({
            fullName: _fullName,
            phone: _phone,
            email: _email,
            image: _image,
            _id: _id
        });
        
        doctors[_id] = newDoctor;
        doctorIds.push(_id); // Lưu trữ ID vào mảng
    }

    function addDate(
        uint _day,
        uint _month,
        uint _year,
        string memory _time
    ) public {
        Date memory newDate = Date({
            day : _day,
            month : _month,
            year : _year,
            time : _time
        });

        string memory key = string(abi.encodePacked(
            uint2str(_day),
            uint2str(_month),
            uint2str(_year),
            _time
        ));

        dates[key] = newDate;
        dateKeys.push(key); // Lưu trữ key vào mảng
    }

    function addMedicals(
        string memory _medicalName,
        uint256 _quantity,
        string memory _unitOfCalculation
    ) public {
        Medical memory newMedical = Medical({
            medicalName : _medicalName,
            quantity: _quantity,
            unitOfCalculation :  _unitOfCalculation
        });
        string memory key = string(abi.encodePacked(
            _medicalName,
            uint2str(_quantity),
            _unitOfCalculation
        ));
        medicals[key] = newMedical;
        medicalKeys.push(key); // Lưu trữ key vào mảng
    }

    function addMedicalRecord (
        string memory _patientId,
        string memory _doctorId,
        string memory _diagnosisDisease,
        string memory _symptoms,
        string memory _note,
        string memory _dateKey,
        string memory _appointment,
        string[] memory _images,
        string memory _id,
        MedicalInput memory medicalInput
    ) external {
        require(medicalInput.medicalNames.length == medicalInput.quantities.length && 
                medicalInput.quantities.length == medicalInput.unitsOfCalculation.length, 
                "Medical information arrays must have the same length");

        MedicalRecord storage newRecord = medicalRecords[_id];
        newRecord.patient = _patientId;
        newRecord.doctor = _doctorId;
        newRecord.diagnosisDisease = _diagnosisDisease;
        newRecord.symptoms = _symptoms;
        newRecord.note = _note;
        newRecord.date = _dateKey;
        newRecord.appointment = _appointment;
        newRecord.images = _images;
        newRecord._id = _id;

        // Thêm thông tin thuốc vào medical array
        for (uint256 i = 0; i < medicalInput.medicalNames.length; i++) {
            newRecord.medical.push(Medical({
                medicalName: medicalInput.medicalNames[i],
                quantity: medicalInput.quantities[i],
                unitOfCalculation: medicalInput.unitsOfCalculation[i]
            }));
        }

        medicalRecordIds.push(_id); // Lưu trữ ID vào mảng
    }


    // get

    function getPatient(string memory _id) public view returns (Patient memory) {
        return patients[_id];
    }

    function getDoctor(string memory _id) public view returns (Doctor memory) {
        return doctors[_id];
    }

    function getDate(string memory _key) public view returns (Date memory) {
        return dates[_key];
    }

    function getMedical(string memory _key) public view returns (Medical memory) {
        return medicals[_key];
    }

    function getMedicalRecord(string memory _key) public view returns (MedicalRecord memory) {
        return medicalRecords[_key];
    }

    // getAll functions

    function getAllPatients() public view returns (Patient[] memory) {
        Patient[] memory allPatients = new Patient[](patientIds.length);
        for (uint i = 0; i < patientIds.length; i++) {
            allPatients[i] = patients[patientIds[i]];
        }
        return allPatients;
    }

    function getAllDoctors() public view returns (Doctor[] memory) {
        Doctor[] memory allDoctors = new Doctor[](doctorIds.length);
        for (uint i = 0; i < doctorIds.length; i++) {
            allDoctors[i] = doctors[doctorIds[i]];
        }
        return allDoctors;
    }

    function getAllDates() public view returns (Date[] memory) {
        Date[] memory allDates = new Date[](dateKeys.length);
        for (uint i = 0; i < dateKeys.length; i++) {
            allDates[i] = dates[dateKeys[i]];
        }
        return allDates;
    }

    function getAllMedicals() public view returns (Medical[] memory) {
        Medical[] memory allMedicals = new Medical[](medicalKeys.length);
        for (uint i = 0; i < medicalKeys.length; i++) {
            allMedicals[i] = medicals[medicalKeys[i]];
        }
        return allMedicals;
    }

    function getAllMedicalRecords() public view returns (MedicalRecord[] memory) {
        MedicalRecord[] memory allRecords = new MedicalRecord[](medicalRecordIds.length);
        for (uint i = 0; i < medicalRecordIds.length; i++) {
            allRecords[i] = medicalRecords[medicalRecordIds[i]];
        }
        return allRecords;
    }
}
