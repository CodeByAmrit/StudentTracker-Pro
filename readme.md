# Student Tracker

Student Tracker is a comprehensive Student Management System designed for schools to simplify student data management. It allows teachers to register students, store essential documents, generate reports, and more.

## 🚀 Features

- **Teacher Dashboard**: Manage students, view statistics, and access all features from a central dashboard.
- **Student Management**: Register new students, edit existing student information, and view a list of all students.
- **Document Management**: Upload and manage student files such as documents, photos, and signatures.
- **Certificate Generation**:
  - Generate **Annual Report Cards** in PDF format.
  - Create and download **Achievement Certificates**.
  - Issue **Virtual ID Cards**.
- **AI Chat**: An integrated AI chat feature to assist teachers.
- **Secure Authentication**: Secure login for teachers with password hashing.

## 🛠️ Tech Stack

- **Backend**: Node.js, Express.js
- **Frontend**: EJS (Embedded JavaScript templates), Tailwind CSS, Flowbite
- **Database**: MySQL (using the `mysql2` library)
- **Authentication**: JWT (JSON Web Tokens) stored in cookies.
- **File Handling**: `pdf-lib` for PDF generation, `multer` for file uploads.
- **Security**: `helmet` for securing HTTP headers, `express-rate-limit` for rate limiting, and dynamic CSP nonces to prevent XSS attacks.

## ⚙️ Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v24.20.0 LTS or later)
- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)

### Local Development

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/CodeByAmrit/school.git
    cd school
    ```

2.  **Install dependencies:**

    ```sh
    npm install
    ```

3.  **Set up environment variables:**

    Create a `.env` file in the root of the project and add the following variables:

    ```env
    DB_HOST=your-database-host
    DB_USER=your-database-user
    DB_PASSWORD=your-database-password
    DB_DATABASE=your-database-name
    DB_PORT=your-database-port
    JWT_SECRET=your-jwt-secret
    EMAIL_ID=your-email-address
    EMAIL_PASSWORD=your-email-password
    ```

4.  **Run the application:**

    ```sh
    npm run dev
    ```

    The server will start in development mode with nodemon at `http://localhost:4000`.

## 🐳 Docker

This project is fully containerized and can be run using Docker.

### Running with Docker Compose

The easiest way to run the application in a production-like environment is with `docker-compose`.

1.  **Start the service:**

    ```sh
    docker-compose up
    ```

    This will use the pre-built image `codebyamrit/student-tracker` from Docker Hub. The application will be available at `http://localhost:8080`.

### Building the Docker Image

You can also build the Docker image from the source code.

1.  **Build the image:**

    ```sh
    docker build -t your-dockerhub-username/student-tracker .
    ```

2.  **Run the container:**

    ```sh
    docker run -d -p 8080:5000 --name student-tracker your-dockerhub-username/student-tracker
    ```

## 🔄 CI/CD

This project uses **GitHub Actions** for continuous integration and deployment.

- **Workflow**: `.github/workflows/docker-image.yml`
- **Trigger**: The workflow is triggered on every `push` to the `create-docker-image` branch.
- **Action**: It builds a new Docker image and pushes it to [Docker Hub](https://hub.docker.com/r/codebyamrit/student-tracker) with the tags `latest` and a build number (e.g., `123`).

This setup automates the process of creating a new Docker image whenever changes are pushed to the specified branch, ensuring that the latest version of the application is always ready for deployment.

## 📝 License

This project is licensed under the **ISC License**. See the `LICENSE` file for details.
