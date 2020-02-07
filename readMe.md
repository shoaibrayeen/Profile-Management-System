## Profile Management System
<img src="/image/made_with_ror.jpeg" width="200" height="50">


### Overview
- Profiles are user accounts(seller/buyers in context of E commerce / Any selling buying company etc) which are created to save information regarding users to server them better in a system. Generally it compromised with APIs to get/create/update profiles of users and a panel to view/search/edit profiles by admins.
- For more details - [Requirements](./requirement.md)

### Getting Started with Project
Prerequisite
- Rails Version 5.1.7
- Ruby 2.4.1
- Elasticsearch Server for Searching
- Sidekiq for Background Processing
- PostgreSQL for Database
- Redis for Caching and to use along with Sidekiq


Clone the repository
```sh
  > git clone https://github.com/shoaibrayeen/Profile-Management-System
  > cd Profile-Management-System
```
Setting up with PostgreSQL
```
  # Create a database user with your PostgreSQL Terminal
  # Go to config -> database.yml
  and change these two details according to your database user
  username: userName
  password: PASSWORD
```

Install required dependencies
```sh
  > bundle install
```

Creating Database for Development and Testing Environment
```sh
  > bundle exec rake db:drop
  > bundle exec rake db:create
  > bundle exec rake db:migrate
```

Starting with App
```
  # To Start Elastic Search Server
  > sudo -i service elasticsearch start
  
  # To Start Sidekiq Server - Redis-Server needed to run sidekiq
  > bundle exec sidekiq
  
  # To run the app
  > bundle exec rails server
  
  # Now go to your browser and run
  localhost:3000
  # Your app is running
```
To check all the routes
```sh
  > rake routes
```

To Use Model
```sh
  # To see all the database using PostgreSQL
  > bundle exec rails db
  postgres >>> SELECT * FROM TABLE_NAME;
  
  # To see all the database using Rails console
  > rails c
  > model_name.all
  
```

To Use POSTMAN API
```sh
  # After Starting Server
  # Go to POSTMAN APP
  
  localhost:3000/api/get_profile #Give id and get Information
  
  
  localhost:3000/api/signup #Give related information in the body and it'd validate accordingly
  
  
  localhost:3000/api/signin #Give email and password in the body and it'd validate accordingly
  
```

### License
[![Apache License](https://img.shields.io/badge/license-Apache-brightgreen.svg)](http://www.apache.org/licenses/)

**Copyright (c) 2020 Mohd Shoaib Rayeen**

This project is licensed under the Apache License - see the LICENSE file for details
