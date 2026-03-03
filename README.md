# 🎓 Online Placement Management System

The **Online Placement Management System** is a Java-based web application developed to automate and manage the campus placement process efficiently.

The system provides a centralized platform for **Students, Recruiters (Companies), and Admin** to manage placement activities seamlessly.

## 📌 Project Overview

This project simplifies the campus recruitment process by digitizing:

- Student registration and profile management
- Resume upload and download
- Company campus drive requests
- Job applications and tracking
- CGPA-based student filtering
- Admin approval and management

The system reduces manual work and improves transparency in placement activities.


## 👥 User Modules

### 👨‍🎓 Student Module
- Register and login
- Manage profile
- Upload resume
- View company list
- Apply for jobs
- Track application status

### 🏢 Recruiter / Company Module
- Login to system
- Request campus drive
- Add job details
- Filter students based on CGPA
- Shortlist candidates
- View applications
- Organize online aptitude tests

### 👨‍💼 Admin Module
- Admin login
- Manage students
- Approve/reject company requests
- Manage company listings
- Monitor applications
- Download student resumes

## 🛠️ Technologies Used

### Frontend
- JSP (JavaServer Pages)
- HTML
- CSS
- JavaScript

### Backend
- Java Servlets
- JDBC (Java Database Connectivity)

### Database
- MySQL

### Server
- Apache Tomcat

### IDE
- NetBeans IDE


## 🗂️ Project Structure

```
FinalDesignProject/
│
├── src/
│   ├── java/com/me/finaldesignproject/   # Servlet classes
│   ├── webapp/                          # JSP files
│
├── web/
│   ├── admin_login.jsp
│   ├── student_login.jsp
│   ├── company_dashboard.jsp
│   ├── student_dashboard.jsp
│   ├── web.xml
│
├── resumes/                             # Uploaded resume files
│
└── database.sql                         # Database structure (if included)
```

## 🗄️ Database Configuration

1. Install MySQL Server.
2. Create a database:

```sql
CREATE DATABASE design_engineering_portal;
```

3. Update database credentials inside your Servlet files:

```java
DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/design_engineering_portal",
    "root",
    "your_password"
);
```


## 🚀 How to Run the Project (Using NetBeans)

### Step 1: Install Required Software
- NetBeans IDE
- Apache Tomcat Server
- MySQL Server

### Step 2: Open Project in NetBeans
1. Open NetBeans.
2. Click **File → Open Project**.
3. Select the project folder.
4. Configure **Apache Tomcat** in Services if not already configured.

### Step 3: Configure Database
- Start MySQL server.
- Import or create required tables.
- Ensure database name and credentials match your code.

### Step 4: Run the Project
1. Right-click the project.
2. Click **Run**.
3. The project will deploy automatically on Tomcat.
4. Open in browser:

```
http://localhost:8080/FinalDesignProject/
```

## 🧪 Testing

The system was tested for:

- Registration & Login
- Resume Upload & Download
- Company Management
- Job Application Process
- CGPA Filtering
- Application Tracking

All modules were verified for correct functionality.

## ⚠️ Limitations

- Basic authentication security
- No email/SMS notifications
- Designed for institutional use only
- Limited scalability for large concurrent users

## 🔮 Future Scope

- Email notifications
- Real-time alerts
- Integration with external job portals
- Advanced analytics dashboard
- Enhanced security with encryption
- Cloud deployment support

## 👨‍💻 Developed By

**Jayshil**  
