# Notekeeper App

This is a simple notes application built with Rails 7 and Bootstrap 5. It allows users to add and delete notes.

## Features

- User registration and sign in (using Devise gem)
- Header with user information and note count
- Table with columns for line number, note text, author name, create date, and delete buttons
- Author column displays user's first name with tooltip showing full name
- Create date column displays note creation date with tooltip showing time of creation
- Delete column displays trash icon with tooltip saying "Delete". Confirmation popup appears when clicked.
- Different icon and tooltip shown if current user is not the author of the note
- New note input field shown at the bottom of the table for signed-in users
- Automatically saves notes in the database and displays new rows without refreshing the page using Hotwire
- Success message shown when note is successfully saved
- Responsive design with a table width between 300px and 640px
- Title positioned to the right of the table on screens wider than 860px
- Pagination with 5 rows per page for the table

## Installation

1. Clone the repository:
   ```shell
   git clone https://github.com/faceoff1/notekeeper.git
   ```
2. Navigate to the project directory
   ```shell
   cd notekeeper
   ```
3. Install the dependencies:
   ```shell
   bundle install
   yarn install
   bundle exec rake assets:precompile
   bundle exec rake assets:clean
   bundle exec rake db:migrate
   ```
4. Set up the database:
   ```shell
   rails db:create
   rails db:migrate
   ```
5. Start the Rails server
   ```shell
   rails server
   ```

## Testing

RSpec is used for testing the application. To run the tests, use the following command:
   ```shell
   bundle exec rspec
   ```

## Deployment

The application can be deployed to a hosting environment of your choice.
For deploy you allow to use build command sh file
   ```shell
   ./bin/render-build.sh
   ```
Also be sure to specify the environment variables
   ```shell
   DATABASE_URL
   RAILS_MASTER_KEY
   ```
