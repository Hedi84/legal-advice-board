# Legal Advice Board

Legal Advice Board is a Ruby on Rails 8 application that allows users to ask legal questions, receive paid answers from lawyers, and rate the advice they receive.

## Live Demo

The application is available at:

**TODO:** `<deployment URL>`

## Demo Accounts

The application includes seeded demo users so each role can be explored immediately.

| Role | Email | Password |
|------|-------|----------|
| User | `user@example.com` | `password` |
| Lawyer | `lawyer@example.com` | `password` |
| Admin | `admin@example.com` | `password` |

## Setup

Requires Ruby 3.3.4 (see `.ruby-version`).

```bash
bundle install
bin/rails db:setup   # creates, migrates, and seeds the database
bin/rails s
```

Run the test suite:

```bash
bundle exec rspec
```

## Design Decisions

Rather than implementing every possible feature, I focused on building a complete application with a maintainable architecture, good automated test coverage and a polished user experience.

My priorities throughout the exercise were:

- A clean, intuitive user interface
- Good automated test coverage
- Clear separation of responsibilities
- A realistic mock payment flow using Hotwire/Turbo
- A lightweight but maintainable authorisation layer

## Assumptions

As some aspects of the exercise were intentionally left open to interpretation, I made the following assumptions while designing the application:

- A question can receive multiple answers from different lawyers.
- A lawyer may only answer a question once.
- Users purchase individual answers rather than the question itself, therefore payments belong to answers.
- Only the user who asked the original question can purchase and rate an answer.
- Each answer can only be rated once.
- Payments are simulated for the purposes of this exercise.

These assumptions allow users to compare different lawyers based on price and rating before deciding which answer to purchase.

## Architecture

The application intentionally uses a simple schema without unnecessary complexity. My aim was to build something that follows Rails conventions while remaining easy to understand and extend.

Some of the design decisions include:

- `proposed_fee_pounds` rather than `proposed_fee` to make the stored unit explicit.
- A lightweight `UserPermissions` policy object to separate authorisation from the controllers without introducing an additional dependency for a relatively small application.
- A dedicated `PaymentService` responsible for processing payments. Payment processing updates multiple parts of the application, so moving this logic into a service object keeps the controller focused on HTTP concerns while giving the payment flow a single responsibility.
- Ratings remain within the controller because they currently represent a single domain operation and did not justify introducing another service object.
- Authentication uses Rails' built-in `has_secure_password`, which I felt was sufficient for the scope of this exercise.
- SQLite was chosen for simplicity and ease of setup. For a production application I would likely choose PostgreSQL for its richer feature set.

Throughout the application I tried to follow standard Rails conventions, using model validations, associations and relatively lean controllers to keep responsibilities clearly separated.

## User Interface

Although I primarily work as a backend engineer, I wanted the application to feel complete and intuitive to use.

The interface uses a simple card-based layout with colour-coded status indicators so that the state of each question is immediately visible.

The exercise specifically requested the use of Hotwire/Turbo, so I chose to apply it to the payment flow. This allows the payment to be processed and the purchased answer to be revealed without requiring a full page refresh, creating a smoother user experience.

## Testing

Testing was one of my main priorities throughout the exercise.

The application includes:

- Model specs
- Request specs
- Policy specs
- Service specs
- An end-to-end feature spec

The feature spec demonstrates the application's primary user journey of submitting a question, purchasing legal advice, revealing the answer and rating it.

Given the scope of the exercise, I chose not to duplicate full end-to-end feature tests for every role. Instead, the lawyer and administrator behaviour is covered through request specs while the primary customer journey is verified through the feature test.

## Lawyer Rating System

The additional feature I chose to implement is a lawyer rating system.

As I developed the application, it became clear that users had very little information to help them choose between multiple lawyers beyond price alone.

Once a user has purchased an answer, they can rate it between one and five stars. The average rating is then displayed alongside future answers from that lawyer, allowing users to make a more informed decision when choosing legal advice.

I felt this was a natural extension of the application's domain and added genuine value to the user experience.

## Existing User Flows

### User

- Submit a legal question
- View their own questions
- View available answers
- Purchase an answer
- Reveal the purchased answer
- Rate the answer
- Close their own questions
- Delete their own questions

### Lawyer

- View all user questions
- Submit one answer per question

### Administrator

- View all questions
- Submit questions
- Answer questions
- Close questions
- Delete questions

Administrators intentionally cannot purchase answers.

## Future Improvements

If this application were developed further, I would prioritise:

- Editing questions before they have received answers.
- Editing answers before they have been purchased.
- Additional payment states such as `failed` and `cancelled`.
- Richer lawyer profiles including biography, areas of specialisation, verification and ratings.
- More comprehensive moderation workflows with lifecycle states such as:
  - Draft
  - Submitted
  - Withdrawn
  - Rejected
- Allowing administrators to delete answers independently of questions.
- Email notifications when lawyers answer questions.
- Real payment integration.
- Expanded end-to-end test coverage.

## Reflections

Given the suggested time constraints of the exercise, I deliberately focused on completing the full user journey with a maintainable architecture rather than introducing additional dependencies or production infrastructure.

Where possible I preferred simple Rails solutions over introducing additional gems. For example, I used a lightweight permission class and Rails' built-in authentication rather than full-featured libraries, allowing me to spend more time implementing and testing the application's core domain.

If I were to revisit the codebase, I would prioritise expanding end-to-end feature coverage before adding additional functionality.

## Technologies

- Ruby on Rails 8
- Hotwire / Turbo
- Stimulus
- SQLite
- RSpec
- FactoryBot
- RuboCop