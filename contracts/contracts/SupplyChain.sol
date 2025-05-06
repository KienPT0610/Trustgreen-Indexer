// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title SupplyChain
 * @dev Hợp đồng thông minh cho module Quản lý Chuỗi Cung Ứng của TrustGreen
 */
contract SupplyChain {
    // Sự kiện
    event ProductCreated(bytes32 indexed productId, address indexed supplier);
    event CheckpointAdded(bytes32 indexed productId, bytes32 indexed checkpointId);
    event SupplierRegistered(address indexed supplier, string name);
    event CertificateAdded(bytes32 indexed certificateId, address entity);
    
    // Cấu trúc dữ liệu
    struct Product {
        bytes32 id;
        string name;
        string description;
        string category;
        address supplier;
        uint256 createdAt;
        bool exists;
    }
    
    struct Checkpoint {
        bytes32 id;
        bytes32 productId;
        string checkpointType;
        string location;
        string description;
        string imageHash;
        uint256 timestamp;
        address createdBy;
        bool exists;
    }
    
    struct Supplier {
        address id;
        string name;
        string location;
        bool verified;
        bool exists;
    }
    
    struct Certificate {
        bytes32 id;
        string name;
        string issuedBy;
        uint256 issuedDate;
        uint256 expiryDate;
        string documentUrl;
        bool verified;
        bool exists;
    }
    
    // Ánh xạ (Mappings)
    mapping(bytes32 => Product) public products;
    mapping(bytes32 => Checkpoint) public checkpoints;
    mapping(bytes32 => bytes32[]) public productCheckpoints;
    mapping(address => Supplier) public suppliers;
    mapping(address => bool) public admins;
    mapping(bytes32 => Certificate) public certificates;
    mapping(bytes32 => bytes32[]) public productCertificates;
    mapping(address => bytes32[]) public supplierCertificates;
    
    address public owner;
    
    // Constructor
    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admin can call this function");
        _;
    }
    
    modifier onlySupplier() {
        require(suppliers[msg.sender].exists, "Only registered supplier can call this function");
        _;
    }
    
    // Supplier management
    function registerSupplier(string memory _name, string memory _location) public {
        require(!suppliers[msg.sender].exists, "Supplier already registered");
        
        suppliers[msg.sender] = Supplier({
            id: msg.sender,
            name: _name,
            location: _location,
            verified: false,
            exists: true
        });
        
        emit SupplierRegistered(msg.sender, _name);
    }
    
    function verifySupplier(address _supplier) public onlyAdmin {
        require(suppliers[_supplier].exists, "Supplier does not exist");
        suppliers[_supplier].verified = true;
    }
    
    // Product management
    function createProduct(
        string memory _name,
        string memory _description,
        string memory _category
    ) public onlySupplier returns (bytes32) {
        require(suppliers[msg.sender].verified, "Supplier not verified");
        
        bytes32 productId = keccak256(abi.encodePacked(
            _name,
            _description,
            msg.sender,
            block.timestamp
        ));
        
        require(!products[productId].exists, "Product ID already exists");
        
        products[productId] = Product({
            id: productId,
            name: _name,
            description: _description,
            category: _category,
            supplier: msg.sender,
            createdAt: block.timestamp,
            exists: true
        });
        
        emit ProductCreated(productId, msg.sender);
        
        return productId;
    }
    
    // Checkpoint management
    function addCheckpoint(
        bytes32 _productId,
        string memory _checkpointType,
        string memory _location,
        string memory _description,
        string memory _imageHash
    ) public returns (bytes32) {
        require(products[_productId].exists, "Product does not exist");
        require(
            msg.sender == products[_productId].supplier || admins[msg.sender],
            "Only supplier or admin can add checkpoint"
        );
        
        bytes32 checkpointId = keccak256(abi.encodePacked(
            _productId,
            _checkpointType,
            block.timestamp,
            msg.sender
        ));
        
        checkpoints[checkpointId] = Checkpoint({
            id: checkpointId,
            productId: _productId,
            checkpointType: _checkpointType,
            location: _location,
            description: _description,
            imageHash: _imageHash,
            timestamp: block.timestamp,
            createdBy: msg.sender,
            exists: true
        });
        
        productCheckpoints[_productId].push(checkpointId);
        
        emit CheckpointAdded(_productId, checkpointId);
        
        return checkpointId;
    }
    
    // Certificate management
    function addCertificate(
        string memory _name,
        string memory _issuedBy,
        uint256 _issuedDate,
        uint256 _expiryDate,
        string memory _documentUrl
    ) public onlyAdmin returns (bytes32) {
        bytes32 certificateId = keccak256(abi.encodePacked(
            _name,
            _issuedBy,
            _issuedDate,
            _expiryDate,
            block.timestamp
        ));
        
        certificates[certificateId] = Certificate({
            id: certificateId,
            name: _name,
            issuedBy: _issuedBy,
            issuedDate: _issuedDate,
            expiryDate: _expiryDate,
            documentUrl: _documentUrl,
            verified: true,
            exists: true
        });
        
        emit CertificateAdded(certificateId, msg.sender);
        
        return certificateId;
    }
    
    function linkCertificateToProduct(bytes32 _certificateId, bytes32 _productId) public onlyAdmin {
        require(certificates[_certificateId].exists, "Certificate does not exist");
        require(products[_productId].exists, "Product does not exist");
        
        productCertificates[_productId].push(_certificateId);
    }
    
    function linkCertificateToSupplier(bytes32 _certificateId, address _supplier) public onlyAdmin {
        require(certificates[_certificateId].exists, "Certificate does not exist");
        require(suppliers[_supplier].exists, "Supplier does not exist");
        
        supplierCertificates[_supplier].push(_certificateId);
    }
    
    // View functions
    function getProductCheckpoints(bytes32 _productId) public view returns (bytes32[] memory) {
        return productCheckpoints[_productId];
    }
    
    function getProductCertificates(bytes32 _productId) public view returns (bytes32[] memory) {
        return productCertificates[_productId];
    }
    
    function getSupplierCertificates(address _supplier) public view returns (bytes32[] memory) {
        return supplierCertificates[_supplier];
    }
    
    // Admin management
    function addAdmin(address _admin) public onlyOwner {
        admins[_admin] = true;
    }
    
    function removeAdmin(address _admin) public onlyOwner {
        require(_admin != owner, "Cannot remove owner from admins");
        admins[_admin] = false;
    }
}