# BookAura

BookAura is a full-stack digital library platform that allows users to discover, read, and manage books and stories. The project is divided into two main repositories:

- **Frontend:** A Flutter application for mobile and web, providing a modern, responsive user interface.
- **Backend:** A RESTful API built with NestJS and MongoDB, handling authentication, book management, user profiles, and more.

## Features

- User authentication and profile management
- Browse, search, and filter books and stories
- Add, edit, and remove books (CRUD)
- Bookmark and manage personal library
- Responsive UI for mobile and web
- Riverpod for state management (Flutter)
- Dio for REST API calls (Flutter)
- MongoDB for persistent storage (Backend)

## Architecture

The project follows a layered architecture:

- **Presentation Layer:** UI and widgets (Flutter)
- **State Management Layer:** Riverpod providers and notifiers
- **Domain Layer:** Models and business logic
- **Data Layer:** API services (Dio) and repositories
- **Persistence Layer:** MongoDB and SharedPreferences

## Repositories

- [Frontend (Flutter)](https://github.com/your-org/bookaura-frontend)
- [Backend (NestJS)](https://github.com/your-org/bookaura-backend)

## Getting Started

See the individual frontend and backend README files for setup and usage instructions.

## License

This project is licensed under the MIT License.
