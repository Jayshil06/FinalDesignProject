# FinalDesignProject

This repository contains a Java EE web application for managing companies and student applications as part of a final design project.

## Overview

The application provides the following features:

- Admin login and management of companies and student lists.
- Students can register, login, view available companies, apply to companies, and view their applications.
- Company details and listings are displayed using JSP pages.

## Technologies Used

- Java Servlet API
- JSP
- Maven for build management
- Tomcat as the target application server
- JPA (configured via `persistence.xml`) for persistence

## Project Structure

```
src/main/java                # Servlet and model classes under com.me.finaldesignproject
src/main/resources           # Persistence configuration
src/main/webapp              # JSP pages, HTML, web.xml, and static assets
src/test/java                # Unit tests
```

## Building and Running

1. Ensure Maven and Tomcat are installed.
2. Run `mvn clean package` to build the project.
3. Deploy the generated WAR (`target/FinalDesignProject-1.0-SNAPSHOT.war`) to a Tomcat server.

You can use the provided VS Code task labeled "Run Project" to build and deploy automatically.

## Notes

- Update the database configuration in `persistence.xml` as needed.
- The context path when deployed is `FinalDesignProject-1.0-SNAPSHOT` by default.

## License

This project is for academic purposes.