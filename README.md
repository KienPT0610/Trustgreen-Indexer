# TrustGreen

## Giới thiệu dự án (Project Overview)

TrustGreen là một ứng dụng blockchain giúp truy xuất nguồn gốc sản phẩm qua chuỗi cung ứng. Người tiêu dùng có thể quét mã QR để xem hành trình của sản phẩm từ nguồn gốc đến tay họ, đảm bảo tính minh bạch và tin cậy.

## Tính năng chính (Features)

- Truy xuất nguồn gốc sản phẩm qua chuỗi cung ứng.
- Quét mã QR để xem thông tin chi tiết về hành trình sản phẩm.
- Lưu trữ dữ liệu minh bạch và không thể thay đổi trên blockchain.

## Tech Stack

- **Frontend**: Next.js
- **Backend**: Indexer (Node.js)
- **Blockchain**: EVM (smart contract viết bằng Solidity)
- **Deploy**: Docker Compose

## Cách cài đặt & chạy dự án (Installation & Usage)

### Yêu cầu hệ thống

- Node.js (>= 16.x)
- Docker và Docker Compose

### Cài đặt

1. Clone repository:

   ```bash
   git clone <repository-url>
   cd TrustGreen
   ```

2. Cài đặt dependencies cho từng thành phần:
   - **Frontend**:
     ```bash
     cd frontend
     npm install
     ```
   - **Backend**:
     ```bash
     cd backend
     npm install
     ```
   - **Contracts**:
     ```bash
     cd contracts
     npm install
     ```

### Chạy dự án

1. Chạy backend:

   ```bash
   cd backend
   npm run dev
   ```

2. Chạy frontend:

   ```bash
   cd frontend
   npm run dev
   ```

3. Triển khai smart contract (nếu cần):

   ```bash
   cd contracts
   npx hardhat run scripts/deploy.js --network <network-name>
   ```

4. Truy cập ứng dụng tại `http://localhost:3000`.

## Cách deploy (Deployment)

1. Đảm bảo Docker và Docker Compose đã được cài đặt.
2. Chạy lệnh sau để khởi động toàn bộ ứng dụng:
   ```bash
   docker-compose up --build
   ```
3. Ứng dụng sẽ chạy trên cổng được cấu hình trong `docker-compose.yml`.

## License

Dự án này được cấp phép theo giấy phép ISC. Xem thêm trong file LICENSE.
