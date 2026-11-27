# calma-workspace

**Task:** techImp CW8 — Done

## Relational Database Schema

The full SQL schema is located in [`database/schema.sql`](database/schema.sql).

![Relational Tables Diagram](docs/Pastel%20ER%20Diagram_%20Users%2C%20Reservations%2C%20Payments.png)

## Database Tables Description

1. **USER**  
   Stores the information of all system users, including their names, email, password, phone number, and role (client, manager, or agent).
2. **CLIENT**  
   Stores additional information about clients, such as their client type and date of birth. It is linked to `USER`.
3. **SALLE**  
   Stores information about the available rooms, including their name, type, capacity, and equipment.
4. **PAYMENT_AGENT**  
   Identifies users who have the payment agent role. Its `user_id` is both a primary key and a foreign key referencing `USER`.
5. **TRACKING_AGENT**  
   Identifies users responsible for tracking and monitoring reservations. Linked to `USER` through `user_id`.
6. **MANAGER**  
   Identifies users who manage the system. Linked to `USER` through `user_id`.
7. **RESERVATION**  
   Stores booking information, including the client, reserved room, date, start and end times, number of people, billing mode, total price, and reservation status.
8. **PAYMENT**  
   Stores payment details, including the associated reservation and client, amount, payment method, status, payment date, and receipt number.

## Relationships Between Tables

| Relationship | Explanation |
| :--- | :--- |
| **USER – CLIENT** | A `USER` can have zero or one `CLIENT` profile. Each `CLIENT` belongs to exactly one `USER`. |
| **USER – PAYMENT_AGENT** | A `USER` can have zero or one `PAYMENT_AGENT` profile. |
| **USER – TRACKING_AGENT** | A `USER` can have zero or one `TRACKING_AGENT` profile. |
| **USER – MANAGER** | A `USER` can have zero or one `MANAGER` profile. |
| **SALLE – RESERVATION** | A `SALLE` can have zero or many reservations. Each reservation concerns exactly one `SALLE`. |
| **CLIENT – RESERVATION** | A `CLIENT` can make zero or many reservations. Each reservation belongs to exactly one `CLIENT`. |
| **RESERVATION – PAYMENT** | A reservation can have zero or one payment. Each payment belongs to exactly one reservation. |
| **CLIENT – PAYMENT** | A `CLIENT` can make zero or many payments. Each payment belongs to exactly one `CLIENT`. |

## Important Notes

- **PK (Primary Key):** Uniquely identifies each record in a table.
- **FK (Foreign Key):** Connects a table to another table.
- **UK (Unique Key):** Ensures that a value cannot be duplicated.

**Overall:** The database manages users and their roles, available rooms, client reservations, and their associated payments.
