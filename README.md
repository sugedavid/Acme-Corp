# Acme Corp

A Flutter(web, android and iOS) project.

---

### Use Cases

[View use cases](lib/docs/use-cases.md)


## Getting Started

- To run the project using Visual Studion code add the following launch configuration:

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "acme_corp",
      "request": "launch",
      "type": "dart"
    },
    {
      "name": "acme_corp (profile mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile"
    },
    {
      "name": "acme_corp (release mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release"
    }
  ]
}
```

---

## Tools Used

1. [Firebase](https://firebase.google.com/docs)
   - Authentication - email and password
   - Realtime Database
   - Storage
2. [Riverpod - State Management](https://riverpod.dev/docs/getting_started)
3. [fl_chart - Chart Dashboard](https://pub.dev/packages/fl_chart)
4. [Github Actions - CI/CD](https://docs.github.com/en/actions)

---

## Screenshots

### Login

![login]()

### Register

![register]()

### Dashboard

![dashboard]()

### Tickets

![tickets]()

### Create Ticket

![create-ticket]()

### Ticket Info

![ticket-info]()

### Assign Agent

![assign-agent]()

### Assign Customer

![assign-customer]()
