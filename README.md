# 🌾 Crop Insurance Management System (JSP | Servlet | JDBC | MySQL)

A **Dynamic Web Application** built using **Java (JSP + Servlet)**, **JDBC**, and **MySQL**, designed to help farmers register, apply for crop insurance, and manage claims easily.  
The system also provides an **Admin Panel** to manage policies, users, and insurance claims efficiently.

---

## 🚀 Features

### 👨‍🌾 Farmer / User Module
- Register and login securely  
- Apply for new crop insurance policies  
- View approved, pending, and rejected applications  
- Update personal and crop details  
- View claim history and policy status  

### 🛠️ Admin Module
- Secure admin login  
- Add, edit, or delete crop insurance policies  
- Manage registered farmers and their details  
- Approve or reject insurance applications  
- View all claims and generate reports  

---

## 🧱 Tech Stack

| Layer | Technology Used |
|-------|------------------|
| **Frontend** | HTML, CSS, JSP |
| **Backend** | Java Servlet, JSP |
| **Database** | MySQL (via JDBC) |
| **Server** | Apache Tomcat |
| **IDE** | Eclipse IDE for Enterprise Java Developers |

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository

git clone https://github.com/rajp6508/Crop-Insurance-System-JavaWebApp.git

2️⃣ Import the Project
Open Eclipse IDE

Go to File → Import → Existing Projects into Workspace

Browse and select the project folder

Click Finish

3️⃣ Configure the Database
Create a new database in MySQL (e.g., crop_insurance)

Import the SQL file:

sql
Copy code
SOURCE path_to_project/database/crop_insurance.sql;
Update your database credentials in the JDBC connection file (inside src/main/java/...)

4️⃣ Run the Project
Right-click on the project → Run on Server

Choose Apache Tomcat

Open your browser and visit:

arduino
Copy code
http://localhost:8080/CropInsuranceSystem/



👨‍💻 Author

👋 Raj Puri
📧 Email: rajp66228@gmail.com

⭐ Contribute / Support
If you found this project useful, please ⭐ it on GitHub to support my work!

🏁 License
This project is open-source and available under the MIT License.
