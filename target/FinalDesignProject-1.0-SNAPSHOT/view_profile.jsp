<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%!
    private String safe(Object value) {
        if (value == null) {
            return "";
        }
        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Profile</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f5f5f5;
            padding: 40px 20px;
            animation: fadeInBody 0.7s ease;
        }

        * {
            box-sizing: border-box;
        }

        .profile-container {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(6px);
            padding: 30px;
            border-radius: 15px;
            max-width: 760px;
            margin: auto;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.3);
            animation: fadeInUp 0.8s ease;
        }

        h3 {
            text-align: center;
            color: #ffdd57;
            margin-bottom: 25px;
            animation: slideDown 0.7s ease;
        }

        .field-row {
            font-size: 16px;
            margin: 10px 0;
            padding: 12px 14px;
            border-radius: 8px;
            background-color: rgba(255, 255, 255, 0.05);
            transition: background-color 0.25s ease;
        }

        .field-row:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        strong {
            color: #ffdd57;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .no-data {
            text-align: center;
            padding: 20px;
            background-color: rgba(255, 0, 0, 0.1);
            color: #ff6b6b;
            border-radius: 10px;
        }

        .action-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 22px;
        }

        .btn {
            border: none;
            border-radius: 10px;
            padding: 12px 18px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.22);
        }

        .btn-primary {
            background: linear-gradient(135deg, #ffd54f, #ffb300);
            color: #1f2d3d;
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.12);
            color: #f5f5f5;
        }

        .message {
            margin-bottom: 18px;
            padding: 14px 16px;
            border-radius: 10px;
            font-size: 15px;
        }

        .message.success {
            background: rgba(46, 204, 113, 0.18);
            color: #8ef0b2;
        }

        .message.error {
            background: rgba(231, 76, 60, 0.18);
            color: #ff9d91;
        }

        .edit-panel {
            margin-top: 28px;
            padding: 24px;
            border-radius: 14px;
            background: rgba(0, 0, 0, 0.18);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .edit-panel h4 {
            margin-top: 0;
            margin-bottom: 18px;
            color: #ffdd57;
            font-size: 22px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        label {
            margin-bottom: 8px;
            color: #ffdd57;
            font-weight: 600;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            background: rgba(255, 255, 255, 0.08);
            color: #f5f5f5;
            font-size: 15px;
            outline: none;
        }

        input[readonly] {
            opacity: 0.8;
            cursor: not-allowed;
        }

        select option {
            color: #111;
        }

        textarea {
            resize: vertical;
            min-height: 110px;
        }

        .hint {
            margin-top: 8px;
            font-size: 13px;
            color: #d7dde8;
        }

        .hidden {
            display: none;
        }

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 720px) {
            body {
                padding: 20px;
            }

            .profile-container {
                padding: 22px;
            }

            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script>
        function toggleEditPanel(forceOpen) {
            var panel = document.getElementById("editPanel");
            if (!panel) {
                return;
            }

            if (typeof forceOpen === "boolean") {
                panel.classList.toggle("hidden", !forceOpen);
                return;
            }

            panel.classList.toggle("hidden");
        }
    </script>
</head>
<body>
    <div class="profile-container">
<%
    Map<String, Object> student = (Map<String, Object>) request.getAttribute("student");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    Boolean editMode = (Boolean) request.getAttribute("editMode");
    if (student != null) {
        String gender = String.valueOf(student.get("gender"));
%>
        <h3>&#127891; Your Profile</h3>

        <% if (success != null) { %>
            <div class="message success"><%= safe(success) %></div>
        <% } %>

        <% if (error != null) { %>
            <div class="message error"><%= safe(error) %></div>
        <% } %>

        <div class="field-row"><strong>Enrollment No:</strong> <%= safe(student.get("enrollment_no")) %></div>
        <div class="field-row"><strong>Full Name:</strong> <%= safe(student.get("full_name")) %></div>
        <div class="field-row"><strong>Email:</strong> <%= safe(student.get("email")) %></div>
        <div class="field-row"><strong>DOB:</strong> <%= safe(student.get("dob")) %></div>
        <div class="field-row"><strong>Branch:</strong> <%= safe(student.get("branch")) %></div>
        <div class="field-row"><strong>Contact:</strong> <%= safe(student.get("contact")) %></div>
        <div class="field-row"><strong>CGPA:</strong> <%= safe(student.get("cgpa")) %></div>
        <div class="field-row"><strong>Gender:</strong> <%= safe(student.get("gender")) %></div>
        <div class="field-row"><strong>Address:</strong> <%= safe(student.get("address")) %></div>

        <div class="action-bar">
            <a class="btn btn-secondary" href="DownloadResumeServlet?enrollment_no=<%= safe(student.get("enrollment_no")) %>">Download Resume</a>
            <button type="button" class="btn btn-primary" onclick="toggleEditPanel(true)">Edit Profile</button>
        </div>

        <div id="editPanel" class="edit-panel <%= Boolean.TRUE.equals(editMode) ? "" : "hidden" %>">
            <h4>Update Profile</h4>
            <form action="UpdateStudentProfileServlet" method="post" enctype="multipart/form-data">
                <div class="grid">
                    <div class="form-group">
                        <label for="enrollment_no">Enrollment No</label>
                        <input id="enrollment_no" type="text" name="enrollment_no" value="<%= safe(student.get("enrollment_no")) %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="full_name">Full Name</label>
                        <input id="full_name" type="text" name="full_name" maxlength="100" value="<%= safe(student.get("full_name")) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input id="email" type="email" name="email" maxlength="100" value="<%= safe(student.get("email")) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input id="dob" type="date" name="dob" value="<%= safe(student.get("dob")) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="branch">Branch</label>
                        <input id="branch" type="text" name="branch" maxlength="50" value="<%= safe(student.get("branch")) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="contact">Contact</label>
                        <input id="contact" type="text" name="contact" maxlength="15" value="<%= safe(student.get("contact")) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="cgpa">CGPA</label>
                        <input id="cgpa" type="number" name="cgpa" min="0" max="10" step="0.01" value="<%= safe(student.get("cgpa")) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender" required>
                            <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= "Other".equals(gender) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" required><%= safe(student.get("address")) %></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="resume">Replace Resume</label>
                        <input id="resume" type="file" name="resume" accept=".pdf,application/pdf">
                        <div class="hint">Leave this empty if you want to keep the current resume.</div>
                    </div>
                </div>

                <div class="action-bar">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <button type="button" class="btn btn-secondary" onclick="toggleEditPanel(false)">Cancel</button>
                </div>
            </form>
        </div>
<%
    } else {
%>
        <div class="no-data">&#10060; No profile data available.</div>
<%
    }
%>
    </div>
</body>
</html>
